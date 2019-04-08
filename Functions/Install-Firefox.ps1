Function Install-Firefox
{
    <#
        .SYNOPSIS
          Function to install the Mozilla Firefox web browser.

        .DESCRIPTION
          Pull the Firefox installer from the Mozilla Firefox website via powershell and cleanup any leftover installation files.

        .PARAMETER InstallerPath
          Specify a different path to download the Firefox installer to. The default is C:\Temp.

        .EXAMPLE
          Install-Firefox

          Installs the latest version of Mozilla Firefox using the function defaults.

        .EXAMPLE
          Install-Firefox -InstallerPath C:\Users\jdoe\Downloads

          Downloads the latest version of Mozilla Firefox, places the installer file in C:\Users\jdoe\Downloads, and install the browser.

        .NOTES
          NAME    : Install-Firefox
          AUTHOR  : BMO
          EMAIL   : brandonseahorse@gmail.com
          GITHUB  : github.com/Bmo1992
          CREATED : April 8, 2019
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(
            Mandatory=$False
        )]
        [string]$InstallerPath
    )
    
    # Set the path to the installer variable to the user specified var or set it to $env:TEMP if none specified.
    if($InstallerPath)
    {
        $Path = $InstallerPath
    }
    else
    {
        $Path = $env:TEMP
    }

    # Try to download the most recent version of the Firefox installer 
    Try
    {
        $Installer = "firefox_installer.exe"
    
        Try
        {
            $latest_version = (Invoke-WebRequest "https://product-details.mozilla.org/1.0/firefox_versions.json").Content | ConvertFrom-Json
            $latest_version_id = $latest_version | Select -ExpandProperty LATEST_FIREFOX_VERSION
        }
        Catch
        {
            Throw "Couldnt pull the most recent version of Firefox from Mozilla. Please submit a bug report."
        }

        $firefox_source = "https://download.mozilla.org/?product=firefox-" + "$latest_version_id" + "-SSL&os=win64&lang=en-US"
        Invoke-WebRequest $firefox_source -OutFile $Path$Installer
    }
    Catch
    {
        Throw "Could download the Firefox installer, please verify that the url in the script is correct or submit a bug report."
    }

    # Try to start the chrome installer process to run silently
    Try
    {
        Start-Process -FilePath $Path$Installer -Verb RunAs -Wait
    }
    Catch
    {
        Throw "Couldn't run the installer $Path$Installer, please confirm you have permission to this location and try again."
    }

    # Delete the chrome installer file
    Remove-Item $Path$Installer
}
