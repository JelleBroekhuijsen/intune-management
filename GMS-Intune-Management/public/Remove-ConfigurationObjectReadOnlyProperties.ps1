Function Remove-ConfigurationObjectReadOnlyProperties {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object]
        $configurationObject,

        [Parameter()]
        [object]
        $configurationObjectType
    )

    $propertiesToRemove = @()

    # Add default properties
    $readOnlyProperties = @(
        "createdDateTime",
        "id",
        "lastModifiedDateTime",
        "modifiedDateTime",
        "supportsScopeTags"
    )
    $propertiesToRemove += $readOnlyProperties


    # Add OData properties
    $configurationObject.PSObject.Properties | Where-Object { $_.Name -like "*@Odata*link" -or $_.Name -like "*@odata.context" -or $_.Name -like "*@odata.id" -or ($_.Name -like "*@odata.type" -and $_.Name -ne "@odata.type") } | ForEach-Object {
        $propertiesToRemove += $_.Name
    }

    # Remove properties
    foreach ($property in $propertiesToRemove) {
        $configurationObject = Remove-PropertyFromObject -object $configurationObject -property $property
    }

    # Remove properties from child objects
    foreach ($property in $configurationObject.PSObject.Properties) {
        if ($configurationObject."$($property.Name)"."@odata.type") {
            foreach ($childObject in ($configurationObject."$($property.Name)")) {
                Remove-ConfigurationObjectReadOnlyProperties -configurationObject $childObject -configurationObjectType $configurationObjectType
            }
        }
    }
}