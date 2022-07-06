#!/bin/sh

# This way you can customize which branches should be skipped when
# prepending commit message.
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
ORANGE="\033[0;33m"
NOCOLOR="\033[0m"

# Regex to check the valid branch name
VALID_BRANCH_REGEX="^(develop)|^([A-Za-z]+\-[0-9]+)|^()$"

# Get branch name and description
BRANCH_NAME=$(git branch | grep '*' | sed 's/* //')
echo -e "branch name: ${BRANCH_NAME}\n"
# Check to see if rebasing
REBASE=$(git branch | grep 'rebasing' | sed 's/* //')
echo -e "rebase: ${REBASE}\n"

# A developer has already added the branch name to the commit message
BRANCH_IN_COMMIT=$(grep -c "$BRANCH_NAME" $1)

# check the branch name is valid or not
if [[ ! "$BRANCH_NAME" =~ $VALID_BRANCH_REGEX ]] && [[ -z "$REBASE" ]]; then
  echo -e "\n${RED}Please correct the branch name ${BRANCH_NAME}"
  exit 1;
fi

if [[ "$BRANCH_NAME" == "develop" ]]; then
  exec < /dev/tty
  read -p "Are you sure you want to commit to develop? [y/n] " ans
  if [[ ! $ans =~ ^[Yy]$ ]]; then
    echo -e "\n${ORANGE}Aborting commit"
    exit 1
  fi
fi

if [ -n "$BRANCH_NAME" ] && ! [[ $BRANCH_IN_COMMIT -ge 1 ]] && [[ -z "$REBASE" ]]; then 
  echo -e "${BLUE}Automatically adding branch name to commit message${NOCOLOR}\n"
  sed -i.bak -e "1s/^/[$BRANCH_NAME] /" $1
else
  echo -e "\n${BLUE}Either you added the branch name yourself, or this is a merge/rebase${NOCOLOR}\n"
  exit
fi