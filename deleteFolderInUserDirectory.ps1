##### this deletes a folder in all user directories ######

$paths = "\\userpath1\users", "\\userpath2\users", "\\userpath3\users", "\\userpath4\users", "\userpath4\users"

foreach ($path in $paths)
{
    $subFolders = Get-ChildItem $path -name #get path and return only the name
    foreach ($name in $subFolders)
    {
        $fullPath = $path + "\" + $name + "\Chrome\Profile" # this is the path it deletes, this can be changed to any path in users home directory
        Remove-Item $fullPath
        Write-Output "Deleted folder for user: $name"
    }
}