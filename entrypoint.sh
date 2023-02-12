#!/bin/sh -l

# INPUT_INSPECT_SYSTEM=false
# INPUT_INSPECT_GIT=false
# INPUT_INSPECT_PACKAGE_JSON=true
# INPUT_PACKAGE_JSON_PATH='./package.json'
# INPUT_INSPECT_ENVIRONMENT='APP_ENV,SHELL, USER, SOMETHING,       SOMETHING_ELSE'

function draw_frame() {
  local msg="$1"
  local line=$(echo "$msg" | sed 's/./-/g')
  echo ""
  echo "+-$line-+"
  echo "| $msg |"
  echo "+-$line-+"
  echo ""
}

get_env() { [ -z "$(eval echo "\$$1")" ] && echo "$1 is undefined" || eval echo "\$$1"; }

function inspect_system() {
  echo "🖥️  Runner hostname : $(uname -n)"
  echo "💻  Runner name     : $(get_env RUNNER_NAME)"
  echo "🌐  Runner OS       : $(get_env RUNNER_OS)"
  echo "🔧  Runner Arch     : $(get_env RUNNER_ARCH)"
  echo "🕹️  Github build #  : $(get_env RUN_NUMBER)"
  echo "🚧  uname -a        : $(uname -a)"
}

function inspect_git() {
  echo "🌎  Detected environment: $(get_env APP_ENV)"
  version_tag=$(git describe --exact-match --tags $(git log -n1 --pretty='%h') 2>/dev/null) || version_tag='No version tag detected'
  echo "📁  Git branch name  : $(git rev-parse --abbrev-ref HEAD)"
  echo "🏷️  Version tag      : $(get_env version_tag)"
  echo "👤  Commit author    : $(git log -1 --format='%an <%ae>')"
  echo "📅  Commit date      : $(git log -1 --format=%cd --date=format:'%Y-%m-%d %H:%M:%S %z')"
  echo "🔢  Git commit hash  : $(git rev-parse --short HEAD)"
  echo "🔄  Git commit range : $(get_env GITHUB_SHA)...$(get_env GITHUB_EVENT_BEFORE)"
}

function inspect_environment() {
  inspect_environment=$(echo "$INPUT_INSPECT_ENVIRONMENT" | tr ',' '\n')
  for variable in $inspect_environment; do
    value=$(printenv "$variable")
    if [ -z "$value" ]; then
      echo "❌ $variable is not set"
    else
      echo "✅ $variable: $value"
    fi
  done
}

function inspect_package() {
  local package_json_path=${INPUT_PACKAGE_JSON_PATH:-package.json}
  if [ ! -f "$package_json_path" ]; then
    echo "❌  Error: package.json not found at $package_json_path"
    return
  fi
  local name=$(grep '"name"' "$package_json_path" | awk '{print $2}' | sed 's/[",]//g')
  local version=$(grep '"version"' "$package_json_path" | awk '{print $2}' | sed 's/[",]//g')
  echo "📜  name               : ${name}"
  echo "📦  version            : ${version}"
  # Compare package.json version with tag version
  if [ "${version_tag}" != 'No version tag detected' ] && [ "${version_tag:0:1}" == 'v' ]; then
    echo "🔍  Comparing package.json version with tag version:"
    if [ "${version_tag}" != "v${version}" ]; then
      echo "  ⚠️  Warning: package.json version (${version}) does not match tag version (${version_tag})"
    else
      echo "  ✅  package.json version matches tag version"
    fi
  fi
}

draw_frame "🕵️ Build information detective results"

if [ "${INPUT_INSPECT_SYSTEM:-true}" != "false" ]; then
  draw_frame "📈 System information"
  inspect_system
fi

if [ "${INPUT_INSPECT_GIT:-true}" != "false" ]; then
  draw_frame "🧪 Git information:"
  inspect_git
fi

if [ -n "${INPUT_INSPECT_ENVIRONMENT}" ]; then
  draw_frame "🌎 Environment information:"
  inspect_environment
fi

if [ "${INPUT_INSPECT_PACKAGE_JSON:-false}" == "true" ] || [ -f "package.json" ]; then
  draw_frame "📦  Package information"
  inspect_package
else
  : # echo "ℹ️ Package information is not requested."
fi

echo ""
echo ""

