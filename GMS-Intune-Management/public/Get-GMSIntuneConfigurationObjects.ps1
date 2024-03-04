function Get-GMSIntuneConfigurationObjects {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object[]]
        $configurationObjectTypes
    )

    $configurationObjectTypes | ForEach-Object {
        $outputFolder = "C:\repos\jll.io Consultancy\intune-management\$($_.GMSObjectType)"
        if (-not (Test-Path $outputFolder)) {
            New-Item -ItemType Directory -Path $outputFolder \ Out-Null
        }

        $objectSet = Invoke-GMSIntuneGraphRequest -Endpoint $_.ApiEndpoint -Method GET -Paging

        if($_.ExpandQuery){
            $configurationObject = $_
            $expandedObjectSet = @()
            $objectSet | ForEach-Object {
                $expandedObjectSet += Invoke-GMSIntuneGraphRequest -Endpoint "$($configurationObject.ApiEndpoint)/$($_.id)" -Method GET -Query $configurationObject.ExpandQuery
            }

            $objectSet = $expandedObjectSet
        }

        Write-Verbose "Retrieved $($objectSet.Count) objects of type $($_.GMSObjectType)"

        foreach ($object in $objectSet) {
            # Set file identifier for the object
            $fileIdentifier = $_.GMSFileIdentifier

            # Sanitize the display name to avoid illegal characters in the file name
            $displayName = $object.$fileIdentifier -replace '[\\\/\:\*\?\"\<\>\|]', ''
    
            $object | ConvertTo-Json -Depth 100 | Out-File -FilePath "$outputFolder\$($displayName).json" -Force
        }
    }
}