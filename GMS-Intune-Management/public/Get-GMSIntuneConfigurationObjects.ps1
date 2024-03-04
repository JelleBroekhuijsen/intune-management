function Get-GMSIntuneConfigurationObjects {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet("deviceConfigurations", "configurationPolicies", "policySets")]
        [string[]]
        $configurationObjectTypes
    )

    $configurationObjectTypes | ForEach-Object {
        $outputFolder = "C:\repos\jll.io Consultancy\intune-management\$_"
        if (-not (Test-Path $outputFolder)) {
            New-Item -ItemType Directory -Path $outputFolder
        }
        else {
            Remove-Item -Path $outputFolder\* -Recurse -Force
        }
    
        # Retrieve all settings policy sets
        $objectSet = Invoke-GMSIntuneGraphRequest -Endpoint $_ -Method GET -Paging
    
        foreach ($object in $objectSet) {
            # Set file identifier for the object
            $fileIdentifier = $Global:GMSIntuneConfigurationObjects | Where-Object GMSObjectType -eq $_ | Select-Object -ExpandProperty GMSFileIdentifier

            # Sanitize the display name to avoid illegal characters in the file name
            $displayName = $object.$fileIdentifier -replace '[\\\/\:\*\?\"\<\>\|]', ''
    
            $object | ConvertTo-Json -Depth 100 | Out-File -FilePath "$outputFolder\$($displayName).json" -Force
        }
    }
}
