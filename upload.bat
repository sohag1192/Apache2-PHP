@echo off
REM ============================================
REM  GitHub Upload Script (fixed for main branch)
REM  Author    : sohag1192
REM  Date      : %date% %time%
REM ============================================

cd /d "C:\Users\sohag\Downloads\GitHub_Upload\Apache2-PHP"

IF NOT EXIST ".git" (
    echo Initializing new Git repository...
    git init
    git remote add origin https://github.com/sohag1192/Apache2-PHP.git
    git branch -M main
)

REM Stage and commit changes
git add .
set CURRDATE=%date% %time%
git commit -m "Auto commit on %CURRDATE% with Sohag1192 updates"

REM Pull latest changes safely
git pull origin main --rebase

REM Push to correct branch
git push origin main

echo.
echo ============================================
echo   Upload Completed Successfully to GitHub
echo ============================================
pause