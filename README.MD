# DesktopDeploy

Powershell Module for performing basic desktop configuration tasks quickly.

## Table of Contents
- [Usage](#usage)
  - [Installation](#installation)
  - [Commands](#commands)
    - [Install-Chrome](#Install-Chrome)
    - [Install-Java](#Install-Java)
    - [Set-RDP](#Set-RDP)
    - [Set-UAC](#Set-UAC)

## Usage

### Installation

Instructions coming soon.

### Commands

The following commands are available:

#### Install-Chrome

Install the Google Chrome browser.  This cmdlet downloads the most recent version of Chrome from the Google website and installs it on the local computer.  The installer files are then removed once installation is completed.

```powershell
Install-Chrome
```

#### Install-Java

Install the Oracle's Java.  This cmdlet downloads the most recent version of Java from the Oracle website and installs it on the local computer.  The installer files are then removed once installation is completed.

```powershell
Install-Java
```

#### Set-RDP

Enable or disable RDP on the local computer.  By using the ComputerName arugment one or more remote computers can be specified to enable or disable RDP on.

```powershell
Set-RDP -Enable $True
Set-RDP -Enable $False
```

#### Set-UAC

Enable or disable the Windows UAC on the local computer.  By using the ComputerName arugment one or more remote computers can be specified to enable or disable the UAC on.

```powershell
Set-UAC -Enable $True
Set-UAC -Enable $False
```


