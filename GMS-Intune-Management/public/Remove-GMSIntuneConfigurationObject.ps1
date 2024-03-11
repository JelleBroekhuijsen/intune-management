Function Remove-GMSIntuneConfigurationObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object]
        $configurationObject,

        [Parameter(Mandatory)]
        [object]
        $configurationObjectType
    )

    Write-Verbose "Remove-GMSIntuneConfigurationObject: $($configurationObjectType.Name) $($configurationObject.id)"
    Invoke-GMSIntuneGraphRequest -Endpoint "$($configurationObjectType.ApiEndpoint)/$($ConfigurationObject.id)" -Method DELETE
}