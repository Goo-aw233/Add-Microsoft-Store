@echo off
setlocal enabledelayedexpansion
for /f "tokens=2 delims=:" %%a in ('chcp') do set "orig_codepage=%%a
chcp 65001 >nul

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
    chcp %orig_codepage% >nul
    endlocal
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:: --------------------------------------

:: Prompts the user to enter a language
:: 提示用户输入语言

:MENU_LANGUAGE
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo.
echo Read: https://goo-aw233.github.io/en/tutorial/Windows/msstore
echo 参考教程: https://goo-aw233.github.io/zh-CN/tutorial/Windows/msstore
echo.
echo Please Select Your Language
echo 请选择你的语言
echo.
echo. en-us - English
echo. zh-cn - 简体中文
echo.
echo. q - Exit / 退出脚本
echo.
echo Please Enter The Command To Continue
echo 请输入对应的命令继续
echo.

set /p choice=">>> "

if /I "%choice%"=="en-us" (
    chcp %orig_codepage% >nul
    goto MENU_INSTALL_EN_US
)
if /I "%choice%"=="zh-cn" (
    chcp 65001 >nul
    goto MENU_INSTALL_ZH_CN
)
if /I "%choice%"=="q" (
    chcp %orig_codepage% >nul
    endlocal
    exit
)

:: Invalid input, return to language menu
:: 输入无效，返回语言菜单

goto MENU_LANGUAGE

:: --------------------------------------

:MENU_INSTALL_EN_US
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo Read: https://goo-aw233.github.io/en/tutorial/Windows/msstore
echo.
echo Please Select The Feature(s) To Be Installed:
echo.
echo. 0 - Download Microsoft Store From Internet
echo.
echo. 1 - Install Microsoft Store For Current User Only
echo. 2 - Install AppInstaller For Current User Only
echo. 3 - Install Microsoft Store And AppInstaller For Current User
echo.
echo. 4 - Install Microsoft Store For All User Only
echo. 5 - Install AppInstaller For All User Only
echo. 6 - Install Microsoft Store And AppInstaller For All User
echo.
echo. 7 - Install Custom Application Package(s) To Current User (package needs to be placed in the customBundle folder)
echo. 8 - Install Custom Application Package(s) To All User (package needs to be placed in the customBundle folder)
echo.
echo. L - Choose Language
echo. q - Exit
echo.

set /p choice=Please Enter The Command To Install: 

:: Execute commands based on user input

if "%choice%"=="0" goto ONLINE_INSTALL_EN_US
if "%choice%"=="1" goto MICROSOFT_STORE_CU_EN_US
if "%choice%"=="2" goto APPINSTALLER_CU_EN_US
if "%choice%"=="3" goto ALL_CU_EN_US
if "%choice%"=="4" goto MICROSOFT_STORE_AU_EN_US
if "%choice%"=="5" goto APPINSTALLER_AU_EN_US
if "%choice%"=="6" goto ALL_AU_EN_US
if "%choice%"=="7" goto CUSTOMBUNDLE_CU_EN_US
if "%choice%"=="7" goto CUSTOMBUNDLE_AU_EN_US
if /I "%choice%"=="L" goto MENU_LANGUAGE
if /I "%choice%"=="q" (
    chcp %orig_codepage% >nul
    endlocal
    exit
)

:: Invalid input, return to language menu

goto MENU_INSTALL_EN_US

:ONLINE_INSTALL_EN_US
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo Read: https://goo-aw233.github.io/en/tutorial/Windows/msstore

:: Download Microsoft Store from Internet

echo.
echo Downloading Microsoft Store from Internet...
set WSReset=C:\Windows\System32\WSReset.exe
if exist "%WSReset%" (
    start "" "%WSReset%" -i
) else (
    copy /Y "Microsoft_Store\WSReset.exe" "%WSReset%"
    start "" "%WSReset%" -i
)

:: Finished

echo.
echo Installation completed
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:MICROSOFT_STORE_CU_EN_US
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo Read: https://goo-aw233.github.io/en/tutorial/Windows/msstore

:: Install all .Appx* and .Msix* files in the Microsoft_Store folder

echo.
echo Installing Microsoft Store...
for %%f in (Microsoft_Store\*.Appx Microsoft_Store\*.AppxBundle) do (
    echo Installing %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)
for %%f in (Microsoft_Store\*.Msix Microsoft_Store\*.MsixBundle) do (
    echo Installing %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)

:: Finished

echo.
echo Installation completed
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:APPINSTALLER_CU_EN_US
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo Read: https://goo-aw233.github.io/en/tutorial/Windows/msstore

:: Install all .Appx* and .Msix* files in the AppInstaller folder

