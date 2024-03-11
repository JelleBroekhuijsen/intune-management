function Get-GMSIntuneConfigurationObjects {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object[]]
        $ConfigurationObjectTypes,

        [Parameter()]
        [switch]
        $SkipExpand,

        [Parameter()]
        [switch]
        $OutputToDisk
    )

    $configurationObjectTypes | ForEach-Object {
        $objectSet = Invoke-GMSIntuneGraphRequest -Endpoint $_.ApiEndpoint -Method GET -Paging
        $configurationObjectType = $_

        # If the object type has an expand query, we need to retrieve the objects one by one
        if ($_.ExpandQuery -and -not $SkipExpand) {
            $expandedObjectSet = @()
            $objectSet | ForEach-Object {
                $expandedObjectSet += Invoke-GMSIntuneGraphRequest -Endpoint "$($configurationObjectType.ApiEndpoint)/$($_.id)" -Method GET -Query $configurationObjectType.ExpandQuery
            }

            $objectSet = $expandedObjectSet
        }

        # If the object type has a getOmaSettingPlainTextValues, we need to decrypt the omaSettings
        if ($_.getOmaSettingPlainTextValue) {
            $decryptedObjectSet = $objectSet | Where-Object { -not $_.omaSettings.isEncrypted }

            Write-Verbose "Checking for encrypted omaSetings..."
            $objectSet | Where-Object { $_.omaSettings.isEncrypted } | ForEach-Object {
                $object = $_
                Write-Verbose "Found encrypted omaSetting for object $($_.id)"
                $count = $_.omaSettings.Count
                Write-Verbose "Object has $count encrypted omaSettings"

                Foreach ($omaSetting in $_.omaSettings) {
                    # Retrieve the secret value
                    $secretValue = Invoke-GMSIntuneGraphRequest -Endpoint "$($configurationObjectType.ApiEndpoint)/$($object.Id)/getOmaSettingPlainTextValue(secretReferenceValueId='$($omaSetting.secretReferenceValueId)')" -Method GET
                    Write-Verbose "Decrypted omaSetting with secretReferenceValueId $($_.secretReferenceValueId) to '$($secretValue)'"

                    # Update the properties in the object
                    $omaSetting.isEncrypted = $false
                    $omaSetting.secretReferenceValueId = $null
                    if ($_.'@odata.type' -eq '#microsoft.graph.omaSettingStringXml' -or $_.'value@odata.type' -eq '#Binary') {
                        $bytes = [System.Text.Encoding]::UTF8.GetBytes($secretValueText)
                        $omaSetting.value = [Convert]::ToBase64String($bytes)
                    }
                    else {
                        $omaSetting.value = $secretValue
                    }
                }
                $decryptedObjectSet += $object
            }

            $objectSet = $decryptedObjectSet
        }

        Write-Verbose "Retrieved $($objectSet.Count) objects of type $($_.GMSObjectType)"

        if ($OutputToDisk) {
            Output-GMSConfigurationObjectSet -configurationObjectSet $objectSet -configurationObjectType $_
        }
        else {
            $objectSet
        }
    }
}
