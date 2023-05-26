$LOG_COMMIT_DELIMITER = '===LOG_COMMIT_DELIMITER==='
$LOG_FIELD_SEPARATOR = '===LOG_FIELD_SEPARATOR==='

function Get-CommitLogs {
    [cmdletbinding()]
    param (
        [string] $From,
        [string] $To

    )

    Write-Debug "Get-CommitLogs; from $From to: $To"

    $gitLogFormat = (@("%H", "%aI", "%s", "%b") -join ($LOG_FIELD_SEPARATOR)) + $LOG_COMMIT_DELIMITER;

    $gitLog = Invoke-Expression "git log --reverse --format=$gitLogFormat $($From)..$($To)"

    $gitLog = $gitLog -join "`r`n"

    Write-Debug $gitLog

    $commitDetails = $gitLog -split $LOG_COMMIT_DELIMITER

    [array] $returnCommits = @()

    foreach ($commitRow in $commitDetails) {
        $commitArray = $commitRow -split $LOG_FIELD_SEPARATOR

        $commit = @{
            "Hash"    = $($commitArray[0]).replace("`r`n", '')
            "Date"    = $commitArray[1]
            "Subject" = $commitArray[2]
            "Body"    = $commitArray[3]
        }

        Write-Debug $commit

        if ($($commitArray[0]).replace("`r`n", '') -ne "") {
            $returnCommits += $commit
        }
    }

    return $returnCommits
}
