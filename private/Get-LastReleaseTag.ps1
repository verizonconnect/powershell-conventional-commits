function Get-LastReleaseTag {
    [cmdletbinding()]
    param (
        [string] $CommitAnchor = 'HEAD'
    )
    return Get-LastTag -CommitAnchor $CommitAnchor -excludePattern '*-*'
}