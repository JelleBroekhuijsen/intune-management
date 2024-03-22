Function Output-GMSConfigurationObjectSet {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object]
        $configurationObjectSet,

        [Parameter(Mandatory)]
        [object]
        $configurationObjectType,

        [Parameter()]
        [string]
        $outputFolder = "C:\repos\jll.io Consultancy\intune-management\$($configurationObjectType.GMSObjectType)"
    )
    foreach ($object in $configurationObjectSet) {
        if (-not (Test-Path $outputFolder)) {
            New-Item -ItemType Directory -Path $outputFolder | Out-Null
        }
        # Set file identifier for the object
        $fileIdentifier = $configurationObjectType.GMSFileIdentifier

        # Sanitize the display name to avoid illegal characters in the file name
        $filename = Format-PolicyFileName $object.$fileIdentifier

        $object | ConvertTo-Json -Depth 100 | Out-File -FilePath "$outputFolder\$($filename).json" -Force
    }
}