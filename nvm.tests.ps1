Import-Module ./nvm.psd1

Describe "Get-NodeVersions" {
    InModuleScope nvm {
        Context "Local versions" {
            It "Gets known versions" {
                Mock Get-NodeInstallLocation { 'C:\tmp\.nvm\settings.json' }
                Mock Test-Path { return $true }
                Mock Get-ChildItem {
                    $ret = @()
                    $ret += @{ Name = 'v8.9.0' }
                    $ret += @{ Name = 'v9.0.0' }
                    return $ret
                }
    
                $versions = Get-NodeVersions
                $versions.Count | Should -Be 2
                $versions | Should -Be @('v9.0.0'; 'v8.9.0')
            }
    
            It "Gets known versions with filter" {
                Mock Get-NodeInstallLocation { 'C:\tmp\.nvm\settings.json' }
                Mock Test-Path { return $true }
                Mock Get-ChildItem {
                    $ret = @()
                    $ret += @{ Name = 'v8.9.0' }
                    $ret += @{ Name = 'v9.0.0' }
                    return $ret
                }
    
                $versions = Get-NodeVersions -Filter 'v8.9.0'
                $versions | Should -Be 'v8.9.0'
    
            }
    
            It "Returns an error message when no versions are installed" {
                Mock Get-NodeInstallLocation { 'C:\tmp\.nvm\settings.json' }
                Mock Test-Path { return $false }
    
                $versions = Get-NodeVersions -Filter 'v8.9.0'
                $versions | Should -Be 'No Node.js versions have been installed'
            }
        }

        Context "Remote versions" {
            It "Will list remote versions" {
                $mockJson = "[
                    {""version"":""v9.0.0"",""date"":""2017-10-31"",""files"":[""aix-ppc64"",""headers"",""linux-arm64"",""linux-armv6l"",""linux-armv7l"",""linux-ppc64le"",""linux-x64"",""linux-x86"",""osx-x64-pkg"",""osx-x64-tar"",""src"",""sunos-x64"",""sunos-x86"",""win-x64-7z"",""win-x64-exe"",""win-x64-msi"",""win-x64-zip"",""win-x86-7z"",""win-x86-exe"",""win-x86-msi"",""win-x86-zip""],""npm"":""5.5.1"",""v8"":""6.2.414.32"",""uv"":""1.15.0"",""zlib"":""1.2.11"",""openssl"":""1.0.2l"",""modules"":""59"",""lts"":false},
                    {""version"":""v8.9.0"",""date"":""2017-10-31"",""files"":[""aix-ppc64"",""headers"",""linux-arm64"",""linux-armv6l"",""linux-armv7l"",""linux-ppc64le"",""linux-x64"",""linux-x86"",""osx-x64-pkg"",""osx-x64-tar"",""src"",""sunos-x64"",""sunos-x86"",""win-x64-7z"",""win-x64-exe"",""win-x64-msi"",""win-x64-zip"",""win-x86-7z"",""win-x86-exe"",""win-x86-msi"",""win-x86-zip""],""npm"":""5.5.1"",""v8"":""6.1.534.46"",""uv"":""1.15.0"",""zlib"":""1.2.11"",""openssl"":""1.0.2l"",""modules"":""57"",""lts"":""Carbon""},
                    {""version"":""v8.8.1"",""date"":""2017-10-25"",""files"":[""aix-ppc64"",""headers"",""linux-arm64"",""linux-armv6l"",""linux-armv7l"",""linux-ppc64le"",""linux-x64"",""linux-x86"",""osx-x64-pkg"",""osx-x64-tar"",""src"",""sunos-x64"",""sunos-x86"",""win-x64-7z"",""win-x64-exe"",""win-x64-msi"",""win-x64-zip"",""win-x86-7z"",""win-x86-exe"",""win-x86-msi"",""win-x86-zip""],""npm"":""5.4.2"",""v8"":""6.1.534.42"",""uv"":""1.15.0"",""zlib"":""1.2.11"",""openssl"":""1.0.2l"",""modules"":""57"",""lts"":false}
                ]"

                Mock Invoke-WebRequest { return $mockJson }

                $versions = Get-NodeVersions -Remote
                $versions.Count | Should -Be 3
            }

            It "Will list remote versions with filter" {
                $mockJson = "[
                    {""version"":""v9.0.0"",""date"":""2017-10-31"",""files"":[""aix-ppc64"",""headers"",""linux-arm64"",""linux-armv6l"",""linux-armv7l"",""linux-ppc64le"",""linux-x64"",""linux-x86"",""osx-x64-pkg"",""osx-x64-tar"",""src"",""sunos-x64"",""sunos-x86"",""win-x64-7z"",""win-x64-exe"",""win-x64-msi"",""win-x64-zip"",""win-x86-7z"",""win-x86-exe"",""win-x86-msi"",""win-x86-zip""],""npm"":""5.5.1"",""v8"":""6.2.414.32"",""uv"":""1.15.0"",""zlib"":""1.2.11"",""openssl"":""1.0.2l"",""modules"":""59"",""lts"":false},
                    {""version"":""v8.9.0"",""date"":""2017-10-31"",""files"":[""aix-ppc64"",""headers"",""linux-arm64"",""linux-armv6l"",""linux-armv7l"",""linux-ppc64le"",""linux-x64"",""linux-x86"",""osx-x64-pkg"",""osx-x64-tar"",""src"",""sunos-x64"",""sunos-x86"",""win-x64-7z"",""win-x64-exe"",""win-x64-msi"",""win-x64-zip"",""win-x86-7z"",""win-x86-exe"",""win-x86-msi"",""win-x86-zip""],""npm"":""5.5.1"",""v8"":""6.1.534.46"",""uv"":""1.15.0"",""zlib"":""1.2.11"",""openssl"":""1.0.2l"",""modules"":""57"",""lts"":""Carbon""},
                    {""version"":""v8.8.1"",""date"":""2017-10-25"",""files"":[""aix-ppc64"",""headers"",""linux-arm64"",""linux-armv6l"",""linux-armv7l"",""linux-ppc64le"",""linux-x64"",""linux-x86"",""osx-x64-pkg"",""osx-x64-tar"",""src"",""sunos-x64"",""sunos-x86"",""win-x64-7z"",""win-x64-exe"",""win-x64-msi"",""win-x64-zip"",""win-x86-7z"",""win-x86-exe"",""win-x86-msi"",""win-x86-zip""],""npm"":""5.4.2"",""v8"":""6.1.534.42"",""uv"":""1.15.0"",""zlib"":""1.2.11"",""openssl"":""1.0.2l"",""modules"":""57"",""lts"":false}
                ]"

                Mock Invoke-WebRequest { return $mockJson }

                $versions = Get-NodeVersions -Remote -Filter "v8"
                $versions.Count | Should -Be 2
            }
        }
    }
}

