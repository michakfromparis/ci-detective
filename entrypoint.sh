#!/bin/sh -l

function draw_frame() {
  local msg="$1"
  local line=$(echo "$msg" | sed 's/./-/g')
  echo "+-$line-+"
  echo "| $msg |"
  echo "+-$line-+"
}

function system_info() {
  echo "🖥️  Runner hostname   : $(uname -n)"
  echo "💻  Runner name       : ${{ env.RUNNER_NAME }}"
  echo "    Runner OS         : ${{ env.RUNNER_OS }}"
  echo "    Runner Arch       : ${{ env.RUNNER_ARCH }}"
  echo "🕹️  Github run number : ${{ env.RUN_NUMBER }}"
  echo "    uname -a          : $(uname -a)"
}

function git_info() {
  echo "🌎  Detected environment: ${APP_ENV}"
  version_tag=$(git describe --exact-match --tags $(git log -n1 --pretty='%h'))
  if [ -n "$version_tag" ]; then
    echo "🏷️ Version tag : ${version_tag}"
  else
    echo "🏷️ Version tag : No version tag detected"
  fi
  echo "📁  Git branch name  : $(git rev-parse --abbrev-ref HEAD)"
  echo "🏷️  Version tag      : ${version_tag}"
  echo "👤  Commit author    : $(git log -1 --format='%an <%ae>')"
  echo "📅  Commit date      : $(git log -1 --format=%cd --date=format:'%Y-%m-%d %H:%M:%S %z')"
  echo "🔢  Git commit hash  : $(git rev-parse --short HEAD)"
  echo "🔄  Git commit range : ${GITHUB_SHA}...${GITHUB_EVENT_BEFORE}"
}
function package_info() {
  local name=$(cat package.json | jq -r '.name')
  local version=$(cat package.json | jq -r '.version')
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

draw_frame "🏰 🕵️ Build information detective results:"
draw_frame "   System Information"
system_info()

draw_frame "🧪 Git information:"
git_info()

draw_frame "📦  Package Information"
package_info()
