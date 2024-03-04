function Invoke-GMSIntuneGraphRequest {
    param(
        [Parameter()]
        [string]
        $BaseUrl = "https://graph.microsoft.com/beta",

        [Parameter(Mandatory)]
        [string]
        $Endpoint,

        [Parameter()]
        [string]
        $Query,
        
        [Parameter(Mandatory)]
        [ValidateSet("GET", "POST", "DELETE")]
        [string]
        $Method,

        [Parameter()]
        [Switch]
        $Paging
    )

    $results = @()
    
    $uri = $BaseUrl + $EndPoint + $Query 

    Write-Verbose "Invoke-GMSIntuneGraphRequest: $Method $uri"
    
    $headers = @{
        "Content-Type" = "application/json;charset=utf-8"
        "Accept"       = "application/json;odata.metadata=full"
    }
    
    $response = Invoke-MgGraphRequest -Uri $Uri -Method $Method -Headers $headers -OutputType Json | ConvertFrom-Json
    $results = $response.value ? $response.value : $response

    if ($Paging) {
        While ($response.'@odata.nextLink') {
            Write-Verbose "Invoke-GMSIntuneGraphRequest: paging with nextLink: $($response.'@odata.nextLink')"
            $response = Invoke-MgGraphRequest -Uri $response.'@odata.nextLink' -Method Get -Headers $headers -OutputType Json | ConvertFrom-Json
            $results += $response.value ? $response.value : $response
        }
    }

    $results
}