Connect-MgGraph -TenantId f7a27bfc-a984-4aaa-9d02-69f054a787e0 -Scopes "DeviceManagementConfiguration.Read.All", "DeviceManagementConfiguration.ReadWrite.All"

$outputFolder = 'C:\repos\jll.io Consultancy\intune-management\policySets'
if(-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder
}
else{
    Remove-Item -Path $outputFolder\* -Recurse -Force
}

# Retrieve all settings policy sets
$policySets = Invoke-GMSIntuneGraphRequest -Endpoint policySets -Method GET -Paging

foreach ($policySet in $policySets) {
    # Sanitize the display name to avoid illegal characters in the file name
    $displayName = $policySet.displayName -replace '[\\\/\:\*\?\"\<\>\|]', ''

    $policySet | ConvertTo-Json | Out-File -FilePath "$outputFolder\$($displayName).json" 
}