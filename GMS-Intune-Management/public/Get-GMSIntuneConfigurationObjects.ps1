function Get-GMSIntuneConfigurationObjects {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object[]]
        $configurationObjectTypes,

        [Parameter()]
        [switch]
        $OutputToDisk
    )

    $configurationObjectTypes | ForEach-Object {
        $objectSet = Invoke-GMSIntuneGraphRequest -Endpoint $_.ApiEndpoint -Method GET -Paging

        if($_.ExpandQuery){
            $configurationObject = $_
            $expandedObjectSet = @()
            $objectSet | ForEach-Object {
                $expandedObjectSet += Invoke-GMSIntuneGraphRequest -Endpoint "$($configurationObject.ApiEndpoint)/$($_.id)" -Method GET -Query $configurationObject.ExpandQuery
            }

            $objectSet = $expandedObjectSet
        }

        Write-Verbose "Retrieved $($objectSet.Count) objects of type $($_.GMSObjectType)"

        if ($OutputToDisk) {
            Output-GMSConfigurationObjectSet -configurationObjectSet $objectSet -configurationObjectType $_
        }
        else{
            $objectSet
        }
    }
}