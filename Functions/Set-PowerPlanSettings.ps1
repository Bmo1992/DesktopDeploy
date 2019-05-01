Function Set-PowerPlanSetting
{
    <#
        .SYNOPSIS
          Set one or more settings of a Windows powerplan.  Currently the script only supports setting the currently active power plans settings. There are two different settings, battery settings for laptops use AC power wereas when plugged directly to a power source the settings use DC power. 

        .DESCRIPTION
  
        .PARAMETER LidCloseAction
          Specify what action to take upon closing the computer lid (specific to laptops). Options include DoNothing, Sleep, Hibernate, or ShutDown.

        .PARAMETER LowBatteryAction
          Specify what action to take when the low battery threshold is reached (specific to laptops). Options include DoNothing, Sleep, Hibernate, or ShutDown.

        .PARAMETER PowerButtonAction
          Specify what action to take upon pressing the computer power button. Options include DoNothing, Sleep, Hibernate, or ShutDown.
  
        .PARAMETER SleepButtonAction
          Specify what action to take upon pressing the computer sleep button. Options include DoNothing, Sleep, Hibernate, or ShutDown.

        .PARAMETER SleepAfter
          Specify the time in minutes for the computer to enter sleep mode after being idle.

        .PARAMETER HibernateAfter
          Specify the time in minutes for the computer to enter hibernation mode after being idle.

        .PARAMETER TurnOffDisplayAfter
          Specify the time in minutes for the computer to turn it's display off after being idle.

        .PARAMETER TurnOffHardDiskAfter
          Specify the time in minutes for the computer to turn the hard disk off after being idle.

        .PARAMETER AllowHybridSleep
          Turn hybrid sleep on (by specifying TRUE) or off (by specifying FALSE).
 
        .EXAMPLE
 
        .NOTES
          NAME    : Set-PowerPlanSetting
          AUTHOR  : BMO
          EMAIL   : brandonseahorse@gmail.com
          GITHUB  : github.com/Bmo1992
          CREATED : April 29, 2019
    #>
 
    [CmdletBinding()]
    Param
    (
        [Parameter(
            ParameterSetName = "ActionItems"
        )]
        <# Set validation currently not implemented but planned.
        [ValidateSet(
            "DoNothing",
            "Sleep",
            "Hibernate",
            "ShutDown"
        )]
        #>
        [String]$LidCloseAction,
        [String]$LowBatteryAction,
        [String]$PowerButtonAction,
        [String]$SleepButtonAction,
        [int]$SleepAfter,
        [int]$HibernateAfter,
        [int]$TurnOffDisplayAfter,
        [int]$TurnOffHardDiskAfter,
        [bool]$AllowHybridSleep
    )
 
    ###############
    #  FUNCTIONS  #
    ###############
 
    # Get information on all system powerplans 
    Function Get-PowerPlanId
    {
        [CmdletBinding()]
        Param
        (    
            [Parameter(
                Mandatory=$False
            )]
            [bool]$Active
        )

        if($Active)
        {
            (Get-CimInstance -Namespace "root\cimv2\power" -ClassName Win32_PowerPlan | Where{ `
                $_.IsActive -eq $True
            }).InstanceId.Replace("Microsoft:PowerPlan\","")
        }
        else
        {
            (Get-CimInstance -Namespace "root\cimv2\power" -ClassName Win32_PowerPlan).InstanceId.Replace("Microsoft:PowerPlan\","")
        }
    }

    # Get the instance ID of a specific power setting 
    Function Get-PowerSettingId
    {
        [CmdletBinding()]
        Param
        ( 
            [Parameter(
                Mandatory=$True
            )]
            [string]$ElementName
        )

        Try
        {
            (Get-CimInstance -Namespace "root\cimv2\power" -ClassName Win32_PowerSetting | Where{ `
                $_.ElementName -eq "$ElementName"
            }).InstanceId.Replace("Microsoft:PowerSetting\","")
        }
        Catch
        {
            Throw "Couldn't retrieve a powerplan setting for $ElementName"
        }
    }

    # Get the value of a particular power setting
    Function Get-PowerSettingValue
    {
        [CmdletBinding()]
        Param
        (
            [Parameter(
                Mandatory=$True
            )]
            [string]$InputPowerPlanId,
            [string]$InputSettingId
        )

        Get-CimInstance -Namespace "root\cimv2\power" -ClassName Win32_PowerSettingDataIndex `
        -Filter "InstanceID like '%$InputPowerPlanId%AC%$InputSettingId%'"
     } 

    # Set the value of a power setting that has a specific action like do nothing, sleep, hibernate, or ShutDown.
    Function Set-ActionedPowerValue
    {
        [CmdletBinding()]
        Param
        (
            [Parameter(
                Mandatory=$True
            )]
            [string]$PowerSettingAction,
            [object]$ActionedSetting
        ) 

        if($PowerSettingAction -eq "DoNothing")
        {
            $ActionedSetting | Set-CimInstance -Property @{SettingIndexValue = 0}
        }
        elseif($PowerSettingAction -eq "Sleep")
        {
            $ActionedSetting | Set-CimInstance -Property @{SettingIndexValue = 1}
        }
        elseif($PowerSettingAction -eq "Hibernate")
        {
            $ActionedSetting | Set-CimInstance -Property @{SettingIndexValue = 2}
        }
        elseif($PowerSettingAction -eq "ShutDown")
        {
            $ActionedSetting | Set-CimInstance -Property @{SettingIndexValue = 3}
        }
        else
        {
            Throw "$PowerSettingAction is not a valid setting, please choose from the accepted list."
        }
     }

    ######################
    #  GLOBAL VARIABLES  #
    ######################  

    $ActivePowerPlanId = Get-PowerPlanId -Active $True

    ##########
    #  MAIN  #
    ##########
  
    ForEach($boundParam in $PSBoundParameters.GetEnumerator())
    {
        # Configuration settings for Low Battery Action options
        if($boundParam.Key -eq 'LowBatteryAction')
        {
            $LowBatteryId = Get-PowerSettingId -ElementName "Low battery action"
            $LowBattery = Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $LowBatteryId
   
            Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $LowBatteryId
            Set-ActionedPowerValue -PowerSettingAction $LowBatteryAction -ActionedSetting $LowBattery
            Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $LowBatteryId 
        }
        # Configuration settings for Lid Close Action options.
        elseif($boundParam.Key -eq 'LidCloseAction')
        {
            $LidCloseId = Get-PowerSettingId -ElementName "Lid close action"
            $LidClose = Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $LidCloseId
   
            Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $LidCloseId
            Set-ActionedPowerValue -PowerSettingAction $LidCloseAction -ActionedSetting $LidClose
            Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $LidCloseId 
        }
        # Configuration settings for the Power button action options. 
        elseif($boundParam.Key -eq 'PowerButtonAction')
        {
            $PowerButtonId = Get-PowerSettingId -ElementName "Power button action"
            $PowerButton = Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $PowerButtonId
  
            Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $PowerButtonId
            Set-ActionedPowerValue -PowerSettingAction $PowerButtonAction -ActionedSetting $PowerButton
            Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $PowerButtonId 
        }
        # Configuration settings for the Sleep button action options. 
        elseif($boundParam.Key -eq 'SleepButtonAction')
        {
            $SleepButtonId = Get-PowerSettingId -ElementName "Sleep button action"
            $SleepButton = Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $SleepButtonId
 
            Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $SleepButtonId
            Set-ActionedPowerValue -PowerSettingAction $SleepButtonAction -ActionedSetting $SleepButton
            Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $SleepButtonId 
        }
        # Confirure the time in minutes for how long after being idle to enter sleep mode.
        elseif($boundParam.Key -eq 'SleepAfter')
        {
            $SleepAfterId = Get-PowerSettingId -ElementName "Sleep after"
            $SleepAfterTime = Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $SleepAfterId
   
            Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $SleepAfterId 
            $SleepAfterTime | Set-CimInstance -Property @{SettingIndexValue = ([int]$SleepAfter * 60)}
            Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $SleepAfterId 
        }
        # Configure the time in minutes for how long after being idle to enter hibernation mode.
        elseif($boundParam.Key -eq 'HibernateAfter')
        {
            $HibernateAfterId = Get-PowerSettingId -ElementName "Hibernate after"
            $HibernateAfterTime = Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId  -InputSettingId $HibernateAfterId
   
            $HibernateAfterTime | Set-CimInstance -Property @{SettingIndexValue = ([int]$HibernateAfter * 60)}
        }
        # Configure the time in minute for how long after being idle before turning the display off.
        elseif($boundParam.Key -eq 'TurnOffDisplayAfter')
        {
            $TurnOffDisplayAfterId = Get-PowerSettingId -ElementName "Turn off display after"
            $TurnOffDisplayAfterTime = Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $TurnOffDisplayAfterId
                
            Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $TurnOffDisplayAfterId
            $TurnOffDisplayAfterTime | Set-CimInstance -Property @{SettingIndexValue = ([int]$TurnOffDisplayAfter * 60)}
            Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $TurnOffDisplayAfterId
        }
        # Configure the time in minutes for how long after being idle before turning the hard disk off.
        elseif($boundParam.Key -eq 'TurnOffHardDiskAfter')
        {
            $TurnOffHardDiskAfterId = Get-PowerSettingId -ElementName "Turn off hard disk after"
            $TurnOffHardDiskAfterTime = Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $TurnOffHardDiskAfterId

            Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $TurnOffHardDiskAfterId
            $TurnOffHardDiskAfterTime | Set-CimInstance -Property @{SettingIndexValue = ([int]$TurnOffHardDiskAfter * 60)}
            Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $TurnOffHardDiskAfterId
        }
        # Turn hybrid sleep on (TRUE) or off (FALSE)
        elseif($boundParam.Key -eq 'AllowHybridSleep')
        {
            $AllowHybridSleepId = Get-PowerSettingId -ElementName "Allow hybrid sleep"
            $AllowHybridSleepSetting = Get-PowerSettingValue -InputPowerPlantId $ActivePowerPlanId -InputSettingId $AllowHybridSleepId
             
            Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $AllowHybridSleepId
            if($AllowHybridSleep)
            {
                $AllowHybridSleepSetting | Set-CimInstance -Property @{SettingIndexValue = 1}
            }
            else
            {
                $AllowHybridSleepSetting | Set-CimInstance -Property @{SettingIndexValue = 0}
            }
            Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $AllowHybridSleepId
        }
        else
        {
            Throw "No options chosen, exited script."
        }
    }
}
