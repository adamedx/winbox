# Cookbook Name:: winbox
# Recipe:: readline
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

zip_file = "#{Chef::Config[:file_cache_path]}/psreadline.zip".gsub(/\//, '\\')
module_destination_ps_path = '$PROFILE\\..\\modules'

remote_file zip_file do
  guard_interpreter :powershell_script
  source 'https://github.com/lzybkr/PSReadLine/releases/download/Latest/PSReadline.zip'
  not_if '([System.Environment]::OSVersion.Version.Major -ge 10) -and ((get-module psreadline -listavailable) -ne $null)'
end

powershell_script 'install_module' do
  code <<-EOH
$Source = '#{zip_file}'
$profiledestination = "$PROFILE" -split '\\\\'
$destination = $profiledestination[0..($profiledestination.length - 2)] -join '\\'
$destination = $destination + '\\modules\\psreadline'

try
{
  # use this in PowerShell v3 to unblock downloaded data
  # remove this in PowerShell v2 and unblock manually if needed
  # Unblock-File $Destination
  Unblock-File $Source
}
catch
{
}
mkdir -force "$destination"
$helper = New-Object -ComObject Shell.Application
$files = $helper.NameSpace($Source).Items()
$result = $helper.NameSpace($Destination).CopyHere($files, 20)
EOH
  not_if <<-EOH
if ( $env:username -eq 'system' -or $env:username.endswith('$'))
{
  exit 0
}

if ($PROFILE -eq $null -or $PROFILE.length -le 3)
{
  exit 0
}

if (([System.Environment]::OSVersion.Version.Major -ge 10) -and ((get-module psreadline -listavailable) -ne $null))
{
  exit 0
}

$profiledestination = "$PROFILE" -split '\\\\'
$destination = $profiledestination[0..($profiledestination.length - 2)] -join '\\'
$destination = $destination + '\\modules\\psreadline\\psreadline.psm1'
test-path $destination
EOH
end

