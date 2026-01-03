# Git Tools Documentation

This directory contains the Sphinx documentation for Git Tools.

## Building the Documentation

### Prerequisites

Install Sphinx and required extensions:

```bash
pip install -r requirements.txt
```

Or using pip3:

```bash
pip3 install -r requirements.txt
```

### Build HTML Documentation

```bash
make html
```

The generated HTML will be in `_build/html/`.

### View Documentation

Open the built documentation in your browser:

```bash
# On macOS
open _build/html/index.html

# On Linux
xdg-open _build/html/index.html

# Or manually navigate to:
firefox _build/html/index.html
```

### Other Build Formats

Sphinx supports multiple output formats:

```bash
make html      # HTML output
make latexpdf  # PDF output (requires LaTeX)
make epub      # EPUB e-book format
make man       # Man pages
make text      # Plain text
```

### Clean Build Files

Remove generated files:

```bash
make clean
```

## Documentation Structure

- `conf.py` - Sphinx configuration
- `index.rst` - Main documentation index
- `*.rst` - Documentation pages
- `_static/` - Static files (CSS, images)
- `_templates/` - Custom templates
- `_build/` - Generated output (git-ignored)

## Writing Documentation

### reStructuredText

Most documentation is written in reStructuredText (.rst) format. See the [reStructuredText Primer](https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html).

### Markdown Support

Thanks to myst-parser, you can also write documentation in Markdown (.md) format.

### Adding New Pages

1. Create a new `.rst` or `.md` file
2. Add it to the appropriate `toctree` directive in `index.rst` or another page
3. Rebuild the documentation with `make html`

## Sphinx Theme

This documentation uses the [Read the Docs theme](https://sphinx-rtd-theme.readthedocs.io/).

## Links

- [Sphinx Documentation](https://www.sphinx-doc.org/)
- [Read the Docs Theme](https://sphinx-rtd-theme.readthedocs.io/)
- [MyST Parser](https://myst-parser.readthedocs.io/)
