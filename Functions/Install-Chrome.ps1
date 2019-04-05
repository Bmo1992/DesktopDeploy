Function Install-Chrome
{
    <#
        .SYSNOPSIS
          Function to install the Google Chrome web browser.

        .DESCRIPTION
          Pull the chrome installer from the Google Chrome website via powershell and cleanup any leftover installation files.

        .PARAMETER InstallerPath
          Specify a different path to download the Google Chrome installer to. The default is C:\Temp.

        .EXAMPLE
          Install-Chrome

          Installs Google Chrome using the application defaults.

        .EXAMPLE
          Install-Chrome -InstallerPath 'C:\Users\jdoe\Downloads"

          Installs Google Chrome and places the Chrome installer in the C:\Users\jdoe\Downloads directory for the duration of the script.

        .NOTES
          NAME    : Install-Chrome
          AUTHOR  : BMO
          EMAIL   : brandonseahorse@gmail.com
          GITHUB  : github.com/Bmo1992
          CREATED : April 5, 2019
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

    # Try to download the most recent version of the Chrome installer 
    Try
    {
        $Installer = "chrome_installer.exe"
        Invoke-WebRequest "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $Path$Installer
    }
    Catch
    {
        Throw "Could download the chrome installer, please verify that the url in the script is correct."
    }

    # Try to start the chrome installer process to run silently
    Try
    {
        Start-Process -FilePath $Path$Installer -Args "/silent /install" -Verb RunAs -Wait
    }
    Catch
    {
        Throw "Couldn't run the installer $Path$Installer, please confirm you have permission to this location and try again."
    }

    # Delete the chrome installer file
    Remove-Item $Path$Installer
}