echo.
echo Installing AppInstaller...
for %%f in (Microsoft_Store\Microsoft.UI.Xaml.2.7_*.Appx Microsoft_Store\Microsoft.UI.Xaml.2.8_*.Appx Microsoft_Store\Microsoft.VCLibs.140.00.UWPDesktop_*.Appx) do (
    echo Installing %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)
for %%f in (AppInstaller\*.Appx AppInstaller\*.AppxBundle) do (
    echo Installing %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)
for %%f in (AppInstaller\*.Msix AppInstaller\*.MsixBundle) do (
    echo Installing %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)

:: Finished

echo.
echo Installation completed
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:ALL_CU_EN_US
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo Read: https://goo-aw233.github.io/en/tutorial/Windows/msstore

:: Install all .Appx* and .Msix* files in the Microsoft_Store and AppInstaller folder

echo.
echo Installing Microsoft Store...
for %%f in (Microsoft_Store\*.Appx Microsoft_Store\*.AppxBundle) do (
    echo Installing %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)
for %%f in (Microsoft_Store\*.Msix Microsoft_Store\*.MsixBundle) do (
    echo Installing %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)
echo Installing AppInstaller...
for %%f in (AppInstaller\*.Appx AppInstaller\*.AppxBundle) do (
    echo Installing %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)
for %%f in (AppInstaller\*.Msix AppInstaller\*.MsixBundle) do (
    echo Installing %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)

:: Finished

echo.
echo Installation completed
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:MICROSOFT_STORE_AU_EN_US
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo Read: https://goo-aw233.github.io/en/tutorial/Windows/msstore

:: Install all .Appx* and .Msix* files in the Microsoft_Store folder

echo.
echo Installing Microsoft Store...
for %%f in (Microsoft_Store\*.Appx Microsoft_Store\*.AppxBundle) do (
    echo Installing %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)
for %%f in (Microsoft_Store\*.Msix Microsoft_Store\*.MsixBundle) do (
    echo Installing %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)

:: Finished

echo.
echo Installation completed
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:APPINSTALLER_AU_EN_US
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo Read: https://goo-aw233.github.io/en/tutorial/Windows/msstore

:: Install all .Appx* and .Msix* files in the AppInstaller folder

echo.
echo Installing AppInstaller...
for %%f in (Microsoft_Store\Microsoft.UI.Xaml.2.7_*.Appx Microsoft_Store\Microsoft.UI.Xaml.2.8_*.Appx Microsoft_Store\Microsoft.VCLibs.140.00.UWPDesktop_*.Appx) do (
    echo Installing %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)
for %%f in (AppInstaller\*.Appx AppInstaller\*.AppxBundle) do (
    echo Installing %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)
for %%f in (AppInstaller\*.Msix AppInstaller\*.MsixBundle) do (
    echo Installing %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)

:: Finished

echo.
echo Installation completed
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:ALL_AU_EN_US
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo Read: https://goo-aw233.github.io/en/tutorial/Windows/msstore

:: Install all .Appx* and .Msix* files in the Microsoft_Store and AppInstaller folder

echo.
echo Installing Microsoft Store...
for %%f in (Microsoft_Store\*.Appx Microsoft_Store\*.AppxBundle) do (
    echo Installing %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)
for %%f in (Microsoft_Store\*.Msix Microsoft_Store\*.MsixBundle) do (
    echo Installing %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)
echo Installing AppInstaller...
for %%f in (AppInstaller\*.Appx AppInstaller\*.AppxBundle) do (
    echo Installing %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)
for %%f in (AppInstaller\*.Msix AppInstaller\*.MsixBundle) do (
    echo Installing %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)

:: Finished

echo.
echo Installation completed
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:CUSTOMBUNDLE_CU_EN_US
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo Read: https://goo-aw233.github.io/en/tutorial/Windows/msstore

:: Install all .Appx* and .Msix* files in the customBundle folder

echo.
echo Installing custom application package(s)...
for %%f in (customBundle\.gitkeep) do (
    del "%%f"
)
for %%f in (customBundle\*.Appx customBundle\*.AppxBundle) do (
    echo Installing %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)
for %%f in (customBundle\*.Msix customBundle\*.MsixBundle) do (
    echo Installing %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)

:: Finished

echo.
echo Installation completed
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:CUSTOMBUNDLE_AU_EN_US
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo Read: https://goo-aw233.github.io/en/tutorial/Windows/msstore

:: Install all .Appx* and .Msix* files in the customBundle folder

echo.
echo Installing custom application package(s)...
for %%f in (customBundle\.gitkeep) do (
    del "%%f"
)
for %%f in (customBundle\*.Appx customBundle\*.AppxBundle) do (
    echo Installing %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)
for %%f in (customBundle\*.Msix customBundle\*.MsixBundle) do (
    echo Installing %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)

