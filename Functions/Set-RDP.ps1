Function Set-RDP
{
    <#
        .SYNOPSIS
          Disables or enables RDP on a remote or local computer.

        .DESCRIPTION

        .PARAMETER ComputerName
          Specify the a remote computer or computers.

        .PARAMETER Enable
          Specify whether to enable or disable the RDP by setting this value to true or false. This parameter is required.

        .EXAMPLE

        .NOTES
          NAME    : Set-RDP 
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
        [String[]]$ComputerName,
        [Parameter(
            Mandatory=$True
        )]
        [Boolean]$Enable
    )

    # If computer name is specified for a remote computer loop through and set the value on each remote computer. Else set the 
    # local machine's RDP
    if($ComputerName)
    {
        ForEach($computer in $ComputerName)
        {
            Try
            {
                # Open the registry key of the remote computer
                $regKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $computer)
                $regKey = $regKey.OpenSubKey("SYSTEM\\CurrentControlSet\\Control\\Terminal Server", $True)

                # If enable is true set the UAC key to 1 if false then set to 0
                if($Enable)
                {
                    $regKey.SetValue("fDenyTSConnections", 0)
                }
                else
                {
                    $regKey.SetValue("fDenyTSConnections", 1)
                }
               
                # flush and close the remote registry
                $regKey.flush()
                $regKey.Close()
            }
            Catch
            {
                $Error[0].Exception.Message
            }

        }
    }
    else
    {
        Try
        {
            if($Enable)
            {
                Set-ItemProperty -Path 'Registry::HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server' -name fDenyTSConnections `
                -Value 0 -Force
            }
            else
            {
                Set-ItemProperty -Path 'Registry::HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server' -name fDenyTSConnections `
                -Value 1 -Force
            }
        }
        Catch
        {
            Throw "Couldn't set registry value, please make sure you're in an elevated command prompt and run again."
        }
    }
}
