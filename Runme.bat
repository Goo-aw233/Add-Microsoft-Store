@echo off

:: BatchGotAdmin
:: 检查权限

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: Exit script if unable to request
:: 若无法请求，则退出脚本

if '%errorlevel%' NEQ '0' (
    echo Requesting administrator...
    echo 请求管理员权限...
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
:: 提示用户输入语言

:MENU_LANGUAGE
cls
title Installer v1.0.0 neutral for Package All by GuCATs
echo Installer v1.0.0 neutral for Package All
echo.
echo. Read: https://goo-aw233.github.io/en/tutorial/Windows/msstore
echo. 参考教程: https://goo-aw233.github.io/zh-CN/tutorial/Windows/msstore
echo.
echo Please select your language
echo 请选择你的语言
echo.
echo. en-us - English
echo. zh-cn - 简体中文
echo.
echo. q - Exit / 退出脚本
echo.
echo Please enter the command to continue
echo 请输入对应的命令继续
echo.

set /p choice=">>> "

if "%choice%"=="en-us" goto MENU_INSTALL_EN_US
if "%choice%"=="zh-cn" goto MENU_INSTALL_ZH_CN
if "%choice%"=="Q" exit
if "%choice%"=="q" exit

:: Invalid input, return to language menu
:: 输入无效，返回语言菜单

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
echo. 参考教程: https://goo-aw233.github.io/zh-CN/tutorial/Windows/msstore
echo.
echo 请选择要安装的功能:
echo. 1 - 仅安装 Microsoft Store
echo. 2 - 仅安装 AppInstaller
echo. 3 - 同时安装 Microsoft 与 AppInstaller
echo. 4 - 安装自定义应用程序包（需放在 customBundle 下）
echo.
echo. L - 选择语言
echo. q - 退出脚本
echo. v - 浏览为所有用户配置应用程序包的页面
echo.

set /p choice=请输入对应的命令继续: 

:: 根据用户输入执行相应的命令

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

:: 输入无效，返回语言菜单

goto MENU_INSTALL_ZH_CN

:MICROSOFT_STORE

:: 安装 Microsoft_Store 文件夹下所有的 .Appx、AppxBundle、.Msix 和 .MsixBundle 文件

echo 正在安装 Microsoft Store...
for %%f in (Microsoft_Store\*.Appx Microsoft_Store\*.AppxBundle) do (
    echo 正在安装 %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (Microsoft_Store\*.Msix Microsoft_Store\*.MsixBundle) do (
    echo 正在安装 %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)

:: 完成

echo 安装完成
pause
exit

:APPINSTALLER

:: 安装 AppInstaller 文件夹下所有的 .Appx、AppxBundle、.Msix 和 .MsixBundle 文件

echo 正在安装 AppInstaller...
for %%f in (Microsoft_Store\Microsoft.UI.Xaml.2.7_*.Appx Microsoft_Store\Microsoft.UI.Xaml.2.8_*.Appx Microsoft_Store\Microsoft.VCLibs.140.00.UWPDesktop_*.Appx) do (
    echo 正在安装 %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (AppInstaller\*.Appx AppInstaller\*.AppxBundle) do (
    echo 正在安装 %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (AppInstaller\*.Msix AppInstaller\*.MsixBundle) do (
    echo 正在安装 %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)

:: 完成

echo 安装完成
pause
exit

:ALL

:: 安装 Microsoft_Store 和 AppInstaller 文件夹下所有的 .Appx、AppxBundle、.Msix 和 .MsixBundle 文件

echo 正在安装 Microsoft Store...
for %%f in (Microsoft_Store\*.Appx Microsoft_Store\*.AppxBundle) do (
    echo 正在安装 %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (Microsoft_Store\*.Msix Microsoft_Store\*.MsixBundle) do (
    echo 正在安装 %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
echo 正在安装 AppInstaller...
for %%f in (AppInstaller\*.Appx AppInstaller\*.AppxBundle) do (
    echo 正在安装 %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (AppInstaller\*.Msix AppInstaller\*.MsixBundle) do (
    echo 正在安装 %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)

:: 完成

echo 安装完成
pause
exit

:CUSTOMBUNDLE

:: 安装 customBundle 文件夹下所有的 .Appx、AppxBundle、.Msix 和 .MsixBundle 文件

echo 正在安装自定义应用程序包...
for %%f in (customBundle\.gitkeep) do (
    del "%%f"
)
for %%f in (customBundle\*.Appx customBundle\*.AppxBundle) do (
    echo 正在安装 %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)
for %%f in (customBundle\*.Msix customBundle\*.MsixBundle) do (
    echo 正在安装 %%f...
    powershell -Command "Add-AppxPackage -Path %%f"
)

:: 完成

echo 安装完成
pause
exit

:: 输入无效，返回语言菜单

else (
    goto MENU_LANGUAGE
)

:: 完成

echo 安装完成
pause