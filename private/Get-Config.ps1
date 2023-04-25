function Get-Config {
    [cmdletbinding()]
    param (
        [string] $Path = ''
    ) 

    [PSCustomObject] $jsonFile

    if ([string]::IsNullOrEmpty($Path)) {
        $Path = Join-Path -Path $PSScriptRoot -ChildPath 'conventional-commit-default.json'
    }

    if (Test-Path -Path $Path) {
        $jsonFile = Get-Content -Raw $Path | ConvertFrom-Json
    }
    else {
        $jsonFile = "{convention:{}}" | ConvertFrom-Json
        Write-Debug 'Path to "conventional-commit.json" not valid.'
    }

    #Defaults
    if (-not($jsonFile.convention)) {
        $jsonFile | Add-Member -Name 'convention' -Type MemberSet
    }
    
    if (-not($jsonFile.convention.commitTypes)) {
        $jsonFile.convention | Add-Member -Name 'commitTypes' -Type NoteProperty -Value @("feat", "fix", "perf", "refactor", "style", "test", "build", "ops", "docs", "merge", "chore", "ci")
    }

    if (-not($jsonFile.convention.featureCommitTypes)) {
        $jsonFile.convention | Add-Member -Name 'featureCommitTypes' -Type NoteProperty -Value @('feat')
    }

    if (-not($jsonFile.convention.ignoreNonConventionCommits)) {
        $jsonFile.convention | Add-Member -Name 'ignoreNonConventionCommits' -Type NoteProperty -Value "False"
    }

    return $jsonFile
}