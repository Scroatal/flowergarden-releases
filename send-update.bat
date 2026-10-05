@echo off
rem Sends the newest Flower Garden to GitHub. The kids' games pick it up next time they start.
rem (Claude puts the new files in this folder; this just uploads them.)
rem It also backs up the game's code to the private repo.
cd /d "%~dp0"
rem Started from the backup copy in the devkit? Go to the real releases folder instead.
if not exist "%~dp0FlowerGarden.pck" cd /d "%~dp0..\..\..\..\flowergarden-releases"
if not exist "FlowerGarden.pck" (
  echo Please run send-update.bat from the flowergarden-releases folder.
  pause
  exit /b 1
)
echo Sending the new Flower Garden to GitHub...
if not exist .git (
  git -c safe.directory=* init -b main
  git -c safe.directory=* remote add origin https://github.com/Scroatal/flowergarden-releases.git
)
git -c safe.directory=* add -A
git -c safe.directory=* -c user.name="Flower Garden" -c user.email="flowergarden@users.noreply.github.com" commit -q -m "Flower Garden update"
git -c safe.directory=* push -u origin main
if errorlevel 1 (
  echo.
  echo Something went wrong sending the update - see the message above.
  pause
  exit /b 1
)
echo.
echo Backing up the code...
if exist "..\flowergarden-git\.git" (
  cd /d "..\flowergarden-git"
  git -c safe.directory=* fetch -q "..\flower-garden-godot\dev\fgp.bundle" master
  git -c safe.directory=* push -q -f origin FETCH_HEAD:refs/heads/main
)
echo.
echo Done! The kids' games will update the next time they start.
pause
