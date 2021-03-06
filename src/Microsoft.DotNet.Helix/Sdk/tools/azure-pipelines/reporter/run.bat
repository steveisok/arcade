
set ENV_PATH=%USERPROFILE%\.vsts-env
set TMP_ENV_PATH=%USERPROFILE%\.vsts-env-tmp

REM Removing pythonpath forces a clean installation of the Azure DevOps client, but subsequent commands may use HELIX libraries
set _OLD_PYTHONPATH=%PYTHONPATH%
set PYTHONPATH=

echo  %date%-%time%

if NOT EXIST %ENV_PATH%\Scripts\python.exe (
  rmdir /Q /S %TMP_ENV_PATH%
  rmdir /Q /S %ENV_PATH%
  %HELIX_PYTHONPATH% -m virtualenv --no-site-packages %TMP_ENV_PATH%
  rename %TMP_ENV_PATH% .vsts-env
)

%ENV_PATH%\Scripts\python.exe -c "import azure.devops" || %ENV_PATH%\Scripts\python.exe -m pip install azure-devops==5.0.0b9

%ENV_PATH%\Scripts\python.exe -c "import future" || %ENV_PATH%\Scripts\python.exe -m pip install future==0.17.1

echo  %date%-%time%
%ENV_PATH%\Scripts\python.exe -B %~dp0run.py %*
echo  %date%-%time%

set PYTHONPATH=%_OLD_PYTHONPATH%