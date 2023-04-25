function Get-LastTag {
    [cmdletbinding()]
    param (
        [string] $CommitAnchor = 'HEAD',
        [string] $MatchPattern = '*',
        [string] $ExcludePattern = ''
    )

    $returnedTag = ''

    $currentTag = Invoke-Expression "git describe --tags --match=$MatchPattern --exclude=$ExcludePattern --no-abbrev $CommitAnchor" 

    if ($LASTEXITCODE -eq 0) {
        $returnedTag = $currentTag
    }
    elseif ($LASTEXITCODE -eq 128) {
        $returnedTag = ''
    }
    else {
        throw "error while calling GIT describe"
    }

    return $returnedTag
}