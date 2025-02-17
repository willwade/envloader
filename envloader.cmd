@echo off
:: Wrapper script for the Go app (CMD)

:: Run the Go app and capture its output
for /f "tokens=*" %%i in ('my-env-app 2^>^&1') do set output=%%i
set exitCode=%ERRORLEVEL%

:: Check if the Go app succeeded
if %exitCode% neq 0 (
    echo Error running my-env-app:
    echo %output%
    exit /b 1
)

:: Apply the environment variables
%output%
echo Environment variables applied successfully.