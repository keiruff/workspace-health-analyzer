param(
    [string]$Path = "."
)

$Extensions = @(
    "*.cfg",
    "*.pcf",
    "*.ucf",
    "*.dgnlib",
    "*.cel",
    "*.rsc"
)

$Results = foreach ($Ext in $Extensions) {
    Get-ChildItem -Path $Path -Recurse -Filter $Ext -ErrorAction SilentlyContinue |
    Select-Object @{
        Name="FileName";Expression={$_.Name}
    },
    @{
        Name="Extension";Expression={$_.Extension}
    },
    @{
        Name="FullPath";Expression={$_.FullName}
    },
    @{
        Name="LastModified";Expression={$_.LastWriteTime}
    },
    @{
        Name="SizeKB";Expression={[math]::Round($_.Length / 1KB,2)}
    }
}

$Results |
Export-Csv ".\workspace-health-report.csv" -NoTypeInformation

Write-Host ""
Write-Host "Workspace Health Report Generated"
Write-Host "Output: workspace-health-report.csv"
Write-Host ""
Write-Host "Files Found: $($Results.Count)"