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

    echo "Installing $repo to $dest"

    $zip = "$dest.zip"

    ($zip,$dest) | rm -erroraction ignore -r -force

    iwr "$repo/archive/$version.zip" -outfile $zip;

    $shell = get-shell

    $files = $shell.NameSpace($zip).Items()
    $shell.NameSpace($parent).CopyHere($files, 20)
    mv "$($dest)-$version" $dest

    $dest
}

function install-chefdk($destination, $version)
{
    $dest = install-gitrepo https://github.com/chef/pantry-chef-repo $version $destination
    iex "$dest\bin\pantry.ps1 -runchef"
}

function install-devtools($destination, $version)
{
    $winbox = install-gitrepo https://github.com/adamedx/winbox $version $destination

    cd $winbox
    rm .\berksfile.lock -erroraction ignore
    berks vendor cookbooks
    & chef-client --color -z -o winbox
    popd
}

function install-workstation($destination = $null, $winboxversion = 'master')
{
    $erroractionpreference = 'stop'

    install-chefdk $destination
    install-devtools $destination, $winboxversion
}

