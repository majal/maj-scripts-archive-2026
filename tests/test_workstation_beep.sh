#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmpdir="$(mktemp -d)"
trap 'rm -rf "${tmpdir}"' EXIT

cat >"${tmpdir}/hostname" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "${TEST_HOSTNAME:-sx-cmix-g2}"
EOF

cat >"${tmpdir}/beep" <<'EOF'
#!/usr/bin/env bash
: > "${BEEP_MARKER:?}"
EOF
chmod +x "${tmpdir}/hostname" "${tmpdir}/beep"

marker="${tmpdir}/beep-called"

run_workstation_beep() {
  local host="$1"
  local mode="$2"
  local display_value="${3:-}"
  rm -f "${marker}"
  PATH="${tmpdir}:${PATH}" \
  TEST_HOSTNAME="${host}" \
  MAJ_WORKSTATION_BEEP="${mode}" \
  DISPLAY="${display_value}" \
  WAYLAND_DISPLAY="" \
  BEEP_MARKER="${marker}" \
    bash -c 'source "${1}/maj-source" >/dev/null; workstation_beep' bash "${repo_root}"
}

run_workstation_beep "sx-cmix-g2" "auto" ":0"
if [[ -e "${marker}" ]]; then
  echo "server host should not beep even when a display variable exists" >&2
  exit 1
fi

run_workstation_beep "maj-workstation" "auto" ""
if [[ -e "${marker}" ]]; then
  echo "auto mode should not beep without workstation display context" >&2
  exit 1
fi

run_workstation_beep "maj-workstation" "auto" ":0"
if [[ ! -e "${marker}" ]]; then
  echo "workstation host with display context should beep" >&2
  exit 1
fi

run_workstation_beep "sx-cmix-g2" "1" ""
if [[ ! -e "${marker}" ]]; then
  echo "explicit opt-in should still allow workstation beep helper" >&2
  exit 1
fi

for script in "${repo_root}/SL/sldl" "${repo_root}/SL/sldl_nwt" "${repo_root}/SL/sldl_nwt_info"; do
  if grep -nE '^[[:space:]]*beep([[:space:]]*(#.*)?)?$' "${script}"; then
    echo "${script} still has an unconditional beep call" >&2
    exit 1
  fi
done