:: Finished

echo.
echo Installation completed
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:: Invalid entry, return to language menu

else (
    goto MENU_LANGUAGE
)

:: --------------------------------------

:MENU_INSTALL_ZH_CN
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo 参考教程: https://goo-aw233.github.io/zh-CN/tutorial/Windows/msstore
echo.
echo 请选择要安装的功能:
echo.
echo. 0 - 在线安装 Microsoft Store
echo.
echo. 1 - 仅为当前用户安装 Microsoft Store
echo. 2 - 仅为当前用户安装 AppInstaller
echo. 3 - 为当前用户同时安装 Microsoft 与 AppInstaller
echo.
echo. 4 - 仅为所有用户安装 Microsoft Store
echo. 5 - 仅为所有用户安装 AppInstaller
echo. 6 - 为所有用户同时安装 Microsoft 与 AppInstaller
echo.
echo. 7 - 为当前安装自定义应用程序包（需放在 customBundle 下）
echo. 8 - 为所有安装自定义应用程序包（需放在 customBundle 下）
echo.
echo. L - 选择语言
echo. q - 退出脚本
echo.

set /p choice=请输入对应的命令继续: 

:: 根据用户输入执行相应的命令

if "%choice%"=="0" goto ONLINE_INSTALL_ZH_CN
if "%choice%"=="1" goto MICROSOFT_STORE_CU_ZH_CN
if "%choice%"=="2" goto APPINSTALLER_CU_ZH_CN
if "%choice%"=="3" goto ALL_CU_ZH_CN
if "%choice%"=="4" goto MICROSOFT_STORE_AU_ZH_CN
if "%choice%"=="5" goto APPINSTALLER_AU_ZH_CN
if "%choice%"=="6" goto ALL_AU_ZH_CN
if "%choice%"=="7" goto CUSTOMBUNDLE_CU_ZH_CN
if "%choice%"=="8" goto CUSTOMBUNDLE_AU_ZH_CN
if /I "%choice%"=="L" goto MENU_LANGUAGE
if /I "%choice%"=="q" (
    chcp %orig_codepage% >nul
    endlocal
    exit
)

:: 输入无效，返回语言菜单

goto MENU_INSTALL_ZH_CN

:ONLINE_INSTALL_ZH_CN
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo 参考教程: https://goo-aw233.github.io/zh-CN/tutorial/Windows/msstore

:: 从互联网下载 Microsoft Store

echo.
echo 正在在线安装 Microsoft Store...
set WSReset=C:\Windows\System32\WSReset.exe
if exist "%WSReset%" (
    start "" "%WSReset%" -i
) else (
    copy /Y "Microsoft_Store\WSReset.exe" "%WSReset%"
    start "" "%WSReset%" -i
)

:: 完成

echo.
echo 安装完成
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:MICROSOFT_STORE_CU_ZH_CN
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo 参考教程: https://goo-aw233.github.io/zh-CN/tutorial/Windows/msstore

:: 安装 Microsoft_Store 文件夹下所有的 .Appx* 和 .Msix* 文件

echo.
echo 正在安装 Microsoft Store...
for %%f in (Microsoft_Store\*.Appx Microsoft_Store\*.AppxBundle) do (
    echo 正在安装 %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)
for %%f in (Microsoft_Store\*.Msix Microsoft_Store\*.MsixBundle) do (
    echo 正在安装 %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)

:: 完成

echo.
echo 安装完成
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:APPINSTALLER_CU_ZH_CN
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo 参考教程: https://goo-aw233.github.io/zh-CN/tutorial/Windows/msstore

:: 安装 AppInstaller 文件夹下所有的 .Appx* 和 .Msix* 文件

echo.
echo 正在安装 AppInstaller...
for %%f in (Microsoft_Store\Microsoft.UI.Xaml.2.7_*.Appx Microsoft_Store\Microsoft.UI.Xaml.2.8_*.Appx Microsoft_Store\Microsoft.VCLibs.140.00.UWPDesktop_*.Appx) do (
    echo 正在安装 %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)
for %%f in (AppInstaller\*.Appx AppInstaller\*.AppxBundle) do (
    echo 正在安装 %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)
for %%f in (AppInstaller\*.Msix AppInstaller\*.MsixBundle) do (
    echo 正在安装 %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)

:: 完成

echo.
echo 安装完成
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:ALL_CU_ZH_CN
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo 参考教程: https://goo-aw233.github.io/zh-CN/tutorial/Windows/msstore

:: 安装 Microsoft_Store 和 AppInstaller 文件夹下所有的 .Appx* 和 .Msix* 文件

echo.
echo 正在安装 Microsoft Store...
for %%f in (Microsoft_Store\*.Appx Microsoft_Store\*.AppxBundle) do (
    echo 正在安装 %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)
