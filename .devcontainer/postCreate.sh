set -euo pipefail

# Prepare python environment
pip install -r src/requirements.txt

# Prepare MongoDB Development DB
bash ./.devcontainer/installMongoDB.sh
bash ./.devcontainer/startMongoDB.sh