Function Remove-PropertyFromObject {
    param(
        [Parameter(Mandatory)]
        $object, 
        [Parameter(Mandatory)]
        $property
    )
    if ($object | Get-Member -Name $property -MemberType NoteProperty) {
        Write-Debug "Remove-PropertyFromObject: Removing property $property from object"
        $object.PSObject.Properties.Remove($property)
    }       

    $object
}