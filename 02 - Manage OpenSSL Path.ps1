##  Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment

Function global:ADD-PATH()
{
    [Cmdletbinding()]
    param
    (
    [parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    Position=0)]
    [String[]]$AddedFolder
    )

    # Get the current search path from the environment keys in the registry.

    $currentPath=(Get-ItemProperty -Path ‘Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment’ -Name PATH).Path

    # See if a new folder has been supplied.

    IF (!$AddedFolder)
    { Return ‘No Folder Supplied. $ENV:PATH Unchanged’}

    # See if the new folder exists on the file system.

    IF (!(TEST-PATH $AddedFolder))
    { Return ‘Folder Does not Exist, Cannot be added to $ENV:PATH’ }

    # See if the new Folder is already in the path.

    $SearchStr = $AddedFolder -replace "\\","\\"
    IF ($currentPath -match $SearchStr)
    { Return ‘Folder already within $ENV:PATH’ }

    # Set the New Path

    $NewPath=$currentPath +’;’ + $AddedFolder

    Set-ItemProperty -Path ‘Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment’ -Name PATH –Value $newPath

    # Show our results back to the world

    Return $NewPath
}

FUNCTION GLOBAL:GET-PATH() 
{
    $currentPath=(Get-ItemProperty -Path ‘Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment’ -Name PATH).Path
    Return $currentPath
} 

Function global:REMOVE-PATH()
{
    [Cmdletbinding()]
    param
    (
    [parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    Position=0)]
    [String[]]$RemovedFolder
    )
    
    # Escape backslach charcaters in path strings and add ';s separator
    $RemovedFolder = ";"+ $RemovedFolder -replace "\\","\\"

    # Get the Current Search Path from the environment keys in the registry

    $CurrentPath=(Get-ItemProperty -Path ‘Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment’ -Name PATH).Path

    # See if the new folder exists on the file system.

    IF (!($CurrentPath -match $RemovedFolder))
    { Return ‘Folder Does not Exist in current path, Cannot remove from $ENV:PATH’ }
    
    # Find the value to remove, replace it with $NULL. If it’s not found, nothing will change.

    $NewPath=$CurrentPath –replace $RemovedFolder,$NULL

    # Update the Environment Path

    Set-ItemProperty -Path ‘Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment’ -Name PATH –Value $newPath

    # Show what we just did

    Return $NewPath

}

Write-host ("Current Path")
Write-Host ("---------------")
GET-PATH

Write-Host
Write-Host ("Adding new folder to path")ADD-PATH -AddedFolder 'C:\Program Files\OpenSSL-Win64\bin'


#Write-Host
#Write-Host ("Remove folder from path")
#REMOVE-PATH -RemovedFolder 'C:\Program Files\OpenSSL-Win64\bin'

