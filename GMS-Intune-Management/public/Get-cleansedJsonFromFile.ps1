function Get-cleansedJsonFromFile() {
        <#
        .SYNOPSIS
            Removes date time and unique ID's from a JSON file and replaces them with consistent placeholders
            Optionally, ensures values of other passed in properties are also generalized
            
        .PARAMETER filePath
            input file full path

        .PARAMETER additionalProperties
            additional properties to generalize the value of

        .EXAMPLE
            Get-cleansedJsonFromFile -filePath "C:\temp\file.json" -additionalProperties "email","name"
    #>
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $True)]$filePath,
        [Array]$additionalProperties
    )
    
    $content = Get-Content -Path $filePath -raw
    $baseID = "GMUNID_$(($filePath | Split-Path -LeafBase).Trim().GetHashCode())_" #define a base ID to use for all unique values
    $uniqueIdentifiers = @() #define an empty array to hold all unique values that should be generalized accross tenants

    #handle GUIDS where we replace the GUID
    foreach($uniqueId in $content | Select-String -Pattern '\b(?:[0-9a-fA-F]){8}-(?:[0-9a-fA-F]){4}-(?:[0-9a-fA-F]){4}-(?:[0-9a-fA-F]){4}-(?:[0-9a-fA-F]){12}\b' -AllMatches | ForEach-Object { $_.Matches.Value }){
        if($uniqueIdentifiers -notcontains $uniqueId){
            $uniqueIdentifiers += $uniqueId
        }
    }

    #handle dates in various formats where we replace the date
    foreach($uniqueId in $content | Select-String -Pattern '\b\d{1,4}[-/]\d{1,2}[-/]\d{1,4}(?:[ T]\d{1,2}:\d{2}(?::\d{2})?(?:Z)?)?\b' -AllMatches | ForEach-Object { $_.Matches.Value }){
        if($uniqueIdentifiers -notcontains $uniqueId){
            $uniqueIdentifiers += $uniqueId
        }        
    }
    
    #handle additional properties, where we replace the value of the property
    if($additionalProperties){
        foreach($property in $additionalProperties){
            foreach($matchedValue in ($content | Select-String -Pattern "`"$property`"\s*:\s*`"([^`"]+)`"" -AllMatches).Matches | ForEach-Object { $_.Groups[1].Value}){
                if($uniqueIdentifiers -notcontains $matchedValue){
                    $uniqueIdentifiers += $matchedValue
                }        
            }
        }
    }

    #replace specific strings in the file's content with generalized ones
    for($i=0;$i -lt $uniqueIdentifiers.Count;$i++){
        $content = $content -replace $uniqueIdentifiers[$i], "$baseID$($i)"
    }

    #write back to file
    $content | Set-Content -Path $filePath -Force

}