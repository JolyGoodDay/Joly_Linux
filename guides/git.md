```
git commit --amend --author="FirstName LastName <FirstName.LastName@server.com>" --no-edit
```
Change global (all future) commits:
```
git config --global user.email "FirstName.LastName@server.com"
```

Rebasing to branch to main
```
git checkout main
git pull
git checkout <branch>
git fetch
git rebase main
# Fix any merge conflicts in VS code and perform the following until all merge conflicts are fixed
git add filename
git rebase --continue
# Branches will have diverged by this point, perform
git push -f
```
