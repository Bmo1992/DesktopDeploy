Function Start-DDMenu
{
    <#
        .SYNOPSIS

        .DESCRIPTION

        .EXAMPLE

        .NOTES
          NAME    : Start-DDMenu
          AUTHOR  : BMO
          EMAIL   : brandonseahorse@gmail.com
          GITHUB  : github.com/Bmo1992
          CREATED : April 5, 2019
    #>
    [CmdletBinding()]
    Param
    (
    )

    Function Get-Menu
    {
        Clear-Host
        Write-Host "0) "
        Write-Host "1) "
        Write-Host "2) "
        Write-Host "3) "
        Write-Host $null
    }

    Do
    {
        Get-Menu

        $Option = Read-Host "Please Choose an option: "
        switch($Option)
        {
            '0' {
                Break
            }
            '1' {
                Break
            }
            '2' {
                Break
            }
            '3' {
                Break
            }
        }
    } While($True)
}
