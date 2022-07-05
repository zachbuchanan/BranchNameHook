#!/bin/sh

# This way you can customize which branches should be skipped when
# prepending commit message.
RED="\033[1;31m"
GREEN="\033[1;32m"
ORANGE="\033[0;33m"
NOCOLOR="\033[0m"

if [ -z "$BRANCHES_TO_SKIP" ]; then
  BRANCHES_TO_SKIP=(master production develop staging main)
fi

AUTHORINFO=$(git var GIT_AUTHOR_IDENT) || exit 1
NAME=$(printf '%s\n\n' "${AUTHORINFO}" | sed -n 's/^\(.*\) <.*$/\1/p')
# Regex to check the valid branch name
VALID_BRANCH_REGEX="(^(feature|hotfix|bugfix|release|develop|improvement))|^([A-Z]+\-[0-9]+)$"

# Get branch name and description
BRANCH_NAME=$(git branch | grep '*' | sed 's/* //')

# Branch name should be excluded from the prepend
BRANCH_EXCLUDED=$(printf "%s\n" "${BRANCHES_TO_SKIP[@]}" | grep -c "^$BRANCH_NAME$")

# A developer has already prepended the commit in the format BRANCH_NAME
BRANCH_IN_COMMIT=$(grep -c "$BRANCH_NAME" $1)

# check the branch name is valid or not
if [[ "$BRANCH_NAME" =~ $VALID_BRANCH_REGEX ]]; then
  # if face any error in mac then run chmod u+x .git/hooks/prepare-commit-msg and restart your terminal
  if [ -n "$BRANCH_NAME" ] && ! [[ $BRANCH_EXCLUDED -eq 1 ]] && ! [[ $BRANCH_IN_COMMIT -ge 1 ]]; then 
    sed -i.bak -e "1s/^/[$BRANCH_NAME] /" $1
  fi
else
  echo -e "\n${RED}Please correct the branch name${NOCOLOR}"
  printf "\nBranch Name not as per the defined rules like:  "
  echo -e "${GREEN}dev, hotfix, bugfix, release, dev, improvement, hotfix-102\n"
  echo -e "${ORANGE}You cannot push in these branches directly: ${BRANCHES_TO_SKIP[@]}\n"
  echo -e "${ORANGE}Current BRANCH_NAME: ${BRANCH_NAME}"
  echo -e "\n${RED}Oh, please stop. I cannot allow you to commit with your current branch: ${BRANCH_NAME}${NOCOLOR}"
  exit 1;
fi