function Get-ConventionalCommitVersion {
    [cmdletbinding()]
    param (
        [string] $CommitAnchor = 'HEAD',
        [string] $ConfigPath = ''
    )

    $config = Get-Config -Path $ConfigPath

    $newVersion = Get-Version -CommitAnchor $CommitAnchor -Convention $config.Convention

    return $newVersion

}