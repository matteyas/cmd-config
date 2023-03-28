Function nightlight {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)] [bool]$Enabled
    )

    $data = (0x43, 0x42, 0x01, 0x00, 0x0A, 0x02, 0x01, 0x00, 0x2A, 0x06)
    $epochTime = [System.DateTimeOffset]::new((date)).ToUnixTimeSeconds()
    $data += $epochTime -band 0x7F -bor 0x80
    $data += ($epochTime -shr 7) -band 0x7F -bor 0x80
    $data += ($epochTime -shr 14) -band 0x7F -bor 0x80
    $data += ($epochTime -shr 21) -band 0x7F -bor 0x80
    $data += $epochTime -shr 28
    $data += (0x2A, 0x2B, 0x0E, 0x19, 0x43, 0x42, 0x01, 0x00, 0xCA, 0x14, 0x0E, 0x15, 0x00, 0xCA, 0x1E, 0x0E, 0x15, 0x00, 0xca, 0x1e, 0x0e, 0x07, 0x00, 0xCF, 0x28)

    $lo = 0xdc
    $hi = 0x4c
    If ($Enabled) {
        $lo = 0xa8
        $hi = 0x23
    }
    $data += ($lo, $hi)

    $data += (0xCA, 0x32, 0, 0xCA, 0x3C, 0, 0, 0, 0, 0)

    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.settings\windows.data.bluelightreduction.settings' -Name 'Data' -Value ([byte[]]$data) -Type Binary
}