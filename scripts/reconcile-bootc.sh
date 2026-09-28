#!/usr/bin/env bash
set -euo pipefail

DESIRED_FILE="/etc/bootc-gitops/desired-image.txt"

if [[ ! -f "$DESIRED_FILE" ]]; then
  echo "Desired image file not found: $DESIRED_FILE"
  exit 1
fi

IMAGE="$(grep -v '^[[:space:]]*#' "$DESIRED_FILE" | sed '/^[[:space:]]*$/d' | head -n 1)"

if [[ -z "$IMAGE" ]]; then
  echo "No desired image specified"
  exit 1
fi

CURRENT="$(bootc status --format json | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("deployments",[{}])[0].get("image",{}).get("image",""))' 2>/dev/null || true)"

echo "Desired image: $IMAGE"
echo "Current image: $CURRENT"

if [[ "$CURRENT" == "$IMAGE" ]]; then
  echo "Already at desired image."
  exit 0
fi

echo "Switching to desired image..."
bootc switch --apply "$IMAGE"
