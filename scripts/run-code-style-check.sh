#!/bin/sh
#
# Check for ruby style errors

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
NC='\033[0m'

if git rev-parse --verify HEAD >/dev/null 2>&1
then
  against=HEAD
else
  # Initial commit: diff against an empty tree object
  # Change it to match your initial commit sha
  against=123acdac4c698f24f2352cf34c3b12e246b48af1
fi

# Check if rubocop is installed for the current project
bundle exec rubocop -v >/dev/null 2>&1 || \
{ echo >&2 "${red}[Rubocop][Fatal]: Add 'gem \"rubocop\", require: false, group: :development' to your Gemfile"; exit 1; }

# Get only the staged files
FILES="$(git diff --cached --name-only --diff-filter=AMC | grep "\.rb$" | tr '\n' ' ')"

if [ -n "$FILES" ]
then
  echo "${green}[Rubocop][Info]: Checking Rubocop${NC}"

  any_fail=0

  echo "${green}[Rubocop][Info]: ${FILES}${NC}"
  bundle exec rubocop ${FILES}
  if [ $? -ne 0 ]; then
    echo "${red}[Rubocop][Error]: Fix the issues and commit again${NC}"
    any_fail=1
  else
    echo "${green}[Rubocop][Info]: Congrats${NC}"
  fi

  if [ $any_fail -ne 0 ]; then
    exit 1
  fi
else
  echo "${green}[Rubocop][Info]: No files to check${NC}"
fi

exit 0