cls
$sourceFile = "..\Users\"
$B2CexePath = "..\B2CGraphClient\B2CGraphClient\bin\Debug\B2C.exe"
$groupId = "8f9956d6-18bb-4f8c-b05d-d684ef288bfb"

$files = Get-ChildItem -Path $sourceFile
$errorMessage = "error calling the graph api"
foreach ($file in $files)
{
    Write-Host -ForegroundColor Green $file.Name
    
    try
    {
        $output = & $B2CexePath Create-User $file.FullName
        if ($output -like "*$errorMessage*")
        {
            Write-Host -ForegroundColor Red "`r`nUnable to add user $($file.Name) to AAD B2C."
            Write-Host -ForegroundColor Red "`r`n$output"
            Write-Host -ForegroundColor Cyan "`r`nPress Enter to continue"
            Read-Host " "
        }

        $pattern = '.*"objectId": "([a-z0-9\-]+)".*'
        $match = [System.Text.RegularExpressions.Regex]::Match($($output | where { $_ -like "*objectId*" }), $pattern)
        $objectId = $match.Groups[1].Value

        if (!!$groupId)
        {
            Write-Host -ForegroundColor Cyan "`r`nAdding user $objectId to group $groupId`r`n"
            & $B2CexePath Add-Member $objectId $groupId
        }
    }
    catch [System.Exception]
    {
        Write-Host -ForegroundColor Red "Exception: Unable to add user $($file.Name) to AAD B2C. Reason: $($_)"
        Write-Host -ForegroundColor Cyan "Press Enter to continue"
        Read-Host " "
    }
}