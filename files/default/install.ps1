#
# Copyright 2015, Adam Edwards
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

$shell = $null

function get-shell
{
    if ($shell -eq $null)
    {
        $shell = New-Object -comobject Shell.Application
    }

    $shell
}

function install-gitrepo($repo, $parent, $version = 'master')
{
    if ($parent -eq $null)
    {
        $parent = [environment]::GetFolderPath("MyDocuments")
    }

    $project = $repo -split '/' | select-object -last 1
    $dest = $parent, $project -join '\'

    write-host "Cloning $repo to $dest ..." -foregroundcolor cyan

    $zip = "$dest.zip"

    ($zip,$dest) | rm -erroraction ignore -r -force

    iwr "$repo/archive/$version.zip" -outfile $zip

    $shell = get-shell

    $files = $shell.NameSpace($zip).Items()
    $shell.NameSpace($parent).CopyHere($files, 20)
    mv "$($dest)-$version" $dest

    $dest
}

function install-chefdk($destination, $version)
{
    write-host 'Configuring ChefDK and other tools...'
    $dest = install-gitrepo https://github.com/chef/pantry-chef-repo $destination $version
    iex "& '$dest\bin\pantry.ps1' -runchef"
}

function install-devtools($destination, $version)
{
    write-host 'Configuring editor, terminal, PowerShell, etc....'

    $winbox = install-gitrepo https://github.com/adamedx/winbox $destination $version

    iex "& cd $winbox"
    rm .\berksfile.lock -erroraction ignore
    berks vendor cookbooks
    & chef-client --color -z -o winbox
    popd
}

function install-workstation($destination = $null, $winboxversion = 'master')
{
    $erroractionpreference = 'stop'

    write-host 'Configuring Windows tools for Chef Development...'

    install-chefdk $destination 'master'
    install-devtools $destination $winboxversion

    write-host "`nConfiguration has completed successfully.`n" -foregroundcolor green
    write-host "Ohai! Click the ChefDK icon on your Start menu to open"
    write-host "a ChefDK-enhanced PowerShell session, or start a new"
    write-host "PowerShell session from Explorer and then run the command:`n"
    write-host "`tchef shell-init powershell | iex`n" -foregroundcolor cyan
    write-host "to get started with Chef.`n"
}


