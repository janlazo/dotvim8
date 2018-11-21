@echo off
set QT_AUTO_SCREEN_SCALE_FACTOR=1
start "nvim-qt" /min cmd.exe /s /c "nvim-qt.exe -qwindowgeometry 800x600 %*"
