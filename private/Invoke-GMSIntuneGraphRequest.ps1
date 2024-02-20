function Invoke-GMSIntuneGraphRequest {
    param(
        [Parameter()]
        [string]
        $BaseUrl = "https://graph.microsoft.com/beta",

        [Parameter(Mandatory)]
        [ValidateSet("deviceConfigurations", "configurationPolicies", "policySets")]
        [string]
        $Endpoint,

        [Parameter()]
        [string]
        $FilterQuery,
        
        [Parameter(Mandatory)]
        [ValidateSet("GET", "POST", "DELETE")]
        [string]
        $Method,

        [Parameter()]
        [Switch]
        $Paging
    )

    $results = @()
    
    switch ($Endpoint) {
        "deviceConfigurations" { $uri = $BaseUrl + "/deviceManagement/deviceConfigurations" + $FilterQuery }
        "configurationPolicies" { $uri = $BaseUrl + "/deviceManagement/configurationPolicies" + $FilterQuery }
        "policySets" { $uri = $BaseUrl + "/deviceAppManagement/policySets" + $FilterQuery }
    }
    Write-Verbose "Invoke-GMSIntuneGraphRequest: $Method $uri"
    
    $headers = @{
        "Content-Type" = "application/json;charset=utf-8"
        "Accept"       = "application/json;odata.metadata=full"
    }
    
    $response = Invoke-MgGraphRequest -Uri $Uri -Method $Method -Headers $headers -OutputType Json | ConvertFrom-Json
    $results = $response.value
    if ($Paging) {
        While ($response.'@odata.nextLink') {
            Write-Verbose "Invoke-GMSIntuneGraphRequest: paging with nextLink: $($response.'@odata.nextLink')"
            $response = Invoke-MgGraphRequest -Uri $response.'@odata.nextLink' -Method Get -Headers $headers -OutputType Json | ConvertFrom-Json
            $results += $response.value
        }
    }

    $results
}