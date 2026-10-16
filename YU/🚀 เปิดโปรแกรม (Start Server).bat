@echo off
chcp 65001 >nul
title YouTube Multi-Screen Launcher (Local Server)
echo ============================================================
echo   YouTube Multi-Screen & Multi-Tab Auto Launcher
echo   กำลังเริ่มต้นเซิร์ฟเวอร์ Localhost เพื่อป้องกัน Error 153...
echo ============================================================
echo.

cd /d "%~dp0"

REM ตรวจสอบว่ามี Python หรือ Node หรือไม่
where python >nul 2>nul
if %errorlevel% equ 0 (
    echo [OK] ตรวจพบ Python 
    echo กำลังเปิดเว็บที่ http://localhost:8080 ...
    start "" "http://localhost:8080/index.html"
    echo.
    echo เซิร์ฟเวอร์กำลังทำงาน... (อย่าเพิ่งปิดหน้าต่างสีดำนี้ขณะใช้งาน)
    echo กด Ctrl+C หรือปิดหน้าต่างนี้เมื่อเลิกใช้งาน
    echo.
    python -m http.server 8080
    goto end
)

where node >nul 2>nul
if %errorlevel% equ 0 (
    echo [OK] ตรวจพบ Node.js
    echo กำลังเปิดเว็บที่ http://localhost:8080 ...
    start "" "http://localhost:8080/index.html"
    echo.
    echo เซิร์ฟเวอร์กำลังทำงาน... (อย่าเพิ่งปิดหน้าต่างสีดำนี้ขณะใช้งาน)
    npx -y http-server -p 8080 -c-1
    goto end
)

REM Fallback ด้วย PowerShell ถ้าไม่มีทั้งคู่
echo กำลังเริ่มต้นผ่าน PowerShell Web Server...
start "" "http://localhost:8080/index.html"
powershell -Command "$listener = New-Object System.Net.HttpListener; $listener.Prefixes.Add('http://localhost:8080/'); $listener.Start(); Write-Host 'Server running at http://localhost:8080/...'; while($listener.IsListening){ $ctx = $listener.GetContext(); $req = $ctx.Request; $res = $ctx.Response; $path = '.' + $req.RawUrl.Split('?')[0]; if($path -eq './'){$path = './index.html'}; if(Test-Path $path){ $bytes = [System.IO.File]::ReadAllBytes($path); $res.ContentLength64 = $bytes.Length; $res.OutputStream.Write($bytes, 0, $bytes.Length) } else { $res.StatusCode = 404 }; $res.OutputStream.Close() }"

:end
pause
