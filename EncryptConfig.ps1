Set-ExecutionPolicy Unrestricted

<#
.NOTES
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│ ORIGIN STORY                                                                                │
├─────────────────────────────────────────────────────────────────────────────────────────────┤
│   DATE        : 09/02/2019
│   AUTHOR      : Matthew Brumpton
│   DESCRIPTION : Encrypt Web.config Using aspnet_regiis.exe using the RSA provider
|   Version     : 0.1
└─────────────────────────────────────────────────────────────────────────────────────────────┘
#>
    
<# Set IIS variables #>

$aspnet_regiis = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\aspnet_regiis.exe"
$container = "NetFrameworkConfigurationKey"
$id = "NT AUTHORITY\NETWORK SERVICE"

<# Get current directoy #>

$invocation = (Get-Variable MyInvocation).Value
$path= Split-Path $invocation.MyCommand.Path

<# Generate RSA key #>

$key = $path+"/key.xml"
& ("$aspnet_regiis") -px $container $key -pri

<# Set web,config sections to encrypt #>

$sections = @(
    "connectionStrings",
    "appSettings"
)

<# Encrypt web,config  #>

Foreach ($section in $sections) {
    & ("$aspnet_regiis") -pef $section $path
}

<# Remove RSA key file  #>

Remove-Item $key