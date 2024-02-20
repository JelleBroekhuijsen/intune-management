$Public = @(Get-ChildItem -Path $PSScriptRoot\public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\private\*.ps1 -ErrorAction SilentlyContinue)

foreach ($import in @($Public + $Private)) {
    try {
        . $import.FullName
    }
    catch {
        Write-Error -Message "Failed to import $($import.fullname): $_"
    }
}

$baseUrl = 'https://graph.microsoft.com'

$headers = @{
    "Content-Type" = "application/json; charset=utf-8"
    "Accept" = "application/json;odata.metadata=full"
}

Export-ModuleMember -Function $Public.BaseName

Import-Module $Legacy.FullName -Global
