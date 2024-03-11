function Invoke-GMSIntuneGraphRequest {
    [CmdletBinding()]
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
        $Paging,

        [Parameter()]
        $Body
    )

    $results = @()
    
    $uri = $BaseUrl + $EndPoint + $Query 

    Write-Verbose "Invoke-GMSIntuneGraphRequest: $Method $uri"

    if ($Method -eq "GET") {
        $response = Invoke-MgGraphRequest -Uri $Uri -Method $Method -ContentType 'application/json' -OutputType Json | ConvertFrom-Json
        $results = $response.value ? $response.value : $null
    
        if ($Paging) {
            While ($response.'@odata.nextLink') {
                Write-Verbose "Invoke-GMSIntuneGraphRequest: paging with nextLink: $($response.'@odata.nextLink')"
                $response = Invoke-MgGraphRequest -Uri $response.'@odata.nextLink' -Method Get  -ContentType 'application/json' -OutputType Json | ConvertFrom-Json
                $results += $response.value ? $response.value : $null
            }
        }
    }
    
    if ($Method -eq "POST") {
        Write-Verbose "Invoke-GMSIntuneGraphRequest with headers: $($headers.values)"
        $response = Invoke-MgGraphRequest -Uri $Uri -Method $Method -ContentType 'application/json' -Body $Body
        $results = $response
    }

    if ($Method -eq "DELETE") {
        $response = Invoke-MgGraphRequest -Uri $Uri -Method $Method -ContentType 'application/json'
        $results = $response
    }

    $results
}