#!/usr/bin/env bash
# Deploy Sphinx documentation to GitHub Pages
set -euo pipefail

echo "Building documentation..."
cd docs
make html
cd ..

echo "Deploying to gh-pages branch..."
# Create/update gh-pages branch
git checkout --orphan gh-pages-temp
git rm -rf .
cp -r docs/_build/html/* .
touch .nojekyll
git add .
git commit -m "Deploy documentation"
git push -f origin gh-pages-temp:gh-pages
git checkout -

echo "Documentation deployed!"
echo "Enable GitHub Pages in repository settings:"
echo "  Settings > Pages > Source: Deploy from branch 'gh-pages' / (root)"
