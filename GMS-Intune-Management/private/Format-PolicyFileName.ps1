function Format-PolicyFileName{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $policyName
    )
    $policyName -replace '[\\\/\:\*\?\"\<\>\|]', ''
}
