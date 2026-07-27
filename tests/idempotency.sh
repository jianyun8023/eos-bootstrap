#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${REPO_ROOT}"
export ANSIBLE_CONFIG="${REPO_ROOT}/ansible/ansible.cfg"

PLAYBOOK="ansible/playbook.yml"
LIMIT="${LIMIT:-localhost}"
LOG_DIR="$(mktemp -d)"
RUN1_LOG="${LOG_DIR}/run1.log"
RUN2_LOG="${LOG_DIR}/run2.log"
trap 'rm -r -- "${LOG_DIR}"' EXIT

echo "==> first run"
if ! ansible-playbook "${PLAYBOOK}" --limit "${LIMIT}" > "${RUN1_LOG}" 2>&1; then
  echo "ERROR: first run failed"
  tail -50 "${RUN1_LOG}"
  exit 1
fi

echo "==> second run"
if ! ansible-playbook "${PLAYBOOK}" --limit "${LIMIT}" --diff > "${RUN2_LOG}" 2>&1; then
  echo "ERROR: second run failed"
  tail -50 "${RUN2_LOG}"
  exit 1
fi

echo "==> checking for changes on second run"
if grep -A 1 "^PLAY RECAP" "${RUN2_LOG}" | grep -qE "changed=[1-9]"; then
  echo "ERROR: second run produced changes — playbook is not idempotent"
  grep -B 2 -A 10 "changed=[1-9]" "${RUN2_LOG}"
  exit 1
fi

echo "==> idempotency verified"
