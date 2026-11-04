@echo off
rem BioImagingNews: download the latest BioImagingNews.html from the GitHub Pages site (the crawl itself runs on GitHub).
rem Windows Task Scheduler runs this every day. Needs only curl.exe, built into Windows 10/11.
setlocal
cd /d "%~dp0"
if not exist logs mkdir logs
set URL=https://linshulang12-u.github.io/BioImagingNews/BioImagingNews.html
echo ==== %date% %time% ==== >> logs\sync.log
curl.exe -fsSL --retry 3 --max-time 120 -o BioImagingNews.download "%URL%" >> logs\sync.log 2>&1
if errorlevel 1 (
  echo download failed, kept the previous BioImagingNews.html >> logs\sync.log
  if exist BioImagingNews.download del BioImagingNews.download
  exit /b 1
)
move /Y BioImagingNews.download BioImagingNews.html >nul
echo updated BioImagingNews.html >> logs\sync.log
exit /b 0
