# Copyright © 2023 Fleetmatics IRL Limited. All rights reserved.

#Get public and private function definition files.
$Public = Get-ChildItem -Path $PSScriptRoot/public/*.ps1 -Recurse -ErrorAction SilentlyContinue
$Private = Get-ChildItem -Path $PSScriptRoot/private/*.ps1 -Recurse -ErrorAction SilentlyContinue

#Dot source the files
foreach ( $Import in $Public ) {
    try {
        . $Import.FullName
    }
    Catch {
        Write-Error -Message "Failed to import function $($Import.FullName): $_"
    }
}

foreach ( $Import in $Private ) {
    try {
        . $Import.FullName
    }
    Catch {
        Write-Error -Message "Failed to import function $($Import.FullName): $_"
    }
}
# Export only the functions in the Public folder.
Export-ModuleMember -Function $Public.Basename
