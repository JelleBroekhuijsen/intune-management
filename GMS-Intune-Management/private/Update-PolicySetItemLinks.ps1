Function Update-PolicySetItemLinks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object]
        $configurationObject,

        [Parameter()]
        [object[]]
        $deviceConfigurations,

        [Parameter()]
        [object[]]
        $deviceCompliancePolicies
    )
    
    $itemLinks = $configurationObject.items | Where-Object { $null -ne $_."@odata.type" }
    $updatedItemLinks = @()

    foreach ($itemLink in $itemLinks) {
        if ($itemLink."@odata.type" -match 'deviceConfiguration') {
            $apiEndpoint = ($Global:GMSIntuneConfigurationObjects | Where-Object { $_.GMSObjectType -eq 'deviceConfigurations' }).ApiEndpoint
            $fileIdentifier = ($Global:GMSIntuneConfigurationObjects | Where-Object { $_.GMSObjectType -eq 'deviceConfigurations' }).GMSFileIdentifier
            $query = "?`$select=id,$fileIdentifier"
            $linkedItem = $deviceConfigurations | Where-Object { $_.id -eq $itemlink.payloadId }

            Write-Verbose "Getting linked item with $fileIdentifier $($linkedItem.$fileIdentifier) from target tenant"
            $itemInTargetTenant = Invoke-GMSIntuneGraphRequest -Endpoint $apiEndpoint -Method GET -Query $query -Paging | Where-Object { $_.$fileIdentifier -eq $linkedItem.$fileIdentifier }

            Write-Verbose "Updating linked item id $($itemLink.payloadId) to $($itemInTargetTenant.id) in target tenant"
            $updatedItemLinks += [PSCustomObject]@{
                payloadId     = $itemInTargetTenant.id
                "@odata.type" = $itemLink."@odata.type"
            }

        }
        else {
            Write-Warning "Item type $($itemLink."@odata.type") not supported, will not update item link in target tenant"
        }
    }

    $configurationObject.items = $updatedItemLinks
}