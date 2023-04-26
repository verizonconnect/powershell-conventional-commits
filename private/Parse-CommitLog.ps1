function Parse-CommitLog {
    [cmdletbinding()]
    param (
        [hashtable] $CommitLog,
        [PSCustomObject] $Convention
    )

    $ConventionalCommit = @{
        "ConventionalSubject" = ""
        "BreakingChanges"     = ""
    }

    $subject = Parse-CommitSubject -Commit $CommitLog -Convention $Convention

    $ConventionalCommit.ConventionalSubject = $subject

    if ($CommitLog.Body -match '^BREAKING CHANGES?: *') {
        $ConventionalCommit.BreakingChanges = $subject.Description
    }
    
    return $ConventionalCommit
}