# Advanced: Creating Custom Extensions

## Extension Anatomy

All Sphinx extensions follow this pattern:

```python
from sphinx.application import Sphinx
from sphinx.util.typing import ExtensionMetadata

def setup(app: Sphinx) -> ExtensionMetadata:
    """Required setup function."""
    
    # Register event handlers
    app.connect('config-inited', on_config_inited)
    app.connect('doctree-resolved', on_doctree_resolved)
    
    # Register directives
    app.add_directive('custom', CustomDirective)
    
    # Register roles
    app.add_role('custom', custom_role)
    
    # Return metadata
    return {
        'version': '1.0.0',
        'parallel_read_safe': True,
        'parallel_write_safe': True,
    }
```

## Event System

**24+ events available:**

- `config-inited(app, config)` - After config loaded
- `env-before-read-docs(app, env, docnames)` - Before processing
- `doctree-read(app, doctree)` - After parsing
- `doctree-resolved(app, doctree, docname)` - After cross-refs
- `build-finished(app, exception)` - After build complete

Hook into these to customize behavior non-invasively.

## Custom Directives

```python
from docutils import nodes
from sphinx.util.docutils import SphinxDirective

class CustomDirective(SphinxDirective):
    has_content = True
    required_arguments = 0
    option_spec = {'class': directives.class_option}
    
    def run(self):
        # Process directive
        container = nodes.container()
        self.state.nested_parse(self.content, 0, container)
        return [container]
```

## Custom Domains

For language-specific documentation, create a domain:

```python
from sphinx.domains import Domain, Index

class CustomDomain(Domain):
    name = 'custom'
    label = 'Custom'
    roles = {
        'func': XRefRole(),
    }
    directives = {
        'function': CustomFunctionDirective,
    }
```

## References

- Event reference: https://www.sphinx-doc.org/en/master/extdev/appapi.html
- Writing directives: https://docutils.sourceforge.io/docs/howto/rst-directives.html
