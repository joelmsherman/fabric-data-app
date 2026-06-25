#!/bin/bash
# setup.sh - Initialize a new Fabric Data App project from this template
# Renames the semantic-model scaffold tokens. The data app itself is
# scaffolded later with the Rayfin CLI (see README "Workflow").
# Usage: ./setup.sh <ProjectName> [DatabaseName] [ServerName]

set -e

PROJECT_NAME="${1:?Usage: ./setup.sh <ProjectName> [DatabaseName] [ServerName]}"
DB_NAME="${2:-$PROJECT_NAME}"
SERVER_NAME="${3:-localhost}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "Initializing Fabric Data App project: $PROJECT_NAME"
echo "  Database: $DB_NAME"
echo "  Server:   $SERVER_NAME"
echo ""

# Rename the semantic-model directory
mv "src/{{ProjectName}}.SemanticModel" "src/${PROJECT_NAME}.SemanticModel"

# Replace {{ProjectName}} tokens in all relevant files
find src/ -type f \( -name "*.pbism" -o -name "*.tmdl" \) \
  -exec sed -i "s/{{ProjectName}}/${PROJECT_NAME}/g" {} +

# Replace tokens in CLAUDE.md
sed -i "s/{{ProjectName}}/${PROJECT_NAME}/g" CLAUDE.md

# Update connection parameters in expressions.tmdl
EXPR_FILE="src/${PROJECT_NAME}.SemanticModel/definition/expressions.tmdl"
sed -i "s/\"localhost\"/\"${SERVER_NAME}\"/g" "$EXPR_FILE"
sed -i "s/\"${PROJECT_NAME}\"/\"${DB_NAME}\"/g" "$EXPR_FILE"

echo "Project '$PROJECT_NAME' initialized successfully."
echo ""
echo "  Semantic Model: src/${PROJECT_NAME}.SemanticModel/"
echo "  BPA Rules:      src/.bpa/"
echo "  Documentation:  docs/"
echo ""
echo "Next steps (see README.md for the full workflow):"
echo "  1. Launch Claude Code ('claude') and accept the marketplace trust prompt"
echo "  2. Plan the product with the /prd-creator skill"
echo "  3. Build the semantic model under src/${PROJECT_NAME}.SemanticModel/ and validate:"
echo "       pwsh src/.bpa/bpa.ps1 -src \"src\""
echo "  4. Deploy the model to a Fabric workspace (fab auth login, then the fabric-cli plugin)"
echo "  5. Scaffold the data app with the Rayfin CLI:"
echo "       npm create @microsoft/rayfin@latest -- \"${PROJECT_NAME}\" --template dataapp --workspace \"<WorkspaceName>\""