for %%f in (Microsoft_Store\*.Msix Microsoft_Store\*.MsixBundle) do (
    echo 正在安装 %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)
echo 正在安装 AppInstaller...
for %%f in (AppInstaller\*.Appx AppInstaller\*.AppxBundle) do (
    echo 正在安装 %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)
for %%f in (AppInstaller\*.Msix AppInstaller\*.MsixBundle) do (
    echo 正在安装 %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)

:: 完成

echo.
echo 安装完成
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:MICROSOFT_STORE_AU_ZH_CN
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo 参考教程: https://goo-aw233.github.io/zh-CN/tutorial/Windows/msstore

:: 安装 Microsoft_Store 文件夹下所有的 .Appx* 和 .Msix* 文件

echo.
echo 正在安装 Microsoft Store...
for %%f in (Microsoft_Store\*.Appx Microsoft_Store\*.AppxBundle) do (
    echo 正在安装 %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)
for %%f in (Microsoft_Store\*.Msix Microsoft_Store\*.MsixBundle) do (
    echo 正在安装 %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)

:: 完成

echo.
echo 安装完成
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:APPINSTALLER_AU_ZH_CN
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo 参考教程: https://goo-aw233.github.io/zh-CN/tutorial/Windows/msstore

:: 安装 AppInstaller 文件夹下所有的 .Appx* 和 .Msix* 文件

echo.
echo 正在安装 AppInstaller...
for %%f in (Microsoft_Store\Microsoft.UI.Xaml.2.7_*.Appx Microsoft_Store\Microsoft.UI.Xaml.2.8_*.Appx Microsoft_Store\Microsoft.VCLibs.140.00.UWPDesktop_*.Appx) do (
    echo 正在安装 %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)
for %%f in (AppInstaller\*.Appx AppInstaller\*.AppxBundle) do (
    echo 正在安装 %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)
for %%f in (AppInstaller\*.Msix AppInstaller\*.MsixBundle) do (
    echo 正在安装 %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)

:: 完成

echo.
echo 安装完成
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:ALL_AU_ZH_CN
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo 参考教程: https://goo-aw233.github.io/zh-CN/tutorial/Windows/msstore

:: 安装 Microsoft_Store 和 AppInstaller 文件夹下所有的 .Appx* 和 .Msix* 文件

echo.
echo 正在安装 Microsoft Store...
for %%f in (Microsoft_Store\*.Appx Microsoft_Store\*.AppxBundle) do (
    echo 正在安装 %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)
for %%f in (Microsoft_Store\*.Msix Microsoft_Store\*.MsixBundle) do (
    echo 正在安装 %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)
echo 正在安装 AppInstaller...
for %%f in (AppInstaller\*.Appx AppInstaller\*.AppxBundle) do (
    echo 正在安装 %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)
for %%f in (AppInstaller\*.Msix AppInstaller\*.MsixBundle) do (
    echo 正在安装 %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)

:: 完成

echo.
echo 安装完成
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:CUSTOMBUNDLE_CU_ZH_CN
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo 参考教程: https://goo-aw233.github.io/zh-CN/tutorial/Windows/msstore

:: 安装 customBundle 文件夹下所有的 .Appx* 和 .Msix* 文件

echo.
echo 正在安装自定义应用程序包...
for %%f in (customBundle\.gitkeep) do (
    del "%%f"
)
for %%f in (customBundle\*.Appx customBundle\*.AppxBundle) do (
    echo 正在安装 %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)
for %%f in (customBundle\*.Msix customBundle\*.MsixBundle) do (
    echo 正在安装 %%f...
    powershell.exe -Command "Add-AppxPackage -Path %%f"
)

:: 完成

echo.
echo 安装完成
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:CUSTOMBUNDLE_AU_ZH_CN
cls
title Installer Neutral For Package All By GuCATs
echo Installer Neutral For Package All
echo 参考教程: https://goo-aw233.github.io/zh-CN/tutorial/Windows/msstore

:: 安装 customBundle 文件夹下所有的 .Appx* 和 .Msix* 文件

echo.
echo 正在安装自定义应用程序包...
for %%f in (customBundle\.gitkeep) do (
    del "%%f"
)
for %%f in (customBundle\*.Appx customBundle\*.AppxBundle) do (
    echo 正在安装 %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)
for %%f in (customBundle\*.Msix customBundle\*.MsixBundle) do (
    echo 正在安装 %%f...
    Dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:"%%f" /SkipLicense
)

:: 完成

echo.
echo 安装完成
echo.
pause
chcp %orig_codepage% >nul
endlocal
exit

:: 输入无效，返回语言菜单

else (
    goto MENU_LANGUAGE
)