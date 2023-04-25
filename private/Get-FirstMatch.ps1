function Get-FirstMatch {
    [cmdletbinding()]
    param (
        [string] $Subject,
        [array] $RegExArr
    )

    foreach ($regex in $RegExArr) {
        if ($Subject -Match $regex) {
            return $Matches
        }
    }

    return $false
}