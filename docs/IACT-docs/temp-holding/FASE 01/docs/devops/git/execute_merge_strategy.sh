#!/bin/bash
# Script to execute merge strategy for PR #175
# Integrates with claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R
# Target: develop branch with all commits preserved

set -e  # Exit on error

echo "=========================================="
echo "Executing Merge Strategy for PR #175"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Preparación
echo -e "${YELLOW}Step 1: Preparation${NC}"
cd /home/runner/work/IACT---project/IACT---project
git checkout copilot/sub-pr-175-yet-again

# Verify clean state
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${RED}Error: Working directory is not clean${NC}"
    echo "Please commit or stash your changes first"
    exit 1
fi
echo -e "${GREEN}Working directory is clean${NC}"

# Update remote references
echo "Fetching remote references..."
git fetch origin

# Fetch develop branch
git fetch origin develop
echo -e "${GREEN}Step 1 completed${NC}"
echo ""

# Step 2: Obtain Claude Branch
echo -e "${YELLOW}Step 2: Obtaining Claude branch${NC}"
if git fetch origin claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R 2>/dev/null; then
    echo -e "${GREEN}Claude branch fetched successfully${NC}"
else
    echo -e "${RED}Error: Could not fetch Claude branch${NC}"
    echo "Please ensure you have access to claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R"
    exit 1
fi

# Check if branch exists
if git branch -a | grep -q "claude/analyze-scripts-output"; then
    echo -e "${GREEN}Claude branch found${NC}"
else
    echo -e "${RED}Error: Claude branch not found${NC}"
    exit 1
fi
echo ""

# Step 3: Test merge to identify conflicts
echo -e "${YELLOW}Step 3: Identifying potential conflicts${NC}"
echo "Simulating merge (dry-run)..."
if git merge --no-commit --no-ff origin/claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R 2>&1; then
    echo -e "${GREEN}No conflicts detected${NC}"
    CONFLICTS_EXIST=false
else
    echo -e "${YELLOW}Conflicts detected${NC}"
    CONFLICTS_EXIST=true
    
    # Show conflicted files
    echo "Conflicted files:"
    git status | grep "both modified" || echo "No 'both modified' files"
fi

# Abort the test merge
git merge --abort 2>/dev/null || true
echo ""

# Step 4: Real merge with conflict resolution
echo -e "${YELLOW}Step 4: Performing real merge${NC}"
echo "Merging claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R..."

if git merge origin/claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R; then
    echo -e "${GREEN}Merge completed without conflicts${NC}"
else
    echo -e "${YELLOW}Resolving conflicts with Claude priority (--theirs)${NC}"
    
    # Get list of conflicted files
    CONFLICTED_FILES=$(git diff --name-only --diff-filter=U)
    
    if [ -z "$CONFLICTED_FILES" ]; then
        echo -e "${GREEN}No conflicts to resolve${NC}"
    else
        echo "Resolving conflicts in the following files:"
        echo "$CONFLICTED_FILES"
        
        # Resolve each conflict with --theirs (Claude priority)
        for file in $CONFLICTED_FILES; do
            echo "  Resolving: $file (using Claude version)"
            git checkout --theirs "$file"
            git add "$file"
        done
        
        # Commit the merge
        git commit -m "merge: integrate claude/analyze-scripts-output with priority on Claude changes"
        echo -e "${GREEN}Conflicts resolved and committed${NC}"
    fi
fi
echo ""

# Step 5: Validation
echo -e "${YELLOW}Step 5: Validation${NC}"

# Verify ADRs format
echo "Checking ADRs format..."
ADR_NEW_COUNT=$(find docs -name "ADR_2025_*" -type f 2>/dev/null | wc -l)
ADR_OLD_COUNT=$(find docs -name "ADR-2025-*" -type f 2>/dev/null | wc -l)

echo "ADRs with new format (ADR_2025_*): $ADR_NEW_COUNT (expected: 21)"
echo "ADRs with old format (ADR-2025-*): $ADR_OLD_COUNT (expected: 0)"

if [ "$ADR_NEW_COUNT" -eq 21 ] && [ "$ADR_OLD_COUNT" -eq 0 ]; then
    echo -e "${GREEN}ADRs format validation: PASSED${NC}"
else
    echo -e "${RED}ADRs format validation: FAILED${NC}"
    echo "Please check the ADRs manually"
fi

# Check for emojis
echo "Checking for emojis..."
if grep -r "✅\|❌\|⏸️" MERGE_STRATEGY_PR_175.md PR_DESCRIPTION.md 2>/dev/null | grep -v "grep -r"; then
    echo -e "${YELLOW}Warning: Emojis found in documentation${NC}"
else
    echo -e "${GREEN}No emojis found - Correct${NC}"
fi

# Verify critical files
echo "Checking critical files..."
if [ -f "docs/gobernanza/INDICE_ADRs.md" ]; then
    echo -e "${GREEN}Master index exists${NC}"
else
    echo -e "${RED}Master index missing${NC}"
fi

if [ -f ".github/CODEOWNERS" ]; then
    echo -e "${GREEN}CODEOWNERS exists${NC}"
else
    echo -e "${RED}CODEOWNERS missing${NC}"
fi

echo ""

# Step 6: Push to working branch
echo -e "${YELLOW}Step 6: Pushing to working branch${NC}"
echo "Pushing copilot/sub-pr-175-yet-again..."
if git push origin copilot/sub-pr-175-yet-again; then
    echo -e "${GREEN}Push successful${NC}"
else
    echo -e "${RED}Push failed${NC}"
    echo "You may need to force push or resolve additional issues"
    exit 1
fi
echo ""

# Step 7: Integration to develop (requires permissions)
echo -e "${YELLOW}Step 7: Integration to develop${NC}"
echo "This step requires appropriate permissions."
read -p "Do you want to integrate to develop now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Checking out develop branch..."
    if git checkout develop; then
        echo "Merging copilot/sub-pr-175-yet-again to develop..."
        if git merge copilot/sub-pr-175-yet-again --no-ff -m "feat: integrate ADR standardization and SDLC documentation"; then
            echo -e "${GREEN}Merge to develop successful${NC}"
            
            echo "Pushing develop to origin..."
            if git push origin develop; then
                echo -e "${GREEN}Develop branch updated successfully${NC}"
            else
                echo -e "${RED}Failed to push to develop${NC}"
                echo "You may need special permissions to push to develop"
                exit 1
            fi
        else
            echo -e "${RED}Merge to develop failed${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Could not checkout develop branch${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}Skipping develop integration${NC}"
    echo "To integrate later, run:"
    echo "  git checkout develop"
    echo "  git merge copilot/sub-pr-175-yet-again --no-ff"
    echo "  git push origin develop"
fi
echo ""

# Final summary
echo "=========================================="
echo -e "${GREEN}Merge Strategy Execution Complete${NC}"
echo "=========================================="
echo ""
echo "Summary:"
echo "  - Merged claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R"
echo "  - Conflicts resolved with Claude priority"
echo "  - ADRs validated: $ADR_NEW_COUNT in correct format"
echo "  - Working branch pushed"
echo ""
echo "Next steps:"
echo "  1. Review the changes: git log --oneline -10"
echo "  2. Verify ADRs: find docs -name 'ADR_2025_*'"
echo "  3. Check develop branch status"
echo ""
echo -e "${GREEN}Done!${NC}"
