function Get-Supervisor {
    param (
        [string]$UserName
    )

    try {
        $user = Get-ADUser -Identity $UserName -Properties Manager
        if ($user.Manager) {
            $manager = Get-ADUser -Identity $user.Manager
            Write-Output "Supervisor of $UserName is: $($manager.Name)"
        } else {
            Write-Output "No supervisor found for $UserName."
        }
    } catch {
        Write-Output "Error getting supervisor: $_"
    }
}

function Get-AdGroups {
    param (
        [string]$UserName
    )

    try {
        $userGroups = Get-ADPrincipalGroupMembership -Identity $UserName
        $userGroups | ForEach-Object { Write-Output $_.Name }
    } catch {
        Write-Output "Error getting AD groups: $_"
    }
}

function IsUserBlocked {
    param (
        [string]$UserName
    )

    try {
        $user = Get-ADUser -Identity $UserName
        $isBlocked = $user.Enabled -eq $false
        Write-Output "Is $UserName blocked: $isBlocked"
    } catch {
        Write-Output "Error checking if user is blocked: $_"
    }
}

function Get-LastLogon {
    param (
        [string]$UserName
    )

    try {
        $user = Get-ADUser -Identity $UserName -Properties LastLogonTimestamp
        $readableDate = [datetime]::FromFileTime($user.LastLogonTimestamp).ToString("yyyy, MM, dd : HH:mm:ss") #Make LastLogonTimestamp readable this shits crazy dumb

        Write-Output "Last logon time of $UserName is" ":$readableDate"
    } catch {
        Write-Output "Error getting last logon time: $_"
    }
}

function OpenProject {
    # Placeholder for future implementation
    Write-Output "Function 'Open Project' is not implemented yet."
}

do {
    Write-Host "1. Get Supervisor"
    Write-Host "2. Get AD Groups"
    Write-Host "3. Is User Blocked"
    Write-Host "4. Last Logon"
    Write-Host "5. Open Project"
    Write-Host "Q. Quit"

    $choice = Read-Host "Select an option"
    $userName = $null

    switch ($choice) {
        "1" {
            $userName = Read-Host "Enter the username"
            Get-Supervisor -UserName $userName
        }
        "2" {
            $userName = Read-Host "Enter the username"
            Get-AdGroups -UserName $userName
        }
        "3" {
            $userName = Read-Host "Enter the username"
            IsUserBlocked -UserName $userName
        }
        "4" {
            $userName = Read-Host "Enter the username"
            Get-LastLogon -UserName $userName
        }
        "5" {
            OpenProject
        }
        "Q" {
            break
        }
        default {
            Write-Host "Invalid option. Please try again."
        }
    }
} while ($choice -ne "Q")

Write-Host "Script ended."
