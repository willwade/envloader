@echo off
:: Wrapper script for envloader (CMD)

:: Run envloader and capture its output
for /f "tokens=*" %%i in ('envloader 2^>^&1') do set output=%%i
set exitCode=%ERRORLEVEL%

:: Check if envloader succeeded
if %exitCode% neq 0 (
    echo Error running envloader:
    echo %output%
    exit /b 1
)

:: Apply the environment variables
%output%
echo Environment variables applied successfully.