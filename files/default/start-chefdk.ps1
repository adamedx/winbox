$conemulocation = "$env:programfiles\ConEmu\Conemu64.exe"
$chefdkcommand = 'chef shell-init powershell | iex'
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal] $identity
$titleprefix = ""
if($principal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    $titleprefix = "Administrator: "
}

$chefdktitle = "$($titleprefix)Chef-DK ($env:username)"

if ( test-path $conemulocation )
{
#    $conemucommand = $conemulocation + "
#    & $conemulocation "/cmd `"powershell.exe -command $chefdkcommand'`""
    start-process $conemulocation -argumentlist '/title',"`"$chefdktitle`"",'/cmd','powershell.exe','-noexit','-command',$chefdkcommand
}
else
{
    start-process powershell.exe -argumentlist '-noexit','-command',"$chefdkcommand; (get-host).ui.rawui.windowtitle = '$chefdktitle'"
}
