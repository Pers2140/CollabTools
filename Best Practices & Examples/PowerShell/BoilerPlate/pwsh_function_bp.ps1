

function MyFunction {
    [CmdletBinding()]
    param (
        # Parameter 1 description
        [Parameter(Mandatory = $true)]
        [string]$Parameter1,

        # Parameter 2 description
        [Parameter()]
        [int]$Parameter2 = 42
    )

    # Begin function logic

    try {
        # Code that may throw exceptions
    } catch {
        # Exception handling
    }

    # End function logic

    # Output
    Write-Output "Parameter1: $Parameter1"
    Write-Output "Parameter2: $Parameter2"
}