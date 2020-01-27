@echo off
set "PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC"
set "QT_AUTO_SCREEN_SCALE_FACTOR=1"
start "nvim-qt" /min cmd.exe /s /c "nvim-qt.exe -qwindowgeometry 800x600 %*"
