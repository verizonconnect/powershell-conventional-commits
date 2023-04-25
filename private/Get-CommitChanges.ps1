
function Get-CommitChanges {
    [cmdletbinding()]
    param (
        [hashtable] $CommitLog,
        [hashtable] $Changes,
        [PSCustomObject] $Convention
    ) 

    if (($CommitLog.BreakingChanges) -or ($CommitLog.ConventionalSubject.Breaking)) {
        $Changes.Breaking ++
    }
    elseif ($Convention.featureCommitTypes.Contains($CommitLog.ConventionalSubject.ConventionType)) {
        $Changes.Feature ++
    }
    elseif (($Convention.commitTypes.Contains($log.ConventionalSubject.ConventionType)) -or ($Convention.commitTypes.ignoreNonConventionCommits -eq $false)) {
        $Changes.Patches ++
    }
    else {
        Write-Debug "This commit wasn't included in calculating the version."
    }

    return $Changes
}