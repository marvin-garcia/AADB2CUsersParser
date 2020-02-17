cls
$sourceFile = "C:\Users\magar\Downloads\B2C-GraphAPI-DotNet-master\B2C-GraphAPI-DotNet-master\Users"
$B2CexePath = "C:\Users\magar\Downloads\B2C-GraphAPI-DotNet-master\B2C-GraphAPI-DotNet-master\B2CGraphClient\bin\Debug\B2C.exe"

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
    }
    catch [System.Exception]
    {
        Write-Host -ForegroundColor Red "Exception: Unable to add user $($file.Name) to AAD B2C. Reason: $($_)"
        Write-Host -ForegroundColor Cyan "Press Enter to continue"
        Read-Host " "
    }
}