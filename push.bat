@echo off
git add .
git commit -m "更新博客: %date% %time%"
git push
pause