Describe "Get-NodeInstallLocation" {
    InModuleScope nvm {
        It "Should return the location when it exists" {
            Mock Test-Path { return $true }
            Mock Get-Content { return '{ "InstallPath": "c:\\tmp\\.nvm" }' }

            $location = Get-NodeInstallLocation
            $location | Should -Be 'c:\tmp\.nvm'
        }
    }
}

Describe "Install-NodeVersion" {
    InModuleScope nvm {
        Context "Installing with a specific version" {
            It "Install a requested version" {
                Install-NodeVersion -Version 'v9.0.0'
    
                $versions = Get-NodeVersions -Filter 'v9.0.0'
                $versions | Should -Be 'v9.0.0'
            }
        }

        Context "Installing with a keyword" {
            It "Installs under the `latest` flag" {
                Install-NodeVersion -Version 'latest'
    
                $versions = Get-NodeVersions
                $versions.GetType() | Should -Be [string]
            }
        }
    }

    BeforeEach {
        Set-NodeInstallLocation -Path $TestDrive
    }

    AfterEach {
        $settingsFile = Join-Path $PSScriptRoot 'settings.json'

        Write-Host $settingsFile

        if ((Test-Path $settingsFile) -eq $true) {
            Remove-Item -Force $settingsFile
        }
    }
}