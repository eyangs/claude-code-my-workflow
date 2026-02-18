#!/bin/bash
# ==============================================================================
# Sync Quarto Rendered Files to docs/ Directory
# ==============================================================================
# Usage: ./scripts/sync_to_docs.sh <lecture_name>
# Example: ./scripts/sync_to_docs.sh Demo_Simple
# ==============================================================================

set -e  # Exit on error

# Check if lecture name is provided
if [ -z "$1" ]; then
  echo "Error: Lecture name not provided"
  echo "Usage: $0 <lecture_name>"
  echo "Example: $0 Demo_Simple"
  exit 1
fi

LECTURE_NAME="$1"
QUARTO_DIR="Quarto"
DOCS_DIR="docs"

# Check if Quarto HTML exists
if [ ! -f "${QUARTO_DIR}/${LECTURE_NAME}.html" ]; then
  echo "Error: ${QUARTO_DIR}/${LECTURE_NAME}.html not found"
  exit 1
fi

# Create docs directory if it doesn't exist
mkdir -p "${DOCS_DIR}"

# Copy HTML to docs directory
echo "Copying ${QUARTO_DIR}/${LECTURE_NAME}.html to ${DOCS_DIR}/..."
cp "${QUARTO_DIR}/${LECTURE_NAME}.html" "${DOCS_DIR}/"

# Create/update index.html to list all lectures
echo "Updating index.html..."

cat > "${DOCS_DIR}/index.html" << EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Lecture Index</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 800px; margin: 2em auto; padding: 0 1em; }
    h1 { color: #333; border-bottom: 2px solid #666; padding-bottom: 0.5em; }
    ul { list-style-type: none; padding: 0; }
    li { margin: 0.5em 0; }
    a { color: #0066cc; text-decoration: none; }
    a:hover { text-decoration: underline; }
    .date { color: #666; font-size: 0.9em; }
  </style>
</head>
<body>
  <h1>Lecture Index</h1>
  <ul>
EOF

# List all HTML files (except index.html) and add to index
find "${DOCS_DIR}" -name "*.html" ! -name "index.html" -type f | sort | while read -r html_file; do
  filename=$(basename "$html_file" .html)
  echo "    <li><a href=\"${filename}.html\">${filename}</a></li>" >> "${DOCS_DIR}/index.html"
done

cat >> "${DOCS_DIR}/index.html" << EOF
  </ul>
  <p class="date">Last updated: $(date)</p>
</body>
</html>
EOF

echo "✓ Sync complete!"
echo "  - ${DOCS_DIR}/${LECTURE_NAME}.html"
echo "  - ${DOCS_DIR}/index.html (updated)"
