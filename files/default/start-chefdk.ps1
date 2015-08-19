$conemulocation = "$env:programfiles\ConEmu\Conemu64.exe"
$chefdkinit = 'chef shell-init powershell | iex'
$chefdkgreeting = "echo 'PowerShell $($PSVersionTable.psversion.tostring()) ($([System.Environment]::OSVersion.VersionString))';write-host -foregroundcolor darkyellow 'Ohai, welcome to ChefDK!`n'"
$chefdkcommand = "$chefdkinit;$chefdkgreeting"
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal] $identity
$titleprefix = ""
if($principal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    $titleprefix = "Administrator: "
}

$chefdktitle = "$($titleprefix)ChefDK ($env:username)"

if ( test-path $conemulocation )
{
    start-process $conemulocation -argumentlist '/title',"`"$chefdktitle`"",'/cmd','powershell.exe','-noexit','-command',$chefdkcommand
}
else
{
    start-process powershell.exe -argumentlist '-noexit','-command',"$chefdkcommand; (get-host).ui.rawui.windowtitle = '$chefdktitle'"
}
