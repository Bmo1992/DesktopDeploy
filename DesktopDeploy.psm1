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
