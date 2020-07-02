[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$ArmOutputString,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [switch]$MakeOutput
)

Write-Output "Retrieved input: $ArmOutputString"
$armOutputObj = $ArmOutputString | ConvertFrom-Json

$armOutputObj.PSObject.Properties | ForEach-Object {
    $type = ($_.value.type).ToLower()
    $keyname = $_.Name
    $vsoAttribs = @("task.setvariable variable=$keyName")

    Write-Output "dupa"
    if ($type -eq "array") {
        $value = $_.Value.value.name -join ',' ## All array variables will come out as comma-separated strings
    } elseif ($type -eq "securestring") {
        $vsoAttribs += 'isSecret=true'
    } elseif ($type -ne "string") {
        throw "Type '$type' is not supported for '$keyname'"
    } else {
        $value = $_.Value.value
    }
        
    if ($MakeOutput.IsPresent) {
        $vsoAttribs += 'isOutput=true'
    }
    Write-Output "dupa2"
    $attribString = $vsoAttribs -join ';'
    $var = "##vso[$attribString]$value"
    Write-Output -InputObject $var
    Write-Output $var
    Write-Output "dupa3"
}