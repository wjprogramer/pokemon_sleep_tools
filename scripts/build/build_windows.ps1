# 获取当前日期和时间
$dateTime = Get-Date -Format "yyyyMMdd_HHmmss"

# 执行 flutter build windows
Invoke-Expression "fvm flutter build windows"

# 设置源目录和目标目录
$sourceDir = ".\build\windows\runner\Release"
$targetDir = ".\build\jay\sleep_tools_windows_$dateTime"

# 创建目标目录
New-Item -ItemType Directory -Path $targetDir

# 复制源目录中的文件和子目录到目标目录
Copy-Item -Path $sourceDir -Destination $targetDir -Recurse

Write-Host "Build completed. Files have been copied to $targetDir"
