Function Install-Java
{
    <#
        .SYNOPSIS
          Function to install Java.

        .DESCRIPTION
          Downloads and Installs the most recent version of the Java installer for Windows 64-bit operating systems from the Java website.

        .PARAMETER InstallerPath
          Specify a specific path to download the installer to. Default is C:\Temp.

        .EXAMPLE
          Install-Java

          Installs the most recent version of Java for 64-bit versions of Windows.

        .EXAMPLE
          Install-Java -InstallerPath 'C:\Users\jdoe\Downloads"

          Installs Java and places the Java installer in the C:\Users\jdoe\Downloads directory for the duration of the script.

        .NOTES
          NAME    : Install-Java
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

    # Try to download the most recent version of the Java installer 
    Try
    {
        $Installer = "java_installer.exe"
        
        # Gets the link to the most recent version of the 64-bit version of Java for Windows
        $link= $(Invoke-WebRequest https://www.java.com/en/download/manual.jsp).links | Where{ `
                $_.innerHTML -like "Windows Offline (64-bit)" } | Select href,innerHTML

        Invoke-WebRequest $link.href -OutFile $Path$Installer
    }
    Catch
    {
        Throw "Could download the chrome installer, please verify that the url in the script is correct."
    }

    # Try to start the chrome installer process to run silently
    Try
    {
        Start-Process -FilePath $Path$Installer -Args "/s" -Verb RunAs -Wait
    }
    Catch
    {
        Throw "Couldn't run the installer $Path$Installer, please confirm you have permission to this location and try again."
    }

    # Delete the chrome installer file
    Remove-Item $Path$Installer
}
