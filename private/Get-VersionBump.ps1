function Get-VersionBump {
    [cmdletbinding()]
    param (
        [version] $CurrentVersion,
        [hashtable] $Changes
    )

    [version] $newVersion = $CurrentVersion

    # Don't change major when in development mode
    if ($currentVersion.Major -eq 0) {
        if (($Changes.Breaking -gt 0) -or ($Changes.Feature -gt 0)) {
            $newVersion = New-Object Version -ArgumentList 0, $(($CurrentVersion.Minor) + 1), 0
        }
        elseif ($Changes.Patches -gt 0) {
            $newVersion = New-Object Version -ArgumentList 0, $CurrentVersion.Minor, $(($CurrentVersion.Build) + 1)
        }        
    }

    if ($Changes.Breaking -gt 0) {
        $newVersion = New-Object Version -ArgumentList $(($CurrentVersion.Major) + 1), 0, 0
    }
    elseif ($Changes.Feature -gt 0) {
        $newVersion = New-Object Version -ArgumentList $CurrentVersion.Major, $(($CurrentVersion.Minor) + 1), 0
    }
    elseif ($Changes.Patches -gt 0) {
        $newVersion = New-Object Version -ArgumentList $CurrentVersion.Major, $CurrentVersion.Minor, $(($CurrentVersion.Build) + 1)
    }
    else {
        Write-Debug "No change was made to version!"
    }

    return $newVersion
}