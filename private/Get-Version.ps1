function Get-Version {
    [cmdletbinding()]
    param (
        [string] $CommitAnchor = 'HEAD',
        [PSCustomObject] $Convention
    )

    [version] $version = New-Object Version -ArgumentList 0, 0, 1

    $changes = @{
        "Breaking" = 0
        "Feature"  = 0
        "Patches"  = 0
    }

    Write-Host "Fetching the lastest release tag"

    $lastReleaseTag = Get-LastReleaseTag -CommitAnchor $commitAnchor

    Write-Host "Tag returned: $lastReleaseTag"

    if ($lastReleaseTag) {
        $lastVersionMatch = $lastReleaseTag -match '(?<major>\d+)\.(?<minor>\d+)(\.(?<patch>\d+))?'

        if (-not $lastVersionMatch) {
            throw "Couldn't find the semantic version from the last release tag $lastReleaseTag"
        }

        $version = New-Object Version -ArgumentList $Matches.major, $Matches.minor, $Matches.patch

        $commitLogs = Get-CommitLogs -From $lastReleaseTag -To $CommitAnchor

        Write-Host "Getting commit information, $($commitLogs.count) commits found between tag ""$lastReleaseTag"" and ""$CommitAnchor""."

        foreach ($commitLog in $commitLogs) {
            $log = Parse-CommitLog -CommitLog $commitLog -Convention $Convention

            Write-Host $log

            $changes = Get-CommitChanges -CommitLog $log -Changes $changes -Convention $Convention
        }

        Write-Host "Changes detected:"
        Write-Host $($changes | Out-String)

        $version = Get-VersionBump -CurrentVersion $version -Changes $changes

        Write-Host "New version: $version"
    }

    return $version
}
