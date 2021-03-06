#----------------------
#
# CreateTestEnv-Profile.ps1
#
# V4.1
# 25/08/2015
#
# By Diagg - www.osd-couture.com
#
#----------------------
# V1.0 15/12/2014 - Initial Release
# V2.0 16/12/2014 - Forced to AllUsersCurrentHost Profile (Will only works under admin or system account)
# V3.0 16/12/2014 - Added Logging 
# V4.0 19/12/2014 - Forced to AllUsersAllHosts Profile
# V4.1 25/08/2015 - Code change to support Powershell 2
#
#----------------------

[CmdletBinding()] 

Param( 
		[Parameter(Mandatory=$True)] 
		[string]$Action
	)

#cls

Write-Host "Creating a Powershell Profile"
Write-Host "-----------------------------"

$Error.clear()
$oProfilePath = ($profile.PsExtended.Psobject.properties|Where {$_.Name -like 'AllUsersAllHosts'}).value
#$oProfilePath = ($profile.PsExtended.Psobject.properties|Where Name -like 'CurrentUserCurrentHost').value # use for debug only (doesn't works in SCCM TS)

Write-Host ("Profile path is : " + $oProfilePath)

# Create Profile 
if ((!(Test-Path $oProfilePath)) -and ($Action -like "create"))
	{
		Write-Host "creating Profile" 
		$oProfile = New-Item -path $oProfilePath -type file –force
		add-Content $oProfile.FullName "Import-Module ZTIutility"
        if([string]::IsNullOrEmpty($Error[0]))
            {
                Write-Host "Profile Created successfully"
            }
		else
            {
                Write-warning "Error Creating Profile :"
                Write-Warning $error
            }
	}
	
# Remove Profile
if ((Test-Path $oProfilePath) -and ($Action -like "remove"))
	{
		Write-Host "Removing Profile"
		Remove-Item -path $oProfilePath –force
        if([string]::IsNullOrEmpty($Error[0]))
            {
                Write-Host "Profile Removed successfully"
            }
		else
            {
                Write-warning "Error removing Profile :"
                Write-Warning $error
            }
	}

# Finish
Write-Host "End Of Powershell Profile Script"
Write-Host "--------------------------------"