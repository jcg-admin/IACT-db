# Integration Patterns Guide

## Executive Summary

### Purpose

This document provides comprehensive guidance for integrating automation agents within the IACT project's DevOps infrastructure. It establishes standardized patterns for building, orchestrating, and maintaining automation components across the development lifecycle.

### Target Audience

- DevOps Engineers implementing automation workflows
- Backend Developers integrating agents into CI/CD pipelines
- System Architects designing automation infrastructure
- Technical Leads establishing integration standards

### Integration Philosophy

Our integration approach follows these core principles:

1. **Separation of Concerns**: Bash for orchestration, Python for business logic
2. **Event-Driven Architecture**: Git hooks and lifecycle events trigger automated workflows
3. **Configuration as Code**: YAML-based declarative configuration with schema validation
4. **Graceful Degradation**: Failures in automation should not block critical workflows
5. **Observable Systems**: Comprehensive metrics and logging at every integration point
6. **Developer Experience**: Minimal friction, maximum automation

### Quick Navigation

- [Core Integration Patterns](#core-integration-patterns) - 8 fundamental patterns
- [Development Lifecycle](#integration-with-development-lifecycle) - Git hooks, CI/CD, DevContainer
- [Advanced Scenarios](#advanced-integration-scenarios) - Multi-repo, custom agents, performance
- [Security](#security-considerations) - Input validation, secrets, isolation
- [Troubleshooting](#troubleshooting-integration-issues) - Common problems and solutions
- [Migration](#migration-guides) - Adopting automation in existing projects
- [Best Practices](#best-practices-and-anti-patterns) - Recommended patterns and pitfalls
- [Reference](#reference-implementation) - Complete working examples

---

## Core Integration Patterns

### Pattern 1: Bash Entry Point + Python Business Logic

#### Rationale for Hybrid Architecture

The hybrid Bash/Python architecture leverages the strengths of both languages:

- **Bash**: System integration, environment setup, orchestration, exit code management
- **Python**: Complex logic, data processing, API interactions, testing

This separation enables:
- Clear boundaries between orchestration and business logic
- Testable Python components without shell dependencies
- Standard Unix tooling for process management
- Type-safe data processing in Python

#### Implementation Template

**Bash Entry Point** (`scripts/agents/example_agent.sh`):

```bash
#!/usr/bin/env bash

set -euo pipefail

# Script metadata
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
readonly AGENT_NAME="example_agent"

# Load common utilities
source "${SCRIPT_DIR}/../utils/common.sh"

# Python agent path
readonly PYTHON_AGENT="${SCRIPT_DIR}/../../automation/agents/${AGENT_NAME}.py"

# Main execution
main() {
    local config_file="${1:-}"
    local dry_run="${2:-false}"

    # Validate prerequisites
    check_python_version "3.9"
    check_file_exists "${PYTHON_AGENT}"

    # Prepare input JSON
    local input_json
    input_json=$(create_agent_input "${config_file}" "${dry_run}")

    # Execute Python agent
    local output_json
    local exit_code=0

    if output_json=$(python3 "${PYTHON_AGENT}" "${input_json}" 2>&1); then
        handle_success "${output_json}"
    else
        exit_code=$?
        handle_failure "${output_json}" "${exit_code}"
        return "${exit_code}"
    fi
}

# Create standardized input JSON
create_agent_input() {
    local config_file="$1"
    local dry_run="$2"

    cat <<EOF
{
    "config_file": "${config_file}",
    "dry_run": ${dry_run},
    "project_root": "${PROJECT_ROOT}",
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "environment": {
        "git_branch": "$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')",
        "git_commit": "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')"
    }
}
EOF
}

# Handle successful execution
handle_success() {
    local output="$1"

    # Parse and log results
    echo "${output}" | jq -r '.message // "Operation completed successfully"'

    # Extract metrics if present
    if echo "${output}" | jq -e '.metrics' > /dev/null 2>&1; then
        log_metrics "${output}"
    fi

    return 0
}

# Handle execution failure
handle_failure() {
    local output="$1"
    local exit_code="$2"

    log_error "Agent execution failed with exit code ${exit_code}"

    # Attempt to parse structured error
    if echo "${output}" | jq -e '.error' > /dev/null 2>&1; then
        echo "${output}" | jq -r '.error.message'
        echo "${output}" | jq -r '.error.details // empty'
    else
        echo "${output}"
    fi

    return "${exit_code}"
}

# Execute main function
main "$@"
```

**Python Business Logic** (`automation/agents/example_agent.py`):

```python
#!/usr/bin/env python3
"""
Example automation agent demonstrating the integration pattern.
"""

import json
import sys
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Dict, Any, Optional
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


@dataclass
class AgentInput:
    """Standardized agent input structure."""
    config_file: str
    dry_run: bool
    project_root: str
    timestamp: str
    environment: Dict[str, str]

    @classmethod
    def from_json(cls, json_str: str) -> 'AgentInput':
        """Parse input from JSON string."""
        data = json.loads(json_str)
        return cls(**data)


@dataclass
class AgentOutput:
    """Standardized agent output structure."""
    success: bool
    message: str
    metrics: Optional[Dict[str, Any]] = None
    error: Optional[Dict[str, str]] = None

    def to_json(self) -> str:
        """Serialize to JSON string."""
        return json.dumps(asdict(self), indent=2)


class ExampleAgent:
    """Example agent implementation."""

    def __init__(self, agent_input: AgentInput):
        self.input = agent_input
        self.project_root = Path(agent_input.project_root)
        self.metrics = {
            'start_time': agent_input.timestamp,
            'items_processed': 0,
            'errors': 0
        }

    def execute(self) -> AgentOutput:
        """Execute the agent's primary logic."""
        try:
            logger.info(f"Starting agent execution (dry_run={self.input.dry_run})")

            # Perform business logic
            result = self._process()

            self.metrics['end_time'] = self._current_timestamp()

            return AgentOutput(
                success=True,
                message=f"Processed {self.metrics['items_processed']} items successfully",
                metrics=self.metrics
            )

        except Exception as e:
            logger.error(f"Agent execution failed: {e}", exc_info=True)
            return AgentOutput(
                success=False,
                message="Agent execution failed",
                error={
                    'message': str(e),
                    'type': type(e).__name__,
                    'details': getattr(e, 'details', '')
                },
                metrics=self.metrics
            )

    def _process(self) -> bool:
        """Implement core business logic here."""
        # Example processing logic
        items = self._discover_items()

        for item in items:
            if self._validate_item(item):
                if not self.input.dry_run:
                    self._process_item(item)
                self.metrics['items_processed'] += 1
            else:
                self.metrics['errors'] += 1

        return True

    def _discover_items(self) -> list:
        """Discover items to process."""
        # Implementation specific to agent purpose
        return []

    def _validate_item(self, item: Any) -> bool:
        """Validate individual item."""
        return True

    def _process_item(self, item: Any) -> None:
        """Process individual item."""
        pass

    @staticmethod
    def _current_timestamp() -> str:
        """Get current UTC timestamp."""
        from datetime import datetime
        return datetime.utcnow().isoformat() + 'Z'


def main():
    """Main entry point."""
    if len(sys.argv) < 2:
        print(json.dumps({
            'success': False,
            'error': {'message': 'Missing input JSON argument'}
        }))
        sys.exit(1)

    try:
        # Parse input
        agent_input = AgentInput.from_json(sys.argv[1])

        # Execute agent
        agent = ExampleAgent(agent_input)
        output = agent.execute()

        # Print output as JSON
        print(output.to_json())

        # Exit with appropriate code
        sys.exit(0 if output.success else 1)

    except json.JSONDecodeError as e:
        print(json.dumps({
            'success': False,
            'error': {'message': f'Invalid JSON input: {e}'}
        }))
        sys.exit(1)
    except Exception as e:
        print(json.dumps({
            'success': False,
            'error': {'message': f'Unexpected error: {e}'}
        }))
        sys.exit(2)


if __name__ == '__main__':
    main()
```

#### JSON Communication Protocol

The Bash/Python boundary uses standardized JSON for data exchange:

**Input Structure**:
```json
{
    "config_file": "path/to/config.yaml",
    "dry_run": false,
    "project_root": "/absolute/path/to/project",
    "timestamp": "2025-11-14T10:30:00Z",
    "environment": {
        "git_branch": "main",
        "git_commit": "abc123def456"
    }
}
```

**Output Structure**:
```json
{
    "success": true,
    "message": "Processed 42 items successfully",
    "metrics": {
        "start_time": "2025-11-14T10:30:00Z",
        "end_time": "2025-11-14T10:30:15Z",
        "items_processed": 42,
        "errors": 0
    }
}
```

**Error Structure**:
```json
{
    "success": false,
    "message": "Agent execution failed",
    "error": {
        "message": "Configuration file not found",
        "type": "FileNotFoundError",
        "details": "/path/to/missing/file.yaml"
    },
    "metrics": {
        "items_processed": 5,
        "errors": 1
    }
}
```

#### Error Handling Across Boundaries

Exit codes follow Unix conventions:

- `0`: Success
- `1`: General error (business logic failure)
- `2`: Misuse (invalid arguments, missing dependencies)
- `3`: Configuration error
- `126`: Permission denied
- `127`: Command not found
- `130`: Terminated by user (Ctrl+C)

---

### Pattern 2: Agent Discovery and Orchestration

#### Dynamic Agent Discovery Mechanism

Agents are discovered through filesystem scanning and metadata parsing:

```python
#!/usr/bin/env python3
"""Agent discovery and orchestration system."""

import yaml
from pathlib import Path
from typing import List, Dict, Set
from dataclasses import dataclass


@dataclass
class AgentMetadata:
    """Agent metadata parsed from YAML frontmatter."""
    name: str
    description: str
    capabilities: List[str]
    dependencies: List[str]
    priority: int = 50
    parallel_safe: bool = True

    @classmethod
    def from_file(cls, agent_path: Path) -> 'AgentMetadata':
        """Extract metadata from agent script."""
        # Read YAML frontmatter from script comments
        with open(agent_path, 'r') as f:
            lines = f.readlines()

        # Extract YAML block between '# ---' markers
        yaml_lines = []
        in_yaml = False
        for line in lines:
            if line.strip() == '# ---':
                if in_yaml:
                    break
                in_yaml = True
                continue
            if in_yaml:
                yaml_lines.append(line.lstrip('#').strip())

        if yaml_lines:
            metadata = yaml.safe_load('\n'.join(yaml_lines))
            return cls(**metadata)
        else:
            # Default metadata if none found
            return cls(
                name=agent_path.stem,
                description=f"Agent: {agent_path.stem}",
                capabilities=[],
                dependencies=[]
            )


class AgentDiscovery:
    """Discovers and catalogs available agents."""

    def __init__(self, agents_dir: Path):
        self.agents_dir = agents_dir
        self.agents: Dict[str, AgentMetadata] = {}

    def discover(self) -> Dict[str, AgentMetadata]:
        """Discover all agents in the agents directory."""
        if not self.agents_dir.exists():
            return {}

        for agent_file in self.agents_dir.glob('*.py'):
            if agent_file.name.startswith('_'):
                continue  # Skip private modules

            try:
                metadata = AgentMetadata.from_file(agent_file)
                self.agents[metadata.name] = metadata
            except Exception as e:
                print(f"Warning: Failed to load agent {agent_file}: {e}")

        return self.agents

    def get_agents_by_capability(self, capability: str) -> List[AgentMetadata]:
        """Get all agents that provide a specific capability."""
        return [
            agent for agent in self.agents.values()
            if capability in agent.capabilities
        ]


class AgentOrchestrator:
    """Orchestrates agent execution based on dependencies."""

    def __init__(self, agents: Dict[str, AgentMetadata]):
        self.agents = agents

    def resolve_dependencies(self, agent_names: List[str]) -> List[List[str]]:
        """
        Resolve agent dependencies and return execution order.
        Returns list of agent groups where agents in each group can run in parallel.
        """
        # Build dependency graph
        graph = {name: set(self.agents[name].dependencies) for name in agent_names}

        # Topological sort with level detection
        execution_order = []
        remaining = set(agent_names)

        while remaining:
            # Find agents with no dependencies or all dependencies satisfied
            ready = {
                name for name in remaining
                if not graph[name] or graph[name].issubset(
                    set(agent for group in execution_order for agent in group)
                )
            }

            if not ready:
                raise ValueError(f"Circular dependency detected in agents: {remaining}")

            execution_order.append(sorted(ready, key=lambda x: self.agents[x].priority, reverse=True))
            remaining -= ready

        return execution_order

    def determine_execution_strategy(self, agent_group: List[str]) -> str:
        """Determine if agents in a group can run in parallel."""
        if all(self.agents[name].parallel_safe for name in agent_group):
            return 'parallel'
        return 'sequential'


# Example usage
def example_orchestration():
    """Example of agent discovery and orchestration."""

    # Discover agents
    discovery = AgentDiscovery(Path('/automation/agents'))
    agents = discovery.discover()

    print(f"Discovered {len(agents)} agents")

    # Request specific capabilities
    linters = discovery.get_agents_by_capability('linting')
    print(f"Found {len(linters)} linting agents")

    # Orchestrate execution
    orchestrator = AgentOrchestrator(agents)
    agent_names = ['yaml_validator', 'docs_linter', 'python_linter']

    try:
        execution_plan = orchestrator.resolve_dependencies(agent_names)

        print("\nExecution Plan:")
        for i, group in enumerate(execution_plan):
            strategy = orchestrator.determine_execution_strategy(group)
            print(f"  Stage {i+1} ({strategy}): {', '.join(group)}")

    except ValueError as e:
        print(f"Error: {e}")
```

#### Agent Capability Negotiation

Agents declare capabilities in their metadata:

```python
# ---
# name: yaml_validator
# description: Validates YAML files against schemas
# capabilities:
#   - validation
#   - yaml
#   - schema
# dependencies: []
# priority: 100
# parallel_safe: true
# ---
```

#### Complete Orchestration Example

**Bash Orchestrator** (`scripts/orchestrate_agents.sh`):

```bash
#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Orchestration engine
readonly ORCHESTRATOR="${PROJECT_ROOT}/automation/orchestrator.py"

main() {
    local capability="${1:-all}"
    local mode="${2:-parallel}"

    echo "Orchestrating agents with capability: ${capability}"

    # Generate execution plan
    local execution_plan
    execution_plan=$(python3 "${ORCHESTRATOR}" plan "${capability}" "${mode}")

    # Execute each stage
    local stage_num=0
    echo "${execution_plan}" | jq -c '.stages[]' | while read -r stage; do
        stage_num=$((stage_num + 1))
        local strategy=$(echo "${stage}" | jq -r '.strategy')
        local agents=$(echo "${stage}" | jq -r '.agents[]')

        echo "Stage ${stage_num} (${strategy}):"

        if [ "${strategy}" = "parallel" ]; then
            execute_parallel "${agents}"
        else
            execute_sequential "${agents}"
        fi
    done
}

execute_parallel() {
    local agents="$1"
    local pids=()

    for agent in ${agents}; do
        execute_agent "${agent}" &
        pids+=($!)
    done

    # Wait for all parallel agents
    local failed=0
    for pid in "${pids[@]}"; do
        if ! wait "${pid}"; then
            failed=$((failed + 1))
        fi
    done

    return "${failed}"
}

execute_sequential() {
    local agents="$1"

    for agent in ${agents}; do
        if ! execute_agent "${agent}"; then
            return 1
        fi
    done
}

execute_agent() {
    local agent="$1"
    "${PROJECT_ROOT}/scripts/agents/${agent}.sh"
}

main "$@"
```

---

### Pattern 3: Configuration Management

#### YAML Configuration Loading

Configurations use YAML with hierarchical overrides:

```python
#!/usr/bin/env python3
"""Configuration management with hierarchical loading and validation."""

import yaml
import os
from pathlib import Path
from typing import Dict, Any, Optional
from jsonschema import validate, ValidationError


class ConfigurationManager:
    """Manages hierarchical configuration loading and validation."""

    # Configuration search paths (in order of precedence)
    CONFIG_PATHS = [
        '.automation.local.yaml',      # User-specific (gitignored)
        '.automation.yaml',             # Project-level
        'automation/config/default.yaml'  # System defaults
    ]

    def __init__(self, project_root: Path, schema_path: Optional[Path] = None):
        self.project_root = project_root
        self.schema_path = schema_path
        self.config: Dict[str, Any] = {}
        self._load_configuration()

    def _load_configuration(self) -> None:
        """Load and merge configurations from all sources."""
        # Start with empty config
        merged_config = {}

        # Load in reverse order (lowest precedence first)
        for config_file in reversed(self.CONFIG_PATHS):
            config_path = self.project_root / config_file
            if config_path.exists():
                with open(config_path, 'r') as f:
                    file_config = yaml.safe_load(f) or {}
                    merged_config = self._deep_merge(merged_config, file_config)

        # Apply environment variable overrides
        env_config = self._load_from_environment()
        merged_config = self._deep_merge(merged_config, env_config)

        # Validate against schema if provided
        if self.schema_path and self.schema_path.exists():
            self._validate_config(merged_config)

        self.config = merged_config

    def _deep_merge(self, base: Dict, override: Dict) -> Dict:
        """Deep merge two dictionaries."""
        result = base.copy()

        for key, value in override.items():
            if key in result and isinstance(result[key], dict) and isinstance(value, dict):
                result[key] = self._deep_merge(result[key], value)
            else:
                result[key] = value

        return result

    def _load_from_environment(self) -> Dict[str, Any]:
        """Load configuration overrides from environment variables."""
        # Environment variables in format: AUTOMATION_SECTION_KEY=value
        prefix = 'AUTOMATION_'
        config = {}

        for key, value in os.environ.items():
            if key.startswith(prefix):
                # Convert AUTOMATION_LINTING_ENABLED=true to {linting: {enabled: true}}
                parts = key[len(prefix):].lower().split('_')
                self._set_nested(config, parts, self._parse_value(value))

        return config

    def _set_nested(self, config: Dict, keys: list, value: Any) -> None:
        """Set a value in a nested dictionary."""
        for key in keys[:-1]:
            config = config.setdefault(key, {})
        config[keys[-1]] = value

    def _parse_value(self, value: str) -> Any:
        """Parse string value to appropriate type."""
        if value.lower() == 'true':
            return True
        elif value.lower() == 'false':
            return False
        elif value.isdigit():
            return int(value)
        else:
            try:
                return float(value)
            except ValueError:
                return value

    def _validate_config(self, config: Dict) -> None:
        """Validate configuration against JSON schema."""
        with open(self.schema_path, 'r') as f:
            schema = yaml.safe_load(f)

        try:
            validate(instance=config, schema=schema)
        except ValidationError as e:
            raise ValueError(f"Configuration validation failed: {e.message}")

    def get(self, key_path: str, default: Any = None) -> Any:
        """Get configuration value using dot notation."""
        keys = key_path.split('.')
        value = self.config

        for key in keys:
            if isinstance(value, dict) and key in value:
                value = value[key]
            else:
                return default

        return value

    def reload(self) -> None:
        """Reload configuration from disk."""
        self._load_configuration()


# Example schema
EXAMPLE_SCHEMA = """
type: object
properties:
  linting:
    type: object
    properties:
      enabled:
        type: boolean
      strict_mode:
        type: boolean
      excluded_paths:
        type: array
        items:
          type: string
  validation:
    type: object
    properties:
      yaml_schema:
        type: string
      json_schema:
        type: string
  metrics:
    type: object
    properties:
      enabled:
        type: boolean
      output_format:
        type: string
        enum: [json, prometheus, influx]
required:
  - linting
  - validation
"""
```

#### Configuration Hot-Reloading

```python
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler


class ConfigurationWatcher(FileSystemEventHandler):
    """Watch configuration files for changes and reload."""

    def __init__(self, config_manager: ConfigurationManager):
        self.config_manager = config_manager
        self.last_reload = time.time()
        self.debounce_seconds = 1.0

    def on_modified(self, event):
        """Handle file modification events."""
        if event.is_directory:
            return

        # Check if modified file is a config file
        config_file = Path(event.src_path).name
        if config_file in [Path(p).name for p in ConfigurationManager.CONFIG_PATHS]:
            # Debounce rapid changes
            now = time.time()
            if now - self.last_reload > self.debounce_seconds:
                print(f"Configuration file changed: {config_file}")
                self.config_manager.reload()
                self.last_reload = now


def watch_configuration(config_manager: ConfigurationManager, project_root: Path):
    """Start watching configuration files for changes."""
    event_handler = ConfigurationWatcher(config_manager)
    observer = Observer()
    observer.schedule(event_handler, str(project_root), recursive=False)
    observer.start()
    return observer
```

---

### Pattern 4: Event-Driven Integration

#### Git Hooks as Event Triggers

Git hooks provide event-driven integration points:

```bash
#!/usr/bin/env bash
# .git/hooks/pre-commit

set -euo pipefail

readonly PROJECT_ROOT="$(git rev-parse --show-toplevel)"
readonly HOOK_SCRIPT="${PROJECT_ROOT}/scripts/hooks/pre_commit.sh"

# Execute pre-commit automation
if [ -x "${HOOK_SCRIPT}" ]; then
    exec "${HOOK_SCRIPT}"
else
    echo "Warning: Pre-commit hook script not found or not executable"
    exit 0
fi
```

**Pre-Commit Event Handler** (`scripts/hooks/pre_commit.sh`):

```bash
#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

main() {
    echo "Running pre-commit automation..."

    # Get staged files
    local staged_files
    staged_files=$(git diff --cached --name-only --diff-filter=ACM)

    if [ -z "${staged_files}" ]; then
        echo "No files staged for commit"
        exit 0
    fi

    # Create event payload
    local event_payload
    event_payload=$(create_event_payload "${staged_files}")

    # Process event
    python3 "${PROJECT_ROOT}/automation/event_processor.py" pre-commit "${event_payload}"
}

create_event_payload() {
    local files="$1"

    cat <<EOF
{
    "event_type": "pre-commit",
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "files": [
        $(echo "${files}" | sed 's/^/        "/' | sed 's/$/"/' | paste -sd,)
    ],
    "git": {
        "branch": "$(git rev-parse --abbrev-ref HEAD)",
        "author": "$(git config user.name)",
        "email": "$(git config user.email)"
    }
}
EOF
}

main "$@"
```

#### Asynchronous Event Processing

```python
#!/usr/bin/env python3
"""Event processor for git hook events."""

import json
import sys
from pathlib import Path
from typing import List, Dict
from concurrent.futures import ThreadPoolExecutor, as_completed


class EventProcessor:
    """Processes git hook events asynchronously."""

    def __init__(self, project_root: Path):
        self.project_root = project_root
        self.max_workers = 4

    def process_pre_commit(self, event_payload: Dict) -> bool:
        """Process pre-commit event."""
        files = [Path(f) for f in event_payload['files']]

        # Categorize files
        yaml_files = [f for f in files if f.suffix in ['.yaml', '.yml']]
        python_files = [f for f in files if f.suffix == '.py']
        markdown_files = [f for f in files if f.suffix == '.md']

        # Define tasks
        tasks = []

        if yaml_files:
            tasks.append(('validate_yaml', yaml_files))
        if python_files:
            tasks.append(('lint_python', python_files))
        if markdown_files:
            tasks.append(('lint_markdown', markdown_files))

        # Execute tasks in parallel
        with ThreadPoolExecutor(max_workers=self.max_workers) as executor:
            futures = {
                executor.submit(self._execute_task, task, files): task
                for task, files in tasks
            }

            results = []
            for future in as_completed(futures):
                task_name = futures[future]
                try:
                    result = future.result()
                    results.append(result)
                except Exception as e:
                    print(f"Task {task_name} failed: {e}")
                    results.append(False)

        return all(results)

    def _execute_task(self, task_name: str, files: List[Path]) -> bool:
        """Execute a specific task."""
        agent_script = self.project_root / 'scripts' / 'agents' / f'{task_name}.sh'

        if not agent_script.exists():
            print(f"Warning: Agent {task_name} not found")
            return True  # Don't fail on missing optional agents

        # Create file list for agent
        file_list = '\n'.join(str(f) for f in files)

        # Execute agent
        import subprocess
        result = subprocess.run(
            [str(agent_script)],
            input=file_list,
            text=True,
            capture_output=True
        )

        if result.returncode != 0:
            print(f"\n{task_name} failed:")
            print(result.stdout)
            print(result.stderr)
            return False

        return True


def main():
    """Main entry point."""
    if len(sys.argv) < 3:
        print("Usage: event_processor.py <event-type> <event-payload-json>")
        sys.exit(1)

    event_type = sys.argv[1]
    event_payload = json.loads(sys.argv[2])

    project_root = Path(__file__).parent.parent
    processor = EventProcessor(project_root)

    if event_type == 'pre-commit':
        success = processor.process_pre_commit(event_payload)
        sys.exit(0 if success else 1)
    else:
        print(f"Unknown event type: {event_type}")
        sys.exit(1)


if __name__ == '__main__':
    main()
```

#### Rollback Mechanisms

```python
class RollbackManager:
    """Manages rollback of changes on failure."""

    def __init__(self):
        self.actions = []

    def register_action(self, rollback_func, *args, **kwargs):
        """Register a rollback action."""
        self.actions.append((rollback_func, args, kwargs))

    def rollback(self):
        """Execute all rollback actions in reverse order."""
        for func, args, kwargs in reversed(self.actions):
            try:
                func(*args, **kwargs)
            except Exception as e:
                print(f"Rollback action failed: {e}")

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_type is not None:
            print("Error detected, rolling back changes...")
            self.rollback()
        return False
```

---

### Pattern 5: Pipeline Orchestration

#### DAG (Directed Acyclic Graph) Execution

```python
#!/usr/bin/env python3
"""Pipeline orchestration using DAG execution."""

from typing import Dict, List, Set, Callable, Any
from dataclasses import dataclass
from enum import Enum
import hashlib
import json


class TaskStatus(Enum):
    """Task execution status."""
    PENDING = 'pending'
    RUNNING = 'running'
    COMPLETED = 'completed'
    FAILED = 'failed'
    SKIPPED = 'skipped'


@dataclass
class Task:
    """Pipeline task definition."""
    name: str
    func: Callable
    dependencies: List[str]
    cache_key: str = None
    retry_count: int = 0
    timeout: int = 300


class Pipeline:
    """DAG-based pipeline orchestrator."""

    def __init__(self, cache_dir: str = '.automation/cache'):
        self.tasks: Dict[str, Task] = {}
        self.task_status: Dict[str, TaskStatus] = {}
        self.task_results: Dict[str, Any] = {}
        self.cache_dir = Path(cache_dir)
        self.cache_dir.mkdir(parents=True, exist_ok=True)

    def add_task(self, task: Task) -> None:
        """Add a task to the pipeline."""
        self.tasks[task.name] = task
        self.task_status[task.name] = TaskStatus.PENDING

    def execute(self, target_tasks: List[str] = None) -> Dict[str, Any]:
        """Execute the pipeline."""
        # Determine tasks to execute
        if target_tasks is None:
            target_tasks = list(self.tasks.keys())

        # Build execution order
        execution_order = self._topological_sort(target_tasks)

        # Execute tasks
        for level in execution_order:
            # Check for parallel execution
            if len(level) > 1:
                self._execute_parallel(level)
            else:
                for task_name in level:
                    self._execute_task(task_name)

        return self.task_results

    def _topological_sort(self, target_tasks: List[str]) -> List[List[str]]:
        """
        Topological sort with level detection for parallel execution.
        Returns list of task groups (levels) where tasks in each group can run in parallel.
        """
        # Find all required tasks (including dependencies)
        required = set()
        to_process = list(target_tasks)

        while to_process:
            task_name = to_process.pop()
            if task_name in required:
                continue
            required.add(task_name)
            task = self.tasks[task_name]
            to_process.extend(task.dependencies)

        # Build dependency graph
        graph = {name: set(self.tasks[name].dependencies) for name in required}

        # Level-wise topological sort
        levels = []
        remaining = required.copy()

        while remaining:
            # Find tasks with no remaining dependencies
            ready = {
                name for name in remaining
                if not graph[name] or graph[name].issubset(
                    set(task for level in levels for task in level)
                )
            }

            if not ready:
                raise ValueError(f"Circular dependency detected: {remaining}")

            levels.append(sorted(ready))
            remaining -= ready

        return levels

    def _execute_task(self, task_name: str) -> Any:
        """Execute a single task."""
        task = self.tasks[task_name]

        # Check cache
        if task.cache_key:
            cached_result = self._get_cached_result(task)
            if cached_result is not None:
                print(f"Task {task_name}: Using cached result")
                self.task_status[task_name] = TaskStatus.SKIPPED
                self.task_results[task_name] = cached_result
                return cached_result

        # Execute task
        print(f"Task {task_name}: Starting")
        self.task_status[task_name] = TaskStatus.RUNNING

        try:
            # Gather dependency results
            dep_results = {
                dep: self.task_results[dep]
                for dep in task.dependencies
            }

            # Execute with retry logic
            result = self._execute_with_retry(task, dep_results)

            self.task_status[task_name] = TaskStatus.COMPLETED
            self.task_results[task_name] = result

            # Cache result
            if task.cache_key:
                self._cache_result(task, result)

            print(f"Task {task_name}: Completed")
            return result

        except Exception as e:
            self.task_status[task_name] = TaskStatus.FAILED
            print(f"Task {task_name}: Failed - {e}")
            raise

    def _execute_with_retry(self, task: Task, dep_results: Dict) -> Any:
        """Execute task with retry logic."""
        last_exception = None

        for attempt in range(task.retry_count + 1):
            try:
                return task.func(dep_results)
            except Exception as e:
                last_exception = e
                if attempt < task.retry_count:
                    print(f"Task {task.name}: Retry {attempt + 1}/{task.retry_count}")
                    import time
                    time.sleep(2 ** attempt)  # Exponential backoff

        raise last_exception

    def _execute_parallel(self, task_names: List[str]) -> None:
        """Execute multiple tasks in parallel."""
        from concurrent.futures import ThreadPoolExecutor, as_completed

        with ThreadPoolExecutor(max_workers=len(task_names)) as executor:
            futures = {
                executor.submit(self._execute_task, task_name): task_name
                for task_name in task_names
            }

            for future in as_completed(futures):
                task_name = futures[future]
                try:
                    future.result()
                except Exception as e:
                    print(f"Parallel task {task_name} failed: {e}")
                    raise

    def _get_cache_key(self, task: Task) -> str:
        """Generate cache key for task."""
        if task.cache_key:
            return hashlib.sha256(task.cache_key.encode()).hexdigest()
        return None

    def _get_cached_result(self, task: Task) -> Any:
        """Retrieve cached result if available."""
        cache_key = self._get_cache_key(task)
        if not cache_key:
            return None

        cache_file = self.cache_dir / f"{cache_key}.json"
        if cache_file.exists():
            with open(cache_file, 'r') as f:
                return json.load(f)
        return None

    def _cache_result(self, task: Task, result: Any) -> None:
        """Cache task result."""
        cache_key = self._get_cache_key(task)
        if not cache_key:
            return

        cache_file = self.cache_dir / f"{cache_key}.json"
        with open(cache_file, 'w') as f:
            json.dumps(result, f, indent=2)


# Example pipeline usage
def example_pipeline():
    """Example pipeline with dependencies and caching."""

    pipeline = Pipeline()

    # Define tasks
    pipeline.add_task(Task(
        name='fetch_data',
        func=lambda deps: {'data': 'fetched'},
        dependencies=[],
        cache_key='fetch_v1'
    ))

    pipeline.add_task(Task(
        name='process_data',
        func=lambda deps: {'processed': deps['fetch_data']['data']},
        dependencies=['fetch_data']
    ))

    pipeline.add_task(Task(
        name='validate_data',
        func=lambda deps: {'valid': True},
        dependencies=['fetch_data']
    ))

    pipeline.add_task(Task(
        name='generate_report',
        func=lambda deps: {'report': 'generated'},
        dependencies=['process_data', 'validate_data'],
        retry_count=3
    ))

    # Execute pipeline
    results = pipeline.execute(['generate_report'])
    print(f"Pipeline completed: {results}")
```

---

### Pattern 6: Metrics Collection and Reporting

#### Metrics Definition and Collection Points

```python
#!/usr/bin/env python3
"""Metrics collection and reporting system."""

from dataclasses import dataclass, asdict
from typing import Dict, List, Optional
from datetime import datetime
import json
from pathlib import Path


@dataclass
class Metric:
    """Individual metric data point."""
    name: str
    value: float
    unit: str
    timestamp: str
    labels: Dict[str, str]

    @staticmethod
    def now() -> str:
        """Get current timestamp."""
        return datetime.utcnow().isoformat() + 'Z'


class MetricsCollector:
    """Collects and aggregates metrics."""

    def __init__(self, output_dir: Path):
        self.output_dir = output_dir
        self.output_dir.mkdir(parents=True, exist_ok=True)
        self.metrics: List[Metric] = []

    def record(self, name: str, value: float, unit: str = '', labels: Dict[str, str] = None) -> None:
        """Record a metric."""
        metric = Metric(
            name=name,
            value=value,
            unit=unit,
            timestamp=Metric.now(),
            labels=labels or {}
        )
        self.metrics.append(metric)

    def record_duration(self, name: str, duration_seconds: float, labels: Dict[str, str] = None) -> None:
        """Record a duration metric."""
        self.record(name, duration_seconds, 'seconds', labels)

    def record_count(self, name: str, count: int, labels: Dict[str, str] = None) -> None:
        """Record a count metric."""
        self.record(name, float(count), 'count', labels)

    def export_json(self, filename: str = 'metrics.json') -> Path:
        """Export metrics to JSON file."""
        output_file = self.output_dir / filename

        metrics_data = {
            'metrics': [asdict(m) for m in self.metrics],
            'summary': self._generate_summary(),
            'exported_at': Metric.now()
        }

        with open(output_file, 'w') as f:
            json.dump(metrics_data, f, indent=2)

        return output_file

    def export_prometheus(self, filename: str = 'metrics.prom') -> Path:
        """Export metrics in Prometheus format."""
        output_file = self.output_dir / filename

        with open(output_file, 'w') as f:
            for metric in self.metrics:
                labels_str = ','.join(f'{k}="{v}"' for k, v in metric.labels.items())
                if labels_str:
                    f.write(f'{metric.name}{{{labels_str}}} {metric.value}\n')
                else:
                    f.write(f'{metric.name} {metric.value}\n')

        return output_file

    def _generate_summary(self) -> Dict:
        """Generate summary statistics."""
        summary = {
            'total_metrics': len(self.metrics),
            'unique_metrics': len(set(m.name for m in self.metrics)),
            'by_type': {}
        }

        # Group by metric name
        for metric in self.metrics:
            if metric.name not in summary['by_type']:
                summary['by_type'][metric.name] = {
                    'count': 0,
                    'sum': 0,
                    'min': float('inf'),
                    'max': float('-inf')
                }

            stats = summary['by_type'][metric.name]
            stats['count'] += 1
            stats['sum'] += metric.value
            stats['min'] = min(stats['min'], metric.value)
            stats['max'] = max(stats['max'], metric.value)

        # Calculate averages
        for stats in summary['by_type'].values():
            stats['avg'] = stats['sum'] / stats['count']

        return summary


class MetricsContext:
    """Context manager for timing operations."""

    def __init__(self, collector: MetricsCollector, metric_name: str, labels: Dict[str, str] = None):
        self.collector = collector
        self.metric_name = metric_name
        self.labels = labels or {}
        self.start_time = None

    def __enter__(self):
        self.start_time = datetime.utcnow()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        duration = (datetime.utcnow() - self.start_time).total_seconds()

        # Add success/failure label
        labels = self.labels.copy()
        labels['success'] = 'true' if exc_type is None else 'false'

        self.collector.record_duration(self.metric_name, duration, labels)
        return False


# Example usage
def example_metrics_collection():
    """Example of metrics collection."""

    collector = MetricsCollector(Path('.automation/metrics'))

    # Time an operation
    with MetricsContext(collector, 'yaml_validation_duration', {'file_type': 'config'}):
        # Perform validation
        import time
        time.sleep(0.5)

    # Record counts
    collector.record_count('files_validated', 42, {'type': 'yaml'})
    collector.record_count('validation_errors', 3, {'type': 'yaml'})

    # Export metrics
    json_file = collector.export_json()
    print(f"Metrics exported to {json_file}")

    prom_file = collector.export_prometheus()
    print(f"Prometheus metrics exported to {prom_file}")
```

---

### Pattern 7: Error Handling and Recovery

#### Exception Hierarchy

```python
#!/usr/bin/env python3
"""Exception hierarchy for automation framework."""


class AutomationError(Exception):
    """Base exception for all automation errors."""

    def __init__(self, message: str, details: str = None, exit_code: int = 1):
        super().__init__(message)
        self.message = message
        self.details = details
        self.exit_code = exit_code

    def to_dict(self) -> dict:
        """Convert exception to dictionary for JSON serialization."""
        return {
            'type': self.__class__.__name__,
            'message': self.message,
            'details': self.details,
            'exit_code': self.exit_code
        }


class ConfigurationError(AutomationError):
    """Configuration-related errors."""

    def __init__(self, message: str, details: str = None):
        super().__init__(message, details, exit_code=3)


class ValidationError(AutomationError):
    """Validation errors."""

    def __init__(self, message: str, details: str = None):
        super().__init__(message, details, exit_code=1)


class DependencyError(AutomationError):
    """Missing or incompatible dependency errors."""

    def __init__(self, message: str, details: str = None):
        super().__init__(message, details, exit_code=2)


class ExecutionError(AutomationError):
    """Runtime execution errors."""

    def __init__(self, message: str, details: str = None):
        super().__init__(message, details, exit_code=1)


class RetryableError(AutomationError):
    """Errors that can be retried."""

    def __init__(self, message: str, details: str = None):
        super().__init__(message, details, exit_code=1)
```

#### Error Propagation Across Bash/Python

```bash
#!/usr/bin/env bash
# Error handling in Bash wrapper

handle_python_error() {
    local error_json="$1"
    local error_type
    local error_message
    local error_details
    local exit_code

    # Parse error JSON
    error_type=$(echo "${error_json}" | jq -r '.error.type // "Unknown"')
    error_message=$(echo "${error_json}" | jq -r '.error.message // "Unknown error"')
    error_details=$(echo "${error_json}" | jq -r '.error.details // ""')
    exit_code=$(echo "${error_json}" | jq -r '.error.exit_code // 1')

    # Log error
    log_error "Python agent failed: ${error_type}"
    log_error "Message: ${error_message}"

    if [ -n "${error_details}" ]; then
        log_error "Details: ${error_details}"
    fi

    # Return appropriate exit code
    return "${exit_code}"
}
```

#### Retry Mechanisms with Exponential Backoff

```python
import time
import functools
from typing import Callable, Type, Tuple


def retry_with_backoff(
    max_attempts: int = 3,
    initial_delay: float = 1.0,
    max_delay: float = 60.0,
    backoff_factor: float = 2.0,
    retryable_exceptions: Tuple[Type[Exception], ...] = (RetryableError,)
):
    """
    Decorator for retrying functions with exponential backoff.

    Args:
        max_attempts: Maximum number of attempts
        initial_delay: Initial delay in seconds
        max_delay: Maximum delay in seconds
        backoff_factor: Multiplier for delay after each attempt
        retryable_exceptions: Tuple of exceptions to retry on
    """
    def decorator(func: Callable) -> Callable:
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            delay = initial_delay
            last_exception = None

            for attempt in range(max_attempts):
                try:
                    return func(*args, **kwargs)
                except retryable_exceptions as e:
                    last_exception = e

                    if attempt < max_attempts - 1:
                        print(f"Attempt {attempt + 1}/{max_attempts} failed: {e}")
                        print(f"Retrying in {delay:.1f} seconds...")
                        time.sleep(delay)
                        delay = min(delay * backoff_factor, max_delay)
                    else:
                        print(f"All {max_attempts} attempts failed")
                except Exception as e:
                    # Non-retryable exception, fail immediately
                    raise

            # Raise the last exception if all retries failed
            raise last_exception

        return wrapper
    return decorator


# Example usage
@retry_with_backoff(max_attempts=3, retryable_exceptions=(RetryableError, ConnectionError))
def fetch_remote_data(url: str) -> dict:
    """Fetch data from remote URL with retry logic."""
    import requests
    response = requests.get(url)
    response.raise_for_status()
    return response.json()
```

---

### Pattern 8: Testing Integration

#### Unit Testing Python Agents (pytest)

```python
#!/usr/bin/env python3
"""Unit tests for automation agents."""

import pytest
import json
from pathlib import Path
from unittest.mock import Mock, patch, MagicMock


class TestExampleAgent:
    """Test suite for example agent."""

    @pytest.fixture
    def agent_input(self):
        """Create test agent input."""
        return {
            'config_file': '/path/to/config.yaml',
            'dry_run': True,
            'project_root': '/test/project',
            'timestamp': '2025-11-14T10:00:00Z',
            'environment': {
                'git_branch': 'main',
                'git_commit': 'abc123'
            }
        }

    @pytest.fixture
    def agent(self, agent_input):
        """Create agent instance."""
        from automation.agents.example_agent import ExampleAgent, AgentInput
        input_obj = AgentInput(**agent_input)
        return ExampleAgent(input_obj)

    def test_agent_initialization(self, agent, agent_input):
        """Test agent initializes correctly."""
        assert agent.input.project_root == agent_input['project_root']
        assert agent.input.dry_run is True
        assert agent.metrics['items_processed'] == 0

    def test_successful_execution(self, agent):
        """Test successful agent execution."""
        with patch.object(agent, '_discover_items', return_value=['item1', 'item2']):
            with patch.object(agent, '_validate_item', return_value=True):
                with patch.object(agent, '_process_item'):
                    result = agent.execute()

        assert result.success is True
        assert 'successfully' in result.message
        assert result.metrics['items_processed'] == 2

    def test_validation_failure(self, agent):
        """Test handling of validation failures."""
        with patch.object(agent, '_discover_items', return_value=['item1']):
            with patch.object(agent, '_validate_item', return_value=False):
                result = agent.execute()

        assert result.success is True  # Agent completes but metrics show errors
        assert result.metrics['errors'] == 1
        assert result.metrics['items_processed'] == 0

    def test_exception_handling(self, agent):
        """Test exception handling."""
        with patch.object(agent, '_discover_items', side_effect=Exception('Test error')):
            result = agent.execute()

        assert result.success is False
        assert result.error is not None
        assert 'Test error' in result.error['message']

    def test_dry_run_mode(self, agent):
        """Test dry run mode doesn't process items."""
        process_mock = Mock()

        with patch.object(agent, '_discover_items', return_value=['item1']):
            with patch.object(agent, '_validate_item', return_value=True):
                with patch.object(agent, '_process_item', process_mock):
                    agent.execute()

        # In dry run mode, _process_item should not be called
        assert agent.input.dry_run is True
        process_mock.assert_not_called()


class TestConfigurationManager:
    """Test configuration management."""

    @pytest.fixture
    def temp_project(self, tmp_path):
        """Create temporary project structure."""
        (tmp_path / 'automation' / 'config').mkdir(parents=True)
        return tmp_path

    def test_configuration_loading(self, temp_project):
        """Test configuration file loading."""
        from automation.config import ConfigurationManager

        # Create default config
        default_config = temp_project / 'automation' / 'config' / 'default.yaml'
        default_config.write_text('linting:\n  enabled: true\n')

        # Create project config
        project_config = temp_project / '.automation.yaml'
        project_config.write_text('linting:\n  strict_mode: true\n')

        # Load configuration
        config_mgr = ConfigurationManager(temp_project)

        assert config_mgr.get('linting.enabled') is True
        assert config_mgr.get('linting.strict_mode') is True

    def test_environment_override(self, temp_project, monkeypatch):
        """Test environment variable overrides."""
        from automation.config import ConfigurationManager

        # Set environment variable
        monkeypatch.setenv('AUTOMATION_LINTING_ENABLED', 'false')

        # Create default config
        default_config = temp_project / 'automation' / 'config' / 'default.yaml'
        default_config.write_text('linting:\n  enabled: true\n')

        # Load configuration
        config_mgr = ConfigurationManager(temp_project)

        # Environment should override file
        assert config_mgr.get('linting.enabled') is False
```

#### Integration Testing Bash Scripts (bats)

```bash
#!/usr/bin/env bats
# tests/integration/test_agent_wrapper.bats

setup() {
    # Setup test environment
    export TEST_PROJECT_ROOT="${BATS_TEST_DIRNAME}/fixtures/test_project"
    export AGENT_SCRIPT="${BATS_TEST_DIRNAME}/../../scripts/agents/example_agent.sh"

    # Create test fixtures
    mkdir -p "${TEST_PROJECT_ROOT}"
}

teardown() {
    # Cleanup
    rm -rf "${TEST_PROJECT_ROOT}"
}

@test "agent script exists and is executable" {
    [ -x "${AGENT_SCRIPT}" ]
}

@test "agent script requires config file argument" {
    run "${AGENT_SCRIPT}"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "config" ]]
}

@test "agent script executes successfully with valid config" {
    # Create test config
    cat > "${TEST_PROJECT_ROOT}/test.yaml" <<EOF
linting:
  enabled: true
EOF

    run "${AGENT_SCRIPT}" "${TEST_PROJECT_ROOT}/test.yaml"
    [ "$status" -eq 0 ]
}

@test "agent script handles Python errors gracefully" {
    # Invalid config should cause Python error
    run "${AGENT_SCRIPT}" "/nonexistent/config.yaml"
    [ "$status" -ne 0 ]
    [[ "$output" =~ "error" ]]
}

@test "agent script produces JSON output" {
    cat > "${TEST_PROJECT_ROOT}/test.yaml" <<EOF
linting:
  enabled: true
EOF

    run "${AGENT_SCRIPT}" "${TEST_PROJECT_ROOT}/test.yaml"

    # Output should be valid JSON
    echo "$output" | jq . > /dev/null
}
```

---

## Integration with Development Lifecycle

### Git Hooks Integration

#### Installation and Management

```bash
#!/usr/bin/env bash
# scripts/setup_hooks.sh

set -euo pipefail

readonly PROJECT_ROOT="$(git rev-parse --show-toplevel)"
readonly HOOKS_DIR="${PROJECT_ROOT}/.git/hooks"
readonly HOOK_TEMPLATES="${PROJECT_ROOT}/scripts/hooks/templates"

install_hooks() {
    echo "Installing git hooks..."

    for hook_template in "${HOOK_TEMPLATES}"/*; do
        if [ -f "${hook_template}" ]; then
            local hook_name=$(basename "${hook_template}")
            local hook_dest="${HOOKS_DIR}/${hook_name}"

            # Create symlink to template
            ln -sf "../../scripts/hooks/templates/${hook_name}" "${hook_dest}"
            chmod +x "${hook_dest}"

            echo "  Installed: ${hook_name}"
        fi
    done

    echo "Git hooks installation complete"
}

uninstall_hooks() {
    echo "Uninstalling git hooks..."

    for hook in pre-commit pre-push post-commit; do
        local hook_file="${HOOKS_DIR}/${hook}"
        if [ -L "${hook_file}" ]; then
            rm "${hook_file}"
            echo "  Removed: ${hook}"
        fi
    done

    echo "Git hooks uninstallation complete"
}

case "${1:-install}" in
    install)
        install_hooks
        ;;
    uninstall)
        uninstall_hooks
        ;;
    *)
        echo "Usage: $0 {install|uninstall}"
        exit 1
        ;;
esac
```

#### Hook Chaining

```bash
#!/usr/bin/env bash
# .git/hooks/pre-commit (template)

set -euo pipefail

readonly PROJECT_ROOT="$(git rev-parse --show-toplevel)"
readonly HOOK_CHAIN="${PROJECT_ROOT}/.git/hooks/pre-commit.d"

# Execute hook chain
if [ -d "${HOOK_CHAIN}" ]; then
    for hook in "${HOOK_CHAIN}"/*; do
        if [ -x "${hook}" ]; then
            echo "Running: $(basename "${hook}")"
            if ! "${hook}"; then
                echo "Hook failed: $(basename "${hook}")"
                exit 1
            fi
        fi
    done
fi

# Execute main pre-commit script
exec "${PROJECT_ROOT}/scripts/hooks/pre_commit.sh"
```

### CI/CD Integration

#### GitHub Actions Integration

```yaml
# .github/workflows/automation.yml
name: Automation Checks

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  automation:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.9'

      - name: Install dependencies
        run: |
          pip install -r requirements.txt

      - name: Run automation agents
        run: |
          ./scripts/orchestrate_agents.sh all

      - name: Upload metrics
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: automation-metrics
          path: .automation/metrics/

      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: test-results
          path: .automation/reports/
```

### DevContainer Lifecycle Integration

```json
{
    "name": "IACT Development",
    "image": "mcr.microsoft.com/devcontainers/python:3.9",
    "postCreateCommand": "bash scripts/devcontainer/post_create.sh",
    "postStartCommand": "bash scripts/devcontainer/post_start.sh",
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-python.python",
                "redhat.vscode-yaml"
            ]
        }
    }
}
```

```bash
#!/usr/bin/env bash
# scripts/devcontainer/post_create.sh

set -euo pipefail

echo "Setting up development environment..."

# Install Python dependencies
pip install -r requirements.txt

# Install git hooks
./scripts/setup_hooks.sh install

# Initialize configuration
if [ ! -f .automation.local.yaml ]; then
    cp automation/config/default.yaml .automation.local.yaml
fi

echo "Development environment ready"
```

---

## Advanced Integration Scenarios

### Multi-Repository Orchestration

```python
#!/usr/bin/env python3
"""Multi-repository orchestration."""

from pathlib import Path
from typing import List, Dict
import subprocess


class MultiRepoOrchestrator:
    """Orchestrate automation across multiple repositories."""

    def __init__(self, repos: List[Path]):
        self.repos = repos

    def execute_across_repos(self, agent_name: str) -> Dict[str, bool]:
        """Execute an agent across all repositories."""
        results = {}

        for repo in self.repos:
            agent_script = repo / 'scripts' / 'agents' / f'{agent_name}.sh'

            if agent_script.exists():
                result = subprocess.run(
                    [str(agent_script)],
                    cwd=repo,
                    capture_output=True
                )
                results[str(repo)] = result.returncode == 0
            else:
                print(f"Warning: Agent {agent_name} not found in {repo}")
                results[str(repo)] = False

        return results
```

### Custom Agent Development

```python
#!/usr/bin/env python3
"""
Custom agent template.

# ---
# name: custom_agent
# description: Custom automation agent
# capabilities:
#   - custom
#   - example
# dependencies: []
# priority: 50
# parallel_safe: true
# ---
"""

from automation.agents.base import BaseAgent, AgentInput, AgentOutput


class CustomAgent(BaseAgent):
    """Custom agent implementation."""

    def execute(self) -> AgentOutput:
        """Execute custom logic."""
        try:
            # Implement custom logic here
            result = self.custom_logic()

            return AgentOutput(
                success=True,
                message="Custom agent completed successfully",
                metrics=self.metrics
            )
        except Exception as e:
            return self.handle_error(e)

    def custom_logic(self):
        """Implement custom business logic."""
        pass
```

---

## Security Considerations

### Input Validation

```python
def validate_file_path(file_path: str, project_root: Path) -> Path:
    """Validate file path to prevent directory traversal."""
    path = Path(file_path).resolve()

    # Ensure path is within project root
    try:
        path.relative_to(project_root)
    except ValueError:
        raise ValueError(f"File path outside project root: {file_path}")

    return path


def sanitize_input(user_input: str) -> str:
    """Sanitize user input to prevent injection."""
    # Remove potentially dangerous characters
    dangerous_chars = ['$', '`', '\\', ';', '|', '&']
    sanitized = user_input

    for char in dangerous_chars:
        sanitized = sanitized.replace(char, '')

    return sanitized
```

### Secret Management

```python
import os
from pathlib import Path


class SecretManager:
    """Manage secrets securely."""

    @staticmethod
    def get_secret(secret_name: str) -> str:
        """Get secret from environment or secure store."""
        # Try environment first
        secret = os.getenv(secret_name)

        if secret:
            return secret

        # Try secure file (outside git)
        secret_file = Path.home() / '.automation' / 'secrets' / secret_name
        if secret_file.exists():
            return secret_file.read_text().strip()

        raise ValueError(f"Secret not found: {secret_name}")
```

---

## Troubleshooting Integration Issues

### Common Integration Problems

1. **Agent Not Found**
   - Check file permissions (must be executable)
   - Verify file naming conventions
   - Check discovery path configuration

2. **Configuration Not Loading**
   - Validate YAML syntax
   - Check file permissions
   - Verify hierarchical override order

3. **Hook Not Triggering**
   - Verify hook installation
   - Check hook file permissions
   - Review git config

### Diagnostic Commands

```bash
# Check agent discovery
python3 automation/orchestrator.py list

# Validate configuration
python3 -c "from automation.config import ConfigurationManager; ConfigurationManager('.').get('linting')"

# Test hook execution
.git/hooks/pre-commit --dry-run

# View metrics
jq . .automation/metrics/metrics.json
```

---

## Migration Guides

### Migrating from Manual Processes

1. **Identify Manual Steps**: Document current manual validation/testing steps
2. **Create Agent Scaffolding**: Use agent templates to automate each step
3. **Test in Isolation**: Run each agent independently before integration
4. **Integrate Gradually**: Add to git hooks one at a time
5. **Monitor and Adjust**: Collect metrics and optimize

### Phased Rollout Strategy

**Phase 1: Observation** (Week 1-2)
- Install agents without enforcement
- Collect metrics
- Identify issues

**Phase 2: Soft Enforcement** (Week 3-4)
- Enable warnings
- Allow bypass with flag
- Continue monitoring

**Phase 3: Full Enforcement** (Week 5+)
- Remove bypass options
- Block on failures
- Full integration

---

## Best Practices and Anti-Patterns

### Recommended Patterns

1. **Fail Fast**: Validate early, fail fast with clear messages
2. **Idempotency**: Agents should be safe to run multiple times
3. **Dry Run Support**: Always support dry-run mode
4. **Clear Metrics**: Emit actionable metrics
5. **Graceful Degradation**: Don't block critical workflows

### Patterns to Avoid

1. **Silent Failures**: Always report errors explicitly
2. **Hidden Dependencies**: Declare all dependencies
3. **Hardcoded Paths**: Use configuration
4. **Blocking Operations**: Make expensive operations async
5. **Ignoring Exit Codes**: Always check and propagate errors

---

## Reference Implementation

### Complete Workflow Example

```bash
#!/usr/bin/env bash
# Example: Complete pre-commit workflow

set -euo pipefail

readonly PROJECT_ROOT="$(git rev-parse --show-toplevel)"

# 1. Configuration Loading
config_file="${PROJECT_ROOT}/.automation.yaml"

# 2. Agent Discovery
agents=$(python3 "${PROJECT_ROOT}/automation/orchestrator.py" discover --capability=pre-commit)

# 3. Execution Plan
execution_plan=$(python3 "${PROJECT_ROOT}/automation/orchestrator.py" plan --agents="${agents}")

# 4. Execute with Metrics
python3 "${PROJECT_ROOT}/automation/orchestrator.py" execute \
    --plan="${execution_plan}" \
    --config="${config_file}" \
    --metrics-output="${PROJECT_ROOT}/.automation/metrics/pre-commit.json"

# 5. Report Results
python3 "${PROJECT_ROOT}/automation/reporter.py" \
    --metrics="${PROJECT_ROOT}/.automation/metrics/pre-commit.json" \
    --format=console
```

---

## Appendices

### Appendix A: JSON Schema Definitions

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Agent Input Schema",
  "type": "object",
  "properties": {
    "config_file": {"type": "string"},
    "dry_run": {"type": "boolean"},
    "project_root": {"type": "string"},
    "timestamp": {"type": "string", "format": "date-time"},
    "environment": {
      "type": "object",
      "properties": {
        "git_branch": {"type": "string"},
        "git_commit": {"type": "string"}
      }
    }
  },
  "required": ["project_root", "timestamp"]
}
```

### Appendix B: Exit Code Reference

| Code | Meaning | Usage |
|------|---------|-------|
| 0 | Success | Operation completed successfully |
| 1 | General Error | Business logic failure |
| 2 | Misuse | Invalid arguments or usage |
| 3 | Configuration Error | Configuration file issues |
| 126 | Permission Denied | File permission problems |
| 127 | Command Not Found | Missing dependency |
| 130 | Terminated by User | Ctrl+C or SIGINT |

### Appendix C: Configuration Reference

```yaml
# Complete configuration example
automation:
  # Linting configuration
  linting:
    enabled: true
    strict_mode: false
    excluded_paths:
      - node_modules/
      - .git/
      - build/

  # Validation configuration
  validation:
    yaml_schema: schemas/automation.schema.yaml
    json_schema: schemas/config.schema.json

  # Metrics configuration
  metrics:
    enabled: true
    output_format: json
    retention_days: 30

  # Execution configuration
  execution:
    parallel: true
    max_workers: 4
    timeout: 300
```

### Appendix D: API Reference

#### BaseAgent API

```python
class BaseAgent:
    """Base class for all agents."""

    def __init__(self, agent_input: AgentInput):
        """Initialize agent with input."""
        pass

    def execute(self) -> AgentOutput:
        """Execute agent logic. Must be implemented by subclasses."""
        raise NotImplementedError

    def validate_prerequisites(self) -> bool:
        """Validate agent prerequisites."""
        return True

    def cleanup(self) -> None:
        """Cleanup resources after execution."""
        pass
```

---

## Conclusion

This integration guide provides comprehensive patterns for building robust automation workflows. Key takeaways:

1. Use hybrid Bash/Python architecture for clarity and testability
2. Leverage event-driven integration through git hooks
3. Implement comprehensive error handling and recovery
4. Collect metrics for continuous improvement
5. Test at all levels: unit, integration, and end-to-end
6. Follow security best practices throughout

For questions or contributions, refer to the project documentation or contact the DevOps team.

---

**Document Version**: 1.0
**Last Updated**: 2025-11-14
**Maintained By**: DevOps Team
**Related Documentation**:
- [Automation README](README.md)
- [Governance and Compliance](GOVERNANCE_COMPLIANCE.md)
- [ADR_010: Automation Framework](../../adr/ADR_010_automation_framework.md)
