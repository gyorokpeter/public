setlocal
for /f "delims=/ tokens=4" %%x in (.git\refs\remotes\origin\HEAD) do set primaryBranch=%%x
echo %primaryBranch%
git checkout %primaryBranch% || exit /b 1
cd .git\refs\heads
for %%b in (*) do (
    if not %%b==%primaryBranch% (
        git branch -d %%b
    )
)
git push --all --prune
