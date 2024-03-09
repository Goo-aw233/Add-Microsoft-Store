@echo off

:: BatchGotAdmin
:: ���Ȩ��

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: Exit script if unable to request
:: ���޷��������˳��ű�

if '%errorlevel%' NEQ '0' (
    echo Requesting administrator...
    echo �������ԱȨ��...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:: --------------------------------------

:: Prompts the user to enter a language
:: ��ʾ�û���������

:MENU_LANGUAGE
cls
title Installer v1.0.0 neutral for Package All by GuCATs
echo Installer v1.0.0 neutral for Package All
echo.
echo. Read: https://goo-aw233.github.io/en/tutorial/Windows/msstore
echo. �ο��̳�: https://goo-aw233.github.io/zh-CN/tutorial/Windows/msstore
echo.
echo Please select your language
echo ��ѡ���������
echo.
echo. en-us - English
echo. zh-cn - ��������
echo.
echo. q - Exit / �˳��ű�
echo.
echo Please enter the command to continue
echo �������Ӧ���������
echo.

set /p choice=">>> "

if "%choice%"=="en-us" goto MENU_INSTALL_EN_US
if "%choice%"=="zh-cn" goto MENU_INSTALL_ZH_CN
if "%choice%"=="Q" exit
if "%choice%"=="q" exit

:: Invalid input, return to language menu
:: ������Ч���������Բ˵�

goto MENU_LANGUAGE

:: --------------------------------------

:MENU_INSTALL_EN_US
cls
title Installer v1.0.0 neutral for Package All by GuCATs
echo Installer v1.0.0 neutral for Package All
echo. Read: https://goo-aw233.github.io/en/tutorial/Windows/msstore
echo.
echo Please select the feature(s) to be installed:
echo. 1 - Install Microsoft Store only
echo. 2 - Install AppInstaller Store only
echo. 3 - Install Microsoft Store and AppInstaller
echo. 4 - Install custom application package(s) (The application package needs to be placed in the customBundle folder)
echo.
echo. L - Choose language
echo. q - Exit
echo. v - View the Configure Application Packages for All Users page on Microsoft Learn
echo.

set /p choice=Please enter the command to install: 

:: Execute commands based on user input

if "%choice%"=="1" goto MICROSOFT_STORE
if "%choice%"=="2" goto APPINSTALLER
if "%choice%"=="3" goto ALL
if "%choice%"=="4" goto CUSTOMBUNDLE
if "%choice%"=="L" goto MENU_LANGUAGE
if "%choice%"=="l" goto MENU_LANGUAGE
if "%choice%"=="Q" exit
if "%choice%"=="q" exit
if "%choice%"=="V" (
    explorer "https://learn.microsoft.com/windows-hardware/manufacture/desktop/dism-app-package--appx-or-appxbundle--servicing-command-line-options"
    exit
)
if "%choice%"=="v" (
    explorer "https://learn.microsoft.com/windows-hardware/manufacture/desktop/dism-app-package--appx-or-appxbundle--servicing-command-line-options"
    exit
)

:: Invalid input, return to language menu

goto MENU_INSTALL_EN_US

:MICROSOFT_STORE

:: Install all .Appx, .AppxBundle, .Msix and .MsixBundle files in the Microsoft_Store folder

echo Installing Microsoft Store...
for %%f in (Microsoft_Store\*.Appx Microsoft_Store\*.AppxBundle) do (
    echo Installing %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (Microsoft_Store\*.Msix Microsoft_Store\*.MsixBundle) do (
    echo Installing %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)

:: Finished

echo Installation completed
pause
exit

:APPINSTALLER

:: Install all .Appx, .AppxBundle, .Msix and .MsixBundle files in the AppInstaller folder

echo Installing AppInstaller...
for %%f in (Microsoft_Store\Microsoft.UI.Xaml.2.7_*.Appx Microsoft_Store\Microsoft.UI.Xaml.2.8_*.Appx Microsoft_Store\Microsoft.VCLibs.140.00.UWPDesktop_*.Appx) do (
    echo Installing %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (AppInstaller\*.Appx AppInstaller\*.AppxBundle) do (
    echo Installing %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (AppInstaller\*.Msix AppInstaller\*.MsixBundle) do (
    echo Installing %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)

:: Finished

echo Installation completed
pause
exit

:ALL

:: Install all .Appx, .AppxBundle, .Msix and .MsixBundle files in the Microsoft_Store and AppInstaller folder

echo Installing Microsoft Store...
for %%f in (Microsoft_Store\*.Appx Microsoft_Store\*.AppxBundle) do (
    echo Installing %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (Microsoft_Store\*.Msix Microsoft_Store\*.MsixBundle) do (
    echo Installing %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
echo Installing AppInstaller...
for %%f in (AppInstaller\*.Appx AppInstaller\*.AppxBundle) do (
    echo Installing %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (AppInstaller\*.Msix AppInstaller\*.MsixBundle) do (
    echo Installing %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)

:: Finished

echo Installation completed
pause
exit

:CUSTOMBUNDLE

:: Install all .Appx, .AppxBundle, .Msix and .MsixBundle files in the customBundle folder

echo Installing custom application package(s)...
for %%f in (customBundle\.gitkeep) do (
    del "%%f"
)
for %%f in (customBundle\*.Appx customBundle\*.AppxBundle) do (
    echo Installing %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (customBundle\*.Msix customBundle\*.MsixBundle) do (
    echo Installing %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)

:: Finished

echo Installation completed
pause
exit

:: Invalid entry, return to language menu

else (
    goto MENU_LANGUAGE
)

:: --------------------------------------

:MENU_INSTALL_ZH_CN
cls
title Installer v1.0.0 neutral for Package All by GuCATs
echo Installer v1.0.0 neutral for Package All
echo. �ο��̳�: https://goo-aw233.github.io/zh-CN/tutorial/Windows/msstore
echo.
echo ��ѡ��Ҫ��װ�Ĺ���:
echo. 1 - ����װ Microsoft Store
echo. 2 - ����װ AppInstaller
echo. 3 - ͬʱ��װ Microsoft �� AppInstaller
echo. 4 - ��װ�Զ���Ӧ�ó����������� customBundle �£�
echo.
echo. L - ѡ������
echo. q - �˳��ű�
echo. v - ���Ϊ�����û�����Ӧ�ó������ҳ��
echo.

set /p choice=�������Ӧ���������: 

:: �����û�����ִ����Ӧ������

if "%choice%"=="1" goto MICROSOFT_STORE
if "%choice%"=="2" goto APPINSTALLER
if "%choice%"=="3" goto ALL
if "%choice%"=="4" goto CUSTOMBUNDLE
if "%choice%"=="L" goto MENU_LANGUAGE
if "%choice%"=="l" goto MENU_LANGUAGE
if "%choice%"=="Q" exit
if "%choice%"=="q" exit
if "%choice%"=="V" (
    explorer "https://goo-aw233.github.io/zh-CN/tutorial/Windows/AppxManagement-DISM"
    exit
)
if "%choice%"=="v" (
    explorer "https://goo-aw233.github.io/zh-CN/tutorial/Windows/AppxManagement-DISM"
    exit
)

:: ������Ч���������Բ˵�

goto MENU_INSTALL_ZH_CN

:MICROSOFT_STORE

:: ��װ Microsoft_Store �ļ��������е� .Appx��AppxBundle��.Msix �� .MsixBundle �ļ�

echo ���ڰ�װ Microsoft Store...
for %%f in (Microsoft_Store\*.Appx Microsoft_Store\*.AppxBundle) do (
    echo ���ڰ�װ %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (Microsoft_Store\*.Msix Microsoft_Store\*.MsixBundle) do (
    echo ���ڰ�װ %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)

:: ���

echo ��װ���
pause
exit

:APPINSTALLER

:: ��װ AppInstaller �ļ��������е� .Appx��AppxBundle��.Msix �� .MsixBundle �ļ�

echo ���ڰ�װ AppInstaller...
for %%f in (Microsoft_Store\Microsoft.UI.Xaml.2.7_*.Appx Microsoft_Store\Microsoft.UI.Xaml.2.8_*.Appx Microsoft_Store\Microsoft.VCLibs.140.00.UWPDesktop_*.Appx) do (
    echo ���ڰ�װ %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (AppInstaller\*.Appx AppInstaller\*.AppxBundle) do (
    echo ���ڰ�װ %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (AppInstaller\*.Msix AppInstaller\*.MsixBundle) do (
    echo ���ڰ�װ %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)

:: ���

echo ��װ���
pause
exit

:ALL

:: ��װ Microsoft_Store �� AppInstaller �ļ��������е� .Appx��AppxBundle��.Msix �� .MsixBundle �ļ�

echo ���ڰ�װ Microsoft Store...
for %%f in (Microsoft_Store\*.Appx Microsoft_Store\*.AppxBundle) do (
    echo ���ڰ�װ %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (Microsoft_Store\*.Msix Microsoft_Store\*.MsixBundle) do (
    echo ���ڰ�װ %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
echo ���ڰ�װ AppInstaller...
for %%f in (AppInstaller\*.Appx AppInstaller\*.AppxBundle) do (
    echo ���ڰ�װ %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (AppInstaller\*.Msix AppInstaller\*.MsixBundle) do (
    echo ���ڰ�װ %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)

:: ���

echo ��װ���
pause
exit

:CUSTOMBUNDLE

:: ��װ customBundle �ļ��������е� .Appx��AppxBundle��.Msix �� .MsixBundle �ļ�

echo ���ڰ�װ�Զ���Ӧ�ó����...
for %%f in (customBundle\.gitkeep) do (
    del "%%f"
)
for %%f in (customBundle\*.Appx customBundle\*.AppxBundle) do (
    echo ���ڰ�װ %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (customBundle\*.Msix customBundle\*.MsixBundle) do (
    echo ���ڰ�װ %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)

:: ���

echo ��װ���
pause
exit

:: ������Ч���������Բ˵�

else (
    goto MENU_LANGUAGE
)

:: ���

echo ��װ���
pause