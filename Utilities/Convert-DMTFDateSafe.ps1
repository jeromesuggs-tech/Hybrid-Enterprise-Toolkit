<#
.SYNOPSIS
    Safely converts a WMI/CIM DMTF datetime string to a [datetime].

.DESCRIPTION
    WMI/CIM often returns DMTF datetime strings (e.g. "20260221123045.000000-300").
    In real environments, values can be null, empty, malformed, or out-of-range.

    This function returns:
      - [datetime] when conversion succeeds
      - $null when input is missing or conversion fails

.PARAMETER DmtfDate
    The DMTF datetime string to convert.

.PARAMETER WarnOnFailure
    If specified, emits a warning when conversion fails.

.EXAMPLE
    Convert-DMTFDateSafe -DmtfDate $obj.LastUseTime

.EXAMPLE
    Convert-DMTFDateSafe $value -WarnOnFailure
#>
function Convert-DMTFDateSafe {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position = 0)]
        [AllowNull()]
        [AllowEmptyString()]
        [string]$DmtfDate,

        [Parameter(Mandatory = $false)]
        [switch]$WarnOnFailure
    )

    if ([string]::IsNullOrWhiteSpace($DmtfDate)) {
        return $null
    }

    try {
        return [System.Management.ManagementDateTimeConverter]::ToDateTime($DmtfDate)
    }
    catch {
        if ($WarnOnFailure) {
            Write-Warning ("Convert-DMTFDateSafe: Failed to convert DMTF date '{0}'. Error: {1}" -f $DmtfDate, $_.Exception.Message)
        }
        return $null
    }
}

# If someone runs the script directly (not dot-sourced), show a tiny hint.
if ($MyInvocation.InvocationName -ne '.') {
    Write-Verbose "Tip: dot-source this file to load the function into your session: . .\Convert-DMTFDateSafe.ps1"
}
