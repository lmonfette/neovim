@echo off
@REM This script installs everything needed on your Windows computer

@REM Allow to run stuff from internet
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

@REM Install Alacritty
choco install alacritty -y
C:\ProgramData\chocolatey\lib\alacritty.install\tools\Alacritty-v0.15.1-installer.msi

@REM Install Lua
choco install lua -y

@REM Install luarocks
choco install luarocks -y

@REM Install python 3.11
choco install python311 -y

@REM Install NodeJS
choco install nodejs.Install -y

@REM Install ripgrep
choco install ripgrep -y

@REM Install fd
choco install fd -y

@REM Install tree-sitter
choco install tree-sitter

@REM Ask to install JetBrains fonts
echo "Please install JetBrains Nerd Fonts at https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
echo "Press any key when this is done."
pause