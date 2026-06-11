#!/bin/bash
# ----------------------------------------------------------------------------
# destroy.sh — Tear down AWS 
#
# Terraform reads its state file, finds all 11 resources it created, and
# deletes them in the correct dependency order. Used to:
#
# This also deletes the instance's disk, so the Minecraft WORLD is
# lost. Fine for this project; in production you'd back up /opt/minecraft first.
#
# ----------------------------------------------------------------------------

set -e
cd "$(dirname "$0")/.."

terraform -chdir=terraform destroy -auto-approve
echo "All resources destroyed."