function Get-LastTag {
    [cmdletbinding()]
    param (
        [string] $CommitAnchor = 'HEAD',
        [string] $MatchPattern = '*',
        [string] $ExcludePattern = ''
    )

    $returnedTag = ''

    $currentTag = Invoke-Expression "git describe --tags --match=$MatchPattern --exclude=$ExcludePattern --no-abbrev $CommitAnchor *>&1" 

    if ($LASTEXITCODE -eq 0) {
        $returnedTag = $currentTag
    }
    elseif ($LASTEXITCODE -eq 128) {
        #$currentTag now holds the error
        Write-Debug "While getting the last tag; the following error occured ""$currentTag"""
        $returnedTag = ''
    }
    else {
        throw "error while calling GIT describe"
    }

    return $returnedTag
}