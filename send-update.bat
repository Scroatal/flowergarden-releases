@echo off
rem Sends the newest Flower Garden to GitHub. The kids' games pick it up next time they start.
rem (Claude puts the new files in this folder; this just uploads them.)
rem It also backs up the game's code to the private repo.
cd /d "%~dp0"
echo Sending the new Flower Garden to GitHub...
if not exist .git (
  git init -b main
  git remote add origin https://github.com/Scroatal/flowergarden-releases.git
)
git add -A
git -c user.name="Flower Garden" -c user.email="flowergarden@users.noreply.github.com" commit -q -m "Flower Garden update"
git push -u origin main
if errorlevel 1 (
  echo.
  echo Something went wrong sending the update - see the message above.
  pause
  exit /b 1
)
echo.
echo Backing up the code...
if exist "%~dp0..\flowergarden-git\.git" (
  cd /d "%~dp0..\flowergarden-git"
  git -c user.name="Flower Garden" -c user.email="flowergarden@users.noreply.github.com" pull -q --no-edit --no-rebase "..\flower-garden-godot\dev\fgp.bundle" master
  git push -q -u origin main
)
echo.
echo Done! The kids' games will update the next time they start.
pause
