#Winget cannot run as a system user. This script will check for a winget install and update winget if it's on an older version that is not functioning(1.0 with OEM windows installs)
#You can add commands at the bottom with .\Winget [Command]

#WebClient
$dc = New-Object net.webclient
$dc.UseDefaultCredentials = $true
$dc.Headers.Add("user-agent", "Inter Explorer")
$dc.Headers.Add("X-FORMS_BASED_AUTH_ACCEPTED", "f")

#temp folder
$InstallerFolder = $(Join-Path $env:ProgramData CustomScripts)
if (!(Test-Path $InstallerFolder)) { New-Item -Path $InstallerFolder -ItemType Directory -Force -Confirm:$false }
	#Check Winget Install
	Write-Host "Checking if Winget is installed and up to date" -ForegroundColor Yellow

	$Version = 1.19
	$Versionobj = [version]$Version
	$WingetVersion = (Get-AppxPackage -Name Microsoft.DesktopAppInstaller -alluser).Version
	if($WingetVersion -gt $Versionobj) { $WingetUpToDate = $True } Else { $WingetUpToDate = $False }

	$TestWinget = Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq "Microsoft.DesktopAppInstaller"}
	If ($TestWinGet -and $WingetUpToDate) 
	{
		Write-Host "WinGet is Installed and up to date" -ForegroundColor Green
	} Else {
		#Download WinGet MSIXBundle
		Write-Host "Not installed or not up to date. Downloading WinGet..." 
		$WinGetURL = "https://aka.ms/getwinget"
		$dc.DownloadFile($WinGetURL, "$InstallerFolder\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle")
		
		#Install WinGet MSIXBundle 
		Try 	{
			Write-Host "Installing MSIXBundle for App Installer..." 
			Add-AppxProvisionedPackage -Online -PackagePath "$InstallerFolder\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -SkipLicense 
			Write-Host "Installed MSIXBundle for App Installer" -ForegroundColor Green
			}
		Catch {
			Write-Host "Failed to install MSIXBundle for App Installer..." -ForegroundColor Red
			} 
	
		#Remove WinGet MSIXBundle 
		Remove-Item -Path "$InstallerFolder\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -Force -ErrorAction Continue
		}

        $ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
        if ($ResolveWingetPath){
               $WingetPath = $ResolveWingetPath[-1].Path
        }
    
    $config
    #At this point you can call winget by using .\Winget Commands
    
 
    
