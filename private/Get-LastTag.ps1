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
        $errorCaught = $Error[0].Exception.Message
        Write-Debug "While getting the last tag; the following error occured ""$errorCaught"""
        $returnedTag = ''
    }
    else {
        throw "error while calling GIT describe"
    }

    return $returnedTag
}