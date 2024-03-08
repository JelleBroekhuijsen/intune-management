Function New-GMSIntuneConfigurationObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object]
        $configurationObject,

        [Parameter(Mandatory)]
        [object]
        $configurationObjectType
    )

    $body = $configurationObject | ConvertTo-Json -Depth 100

    Invoke-GMSIntuneGraphRequest -Endpoint $configurationObjectType.ApiEndpoint -Method POST -Body $body | Out-Null
}