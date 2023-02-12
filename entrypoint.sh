#!/bin/sh -l

function draw_frame() {
  local msg="$1"
  local line=$(echo "$msg" | sed 's/./-/g')
  echo ""
  echo ""
  echo "+-$line-+"
  echo "| $msg |"
  echo "+-$line-+"
  echo ""
}

get_env() { [ -z "$(eval echo "\$$1")" ] && echo "$1 is undefined" || eval echo "\$$1"; }

function system_info() {
  echo "🖥️  Runner hostname   : $(uname -n)"
  echo "💻  Runner name       : $(get_env RUNNER_NAME)"
  echo "🌐  Runner OS         : $(get_env RUNNER_OS)"
  echo "🔧  Runner Arch       : $(get_env RUNNER_ARCH)"
  echo "🕹️  Github run number : $(get_env RUN_NUMBER)"
  echo "🚧  uname -a          : $(uname -a)"
}

function git_info() {
  echo "🌎  Detected environment: $(get_env APP_ENV)"
  version_tag=$(git describe --exact-match --tags $(git log -n1 --pretty='%h') 2>/dev/null) || version_tag='No version tag detected'
  echo "📁  Git branch name  : $(git rev-parse --abbrev-ref HEAD)"
  echo "🏷️  Version tag      : $(get_env version_tag)"
  echo "👤  Commit author    : $(git log -1 --format='%an <%ae>')"
  echo "📅  Commit date      : $(git log -1 --format=%cd --date=format:'%Y-%m-%d %H:%M:%S %z')"
  echo "🔢  Git commit hash  : $(git rev-parse --short HEAD)"
  echo "🔄  Git commit range : $(get_env GITHUB_SHA)...$(get_env GITHUB_EVENT_BEFORE)"
}

function package_info() {
  local package_json_path=${INPUT_PACKAGE-JSON-PATH:-/workspace/front/package.json}
  if [ ! -f "$package_json_path" ]; then
    echo "❌  Error: package.json not found at $package_json_path"
    return
  fi
  local name=$(grep -Po '"name" *: *"\K[^"]+' $package_json_path)
  local version=$(grep -Po '"version" *: *"\K[^"]+' $package_json_path)
  echo "📜  name               : ${name}"
  echo "📦  version            : ${version}"
  # Compare package.json version with tag version
  echo "🔍  Comparing package.json version with tag version:"
  if [ "${BRANCH}" != "refs/tags/${version}" ]; then
    echo "  ⚠️  Warning: Package.json version (${version}) does not match tag version (${BRANCH})"
  else
    echo "  ✅  Package.json version matches tag version"
  fi
}

draw_frame "🕵️ Build information detective results"
draw_frame "📈 System Information"
system_info

draw_frame "🧪 Git information:"
git_info

if [ "${INPUT_PACKAGE-JSON:-false}" == "true" ]; then
  draw_frame "📦  Package Information"
  package_info
else
  : # echo "ℹ️ Package information is not requested."
fi

echo ""
echo ""

