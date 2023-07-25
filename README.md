# A hook that automatically inserts the branch name into the commit message

***Example***

Branch: **EM-26530**

git commit -m **"Added some new tests"**

After hook runs, the commit message will be saved as **"[EM-26530] Added some new tests"**

## Rules
Branch name must be in regex pattern **([A-Z]+\-[0-9]+)**

You can instruct script to skip the insert by adding the branch to skip into the BRANCHES_TO_SKIP variable and the VALID_BRANCH_REGEX variable 