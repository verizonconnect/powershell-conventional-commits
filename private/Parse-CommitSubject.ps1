function Parse-CommitSubject {
    [cmdletbinding()]
    param (
        [hashtable] $CommitLog,
        [PSCustomObject] $Convention
    )

    $conventialSubject = @{
        "ConventionType" = ""
        "Scope"          = ""
        "Breaking"       = $false
        "Description"    = ""
    }
    
    $subjectMatch = $CommitLog.Subject -match '^(?<type>\w+)(?:\((?<scope>[^()]+)\))?(?<breaking>!)?:\s*(?<description>.+)'

    if ($subjectMatch) {
        $conventialSubject.ConventionType = $Matches.type
        $conventialSubject.Scope = (IIf $Matches.scope = '' 'undefined' $Matches.scope)
        $conventialSubject.Breaking = $Matches.breaking -eq '!'
        $conventialSubject.Description = $Matches.description
    }
    else {
        $mergeMatches = Get-FirstMatch -Subject $CommitLog.Subject -RegExArr @('^Merge (?<description>.+)', '^Merged in (?<description>.+)')
        if ($mergeMatches) {
            $conventialSubject.ConventionType = 'merge'
            $conventialSubject.Description = $mergeMatches.description      
        }
        else {
            Write-Debug "Invalid commit subject format. Hash: $($CommitLog.Hash)"
        }
    }

    if (-not($Convention.commitTypes.Contains($conventialSubject.ConventionType))) {
        Write-Debug "Unknown commit type ""$($conventialSubject.ConventionType)"""
    }

    Write-Debug $conventialSubject 

    return $conventialSubject 

}