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
        if ($currentTag -Like "*dubious ownership*") {

            Write-Debug "Error caught dubious ownership, adding this path to the safe.directory."

            Invoke-Expression "git config --global --add safe.directory $PWD"

            $currentTag = Invoke-Expression "git describe --tags --match=$MatchPattern --exclude=$ExcludePattern --no-abbrev $CommitAnchor *>&1" 

            if ($LASTEXITCODE -eq 0) {
                $returnedTag = $currentTag
            }
            else {
                Write-Debug "While getting the last tag; the following error occured ""$currentTag"""
                $returnedTag = ''
            }
        }
        else {
            Write-Debug "While getting the last tag; the following error occured ""$currentTag"""
            $returnedTag = ''
        }
    }
    else {
        throw "error while calling GIT describe"
    }

    return $returnedTag
}