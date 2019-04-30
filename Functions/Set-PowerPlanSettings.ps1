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
        <#
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
  
        <#
        [Parameter(
            ParameterSetName = "TimedItems"
        )]
        #>
        [int]$SleepAfter,
        [int]$HibernateAfter,
        [int]$AllowHybridSleep,
        [int]$TurnOffDisplayAfter,
        [int]$TurnOffHardDiskAfter
         
        )
 
 # FUNCTIONS
 
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

        # GLOBAL VARIABLES

        #$PowerSettings = Get-CimInstance -Namespace "root\cimv2\power" -ClassName Win32_PowerSetting
        $ActivePowerPlanId = Get-PowerPlanId -Active $True



  
        ForEach($boundParam in $PSBoundParameters.GetEnumerator())
        {
            # Configuration settings for Low Battery Action options
            if($boundParam.Key -eq 'LowBatteryAction')
            {
                $LowBatteryId = Get-PowerSettingId -ElementName "Low battery action"
                $LowBattery = Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $LowBatteryId
   
                Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $LowBatteryId
                if($LowBatteryAction -eq "DoNothing")
                {
                    $LowBattery | Set-CimInstance -Property @{SettingIndexValue = 0}
                }
                elseif($LowBatteryAction -eq "Sleep")
                {
                    $LowBattery | Set-CimInstance -Property @{SettingIndexValue = 1}
                }
                elseif($LowBatteryAction -eq "Hibernate")
                {
                    $LowBattery | Set-CimInstance -Property @{SettingIndexValue = 2}
                }
                elseif($LowBatteryAction -eq "ShutDown")
                {
                    $LowBattery | Set-CimInstance -Property @{SettingIndexValue = 3}
                }
                else
                {
                    Throw "$LowBatteryAction is not a valid setting, please choose from the accepted list"
                }
                Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $LowBatteryId 
            }
            # Configuration settings for Lid Close Action options.
            elseif($boundParam.Key -eq 'LidCloseAction')
            {
                $LidCloseId = Get-PowerSettingId -ElementName "Lid close action"
                $LidClose = Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $LidCloseId
   
                Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $LidCloseId
                if($LidCloseAction -eq "DoNothing")
                {
                    $LidClose | Set-CimInstance -Property @{SettingIndexValue = 0}
                }
                elseif($LidCloseAction -eq "Sleep")
                {
                    $LidClose | Set-CimInstance -Property @{SettingIndexValue = 1}
                }
                elseif($LidCloseAction -eq "Hibernate")
                {
                    $LidClose | Set-CimInstance -Property @{SettingIndexValue = 2}
                }
                elseif($LidCloseAction -eq "ShutDown")
                {
                    $LidClose | Set-CimInstance -Property @{SettingIndexValue = 3}
                }
                else
                {
                    Throw "$LowBatteryAction is not a valid setting, please choose from the accepted list"
                }
                Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $LidCloseId 
            }
            # Configuration settings for the Power button action options. 
            elseif($boundParam.Key -eq 'PowerButtonAction')
            {
                $PowerButtonId = Get-PowerSettingId -ElementName "Power button action"
                $PowerButton = Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $PowerButtonId
   
                Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $PowerButtonId
                if($PowerButtonAction -eq "DoNothing")
                {
                    $PowerButton | Set-CimInstance -Property @{SettingIndexValue = 0}
                }
                elseif($PowerButtonAction -eq "Sleep")
                {
                    $PowerButton | Set-CimInstance -Property @{SettingIndexValue = 1}
                }
                elseif($PowerButtonAction -eq "Hibernate")
                {
                    $PowerButton | Set-CimInstance -Property @{SettingIndexValue = 2}
                }
                elseif($PowerButtonAction -eq "ShutDown")
                {
                    $PowerButton | Set-CimInstance -Property @{SettingIndexValue = 3}
                }
                else
                {
                    Throw "$LowBatteryAction is not a valid setting, please choose from the accepted list"
                }
                Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $PowerButtonId 
            }
            # Configuration settings for the Sleep button action options. 
            elseif($boundParam.Key -eq 'SleepButtonAction')
            {
                $SleepButtonId = Get-PowerSettingId -ElementName "Sleep button action"
                $SleepButton = Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $SleepButtonId
   
                Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $SleepButtonId
                if($SleepButtonAction -eq "DoNothing")
                {
                    $SleepButton | Set-CimInstance -Property @{SettingIndexValue = 0}
                }
                elseif($SleepButtonAction -eq "Sleep")
                {
                    $SleepButton | Set-CimInstance -Property @{SettingIndexValue = 1}
                }
                elseif($SleepButtonAction -eq "Hibernate")
                {
                    $SleepButton | Set-CimInstance -Property @{SettingIndexValue = 2}
                }
                elseif($SleepButtonAction -eq "ShutDown")
                {
                    $SleepButton | Set-CimInstance -Property @{SettingIndexValue = 3}
                }
                else
                {
                    Throw "$SleepButtonAction is not a valid setting, please choose from the accepted list"
                }
                Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $SleepButtonId 
            }
            elseif($boundParam.Key -eq 'SleepAfter')
            {
                $SleepAfterId = Get-PowerSettingId -ElementName "Sleep after"
                $SleepAfterTime = Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $SleepAfterId
   
                Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $SleepAfterId 
                $SleepAfterTime | Set-CimInstance -Property @{SettingIndexValue = ([int]$SleepAfter * 60)}
                Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId -InputSettingId $SleepAfterId 
            }
            elseif($boundParam.Key -eq 'HibernateAfter')
            {
                $HibernateAfterId = Get-PowerSettingId -ElementName "Hibernate after"
                $HibernateAfterTime = Get-PowerSettingValue -InputPowerPlanId $ActivePowerPlanId  -InputSettingId $HibernateAfterId
   
                $HibernateAfterTime | Set-CimInstance -Property @{SettingIndexValue = ([int]$HibernateAfter * 60)}
            }
            else
            {
                Throw "No options chosen, exited script."
            }
        }
}
