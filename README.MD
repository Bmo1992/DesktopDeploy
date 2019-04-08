# DesktopDeploy

Powershell Module for performing basic desktop configuration tasks quickly.

## Table of Contents
- [Usage](#usage)
  - [Installation](#installation)
  - [Commands](#commands)
    - [Install-Chrome](#Install-Chrome)
    - [Install-Java](#Install-Java)
    - [Set-RDP](#Install-RDP)
    - [Set-UAC](#Set-UAC)

## Usage

### Installation

```powershell
Install-Module -Name DesktopDeploy
```

### Commands

The following commands are available:

#### Install-Chrome

```powershell
Install-Chrome
```

#### Install-Java

```powershell
Install-Java
```

#### Set-RDP

```powershell
Set-RDP -Enable $True
Set-RDP -Enable $False
```

#### Set-UAC

```powershell
Set-UAC -Enable $True
Set-UAC -Enable $False
```


