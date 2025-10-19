<#
backup_mariadb.ps1
PowerShell script to create MariaDB dumps, compress, rotate, and log.
- Reads credentials JSON (host, port, user, password_encrypted or password_plain).
- If password_encrypted is present, attempts DPAPI decryption (user-scope).
- Writes a temporary defaults-extra-file to avoid exposing password on process list.
#>
param(
    [string]$CredsPath = "C:\PosX\mariadb\creds.json",
    [string]$BackupFolder = "C:\PosX\mariadb\backups",
    [int]$RetentionDays = 7,
    [string]$MysqldumpPath = "C:\\Program Files\\MariaDB 11.7\\bin\\mysqldump.exe",
    [string]$LogFile = "C:\PosX\mariadb\backup.log"
)

function Log {
    param([string]$message)
    $t = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$t] $message"
    Add-Content -Path $LogFile -Value $line
}

try {
    if (-not (Test-Path $CredsPath)) {
        Log "Credentials file not found: $CredsPath"
        exit 2
    }
    $raw = Get-Content -Raw $CredsPath | ConvertFrom-Json

    # Determine password: prefer encrypted blob (DPAPI) then plain
    $plainPwd = $null
    if ($raw.password_encrypted) {
        try {
            $securePwd = ConvertTo-SecureString $raw.password_encrypted
            $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePwd)
            try { $plainPwd = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ptr) } finally { [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }
        } catch {
            Log "Failed to decrypt password blob: $_"
            exit 3
        }
    } elseif ($raw.password_plain) {
        $plainPwd = $raw.password_plain
    } else {
        Log "No password found in creds file."
        exit 4
    }

    New-Item -ItemType Directory -Path $BackupFolder -Force | Out-Null
    $timestamp = (Get-Date).ToString('yyyyMMdd_HHmmss')
    $outFile = Join-Path $BackupFolder ("posx_backup_$timestamp.sql")

    # Create temporary defaults-extra-file
    $defaultsContent = @"
[client]
user=$($raw.user)
password=$plainPwd
host=$($raw.host)
port=$($raw.port)
"@
    $tempFile = [System.IO.Path]::GetTempFileName()
    Set-Content -Path $tempFile -Value $defaultsContent -NoNewline -Force

    # Secure temp file: remove inheritance and grant only current user R/W
    icacls $tempFile /inheritance:r | Out-Null
    icacls $tempFile /grant:r "$($env:USERNAME):(R,W)" | Out-Null

    # Run mysqldump
    Log "Starting mysqldump to $outFile"
    $dumpCmd = "`"$MysqldumpPath`" " + "--defaults-extra-file=`"$tempFile`" " + "$($raw.database) --result-file=`"$outFile`""
    $process = Start-Process -FilePath $MysqldumpPath -ArgumentList "--defaults-extra-file=$tempFile", $raw.database, "--result-file=$outFile" -NoNewWindow -Wait -PassThru
    if ($process.ExitCode -ne 0) {
        Log "mysqldump failed with exit code $($process.ExitCode)"
        exit $process.ExitCode
    }

    # Compress using Compress-Archive (creates ZIP)
    $zipFile = "$outFile.zip"
    Compress-Archive -Path $outFile -DestinationPath $zipFile -Force
    Remove-Item -Path $outFile -Force
    Log "Backup created: $zipFile"

    # Rotate old backups
    Get-ChildItem -Path $BackupFolder -Filter 'posx_backup_*.zip' | Where-Object { $_.CreationTime -lt (Get-Date).AddDays(-$RetentionDays) } | Remove-Item -Force
    Log "Rotation complete. RetentionDays=$RetentionDays"

    # Clean up temp file
    Remove-Item -Path $tempFile -Force
    # zero plainPwd variable
    $plainPwd = $null
    exit 0
} catch {
    Log "Unhandled error: $_"
    exit 9
}
