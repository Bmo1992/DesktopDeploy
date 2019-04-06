<#
    .DESCRIPTION
      Powershell module for automating the deployment of new workstations.

    .NOTES
      NAME    : DesktopDeploy
      AUTHOR  : BMO
      EMAIL   : brandonseahorse@gmail.com
      GITHUB  : github.com/Bmo1992
      CREATED : April 5, 2019
#>

# Check to see if the current powershell session is elevated to admin. If not warn the user that certain script functions may not work.
$identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [System.Security.Principal.WindowsPrincipal] $identity
$role = [System.Security.Principal.WindowsBuiltInRole] "Administrator"

if(-not $principal.IsInRole($role))
{
    Write-Error "The functions in this module require administrative priviledges to work correctly. Please close this Window and rerun PowerShell as an administrator."
}

# Get the script functions
$Functions = @(Get-ChildItem -Path $PSScriptRoot\Functions\*.ps1 -ErrorAction SilentlyContinue)

# Try to load each function by dot sourcing the file and send all sourcing failures to stderr
ForEach ($script_function in $Functions)
{
    Try
    {
        . $script_function.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($script_function.fullname): $_"
    }
}
