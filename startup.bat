@rem -------------------------------
@rem Thierry Buisson
@rem use this script to run Run PSURLCapture
@rem -------------------------------

@rem give your current path here
cd %~dp0

SET gPowershellPath="%windir%\system32\WindowsPowerShell\v1.0\"
SET PATH=%PATH%;%gPowershellPath%

@rem example 1
powershell.exe -command "& .\PSURLCapture.ps1 '.\PSURLCapture.txt' "

@rem example 2
REM echo "http://www.thierrybuisson.fr" > PSURLCapture2.txt
REM powershell.exe -command "& .\PSURLCapture.ps1 '.\PSURLCapture2.txt' -path 'c:\temp\' -type jpg -width 1024 -delay 3000 "

pause