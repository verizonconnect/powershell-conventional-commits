function Get-ConventionalCommitVersion {
    [cmdletbinding()]
    param (
        [string] $CommitAnchor = 'HEAD',
        [string] $Path = ''
    )

    $config = Get-Config -Path $Path

    $newVersion = Get-Version -CommitAnchor $CommitAnchor -Convention $config.Convention

    return $newVersion

}