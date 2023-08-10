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

    Write-Debug "Fetching the lastest release tag"

    $lastReleaseTag = Get-LastReleaseTag -CommitAnchor $commitAnchor

    Write-Debug "Tag returned: $lastReleaseTag"

    if ($lastReleaseTag) {
        $lastVersionMatch = $lastReleaseTag -match '(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)'

        if (-not $lastVersionMatch) {
            throw "Couldn't find the semantic version from the last release tag $lastReleaseTag"
        }

        $version = New-Object Version -ArgumentList $Matches.major, (IIf $Matches.minor $Matches.minor "0"), (IIf $Matches.patch $Matches.patch "0")

        $commitLogs = Get-CommitLogs -From $lastReleaseTag -To $CommitAnchor

        foreach ($commitLog in $commitLogs) {
            $log = Parse-CommitLog -CommitLog $commitLog -Convention $Convention

            Write-Debug $log

            $changes = Get-CommitChanges -CommitLog $log -Changes $changes -Convention $Convention
        }

        Write-Debug $($changes | Out-String)

        $version = Get-VersionBump -CurrentVersion $version -Changes $changes
    }

    return $version
}
