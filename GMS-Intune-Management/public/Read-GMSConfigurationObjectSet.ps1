Function Read-GMSConfigurationObjectSet {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object]
        $configurationObjectType,

        [Parameter()]
        [string]
        $inputFolder = "C:\repos\jll.io Consultancy\intune-management\$($configurationObjectType.GMSObjectType)"
    )
    
    $objectSet = @()
    $files = Get-ChildItem -Path $inputFolder -Filter *.json

    foreach ($file in $files) {
        $objectSet += Get-Content -Path $file.FullName | ConvertFrom-Json
    }

    $objectSet
}