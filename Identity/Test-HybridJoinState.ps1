<#
.SYNOPSIS
    Tests hybrid join state and returns structured output.

.DESCRIPTION
    Wraps dsregcmd /status and parses key identity indicators
    for use in enterprise diagnostics.
#>

$dsreg = dsregcmd /status 2>$null

if (-not $dsreg) {
    Write-Warning "Unable to execute dsregcmd."
    return
}

function Get-Value {
    param($Name)

    ($dsreg | Where-Object { $_ -match "$Name\s*:\s*(.+)" }) `
        -replace ".*:\s*", ""
}

$result = [PSCustomObject]@{
    AzureAdJoined  = Get-Value "AzureAdJoined"
    DomainJoined   = Get-Value "DomainJoined"
    WorkplaceJoined = Get-Value "WorkplaceJoined"
    DeviceId       = Get-Value "DeviceId"
    TenantId       = Get-Value "TenantId"
}

$result
