@echo off
setlocal enabledelayedexpansion

echo Running Flutter with Firebase dart-define configuration...

REM Usage: run_with_firebase.bat [device]
REM Examples:
REM   run_with_firebase.bat           (defaults to chrome)
REM   run_with_firebase.bat chrome
REM   run_with_firebase.bat windows

set DEVICE=%1
if "%DEVICE%"=="" set DEVICE=chrome

REM Validate required environment variables
set MISSING=
for %%V in (FIREBASE_API_KEY FIREBASE_APP_ID FIREBASE_MESSAGING_SENDER_ID FIREBASE_PROJECT_ID FIREBASE_DATABASE_URL FIREBASE_STORAGE_BUCKET) do (
  if "!%%V!"=="" (
    echo [ERROR] Environment variable %%V is not set.
    set MISSING=1
  )
)

if defined MISSING (
  echo.
  echo Please set the variables above, for example:
  echo   setx FIREBASE_API_KEY "YOUR_KEY"
  echo   setx FIREBASE_APP_ID "YOUR_APP_ID"
  echo   setx FIREBASE_MESSAGING_SENDER_ID "YOUR_SENDER_ID"
  echo   setx FIREBASE_PROJECT_ID "YOUR_PROJECT_ID"
  echo   setx FIREBASE_DATABASE_URL "YOUR_DB_URL"
  echo   setx FIREBASE_STORAGE_BUCKET "YOUR_BUCKET"
  echo.
  echo After setting with setx, open a new terminal and re-run this script.
  goto :eof
)

flutter run -d %DEVICE% ^
  --dart-define=FIREBASE_API_KEY=%FIREBASE_API_KEY% ^
  --dart-define=FIREBASE_APP_ID=%FIREBASE_APP_ID% ^
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=%FIREBASE_MESSAGING_SENDER_ID% ^
  --dart-define=FIREBASE_PROJECT_ID=%FIREBASE_PROJECT_ID% ^
  --dart-define=FIREBASE_DATABASE_URL=%FIREBASE_DATABASE_URL% ^
  --dart-define=FIREBASE_STORAGE_BUCKET=%FIREBASE_STORAGE_BUCKET%

endlocal