# Cookbook Name:: winbox
# Recipe:: chefdk_shortcut
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

chefdk_exists = 'get-command chef *>&1 | out-null; $?'
chefdk_shortcut_directory = ::File.join(ENV['LOCALAPPDATA'], 'ChefDK')

directory chefdk_shortcut_directory do
  guard_interpreter :powershell_script
  recursive true
end

cookbook_file ::File.join(chefdk_shortcut_directory, 'chef-dk.ico') do
  guard_interpreter :powershell_script
  source 'chef-dk.ico'
  only_if chefdk_exists
end

cookbook_file ::File.join(ENV['USERPROFILE'], 'start-chefdk.ps1') do
  guard_interpreter :powershell_script
  source 'start-chefdk.ps1'
  only_if chefdk_exists
end

powershell_script 'Create ChefDK Start Menu Shortcut' do
  code <<-EOH
$shell = New-Object -ComObject WScript.Shell
$startmenu = [System.Environment]::GetFolderPath('StartMenu')
$chefdkdir = "#{ENV['LOCALAPPDATA']}\\ChefDK"

$shortcut = $shell.CreateShortcut("$startmenu\\ChefDK.lnk")
$shortcut.Description = 'Chef Development Kit'
$shortcut.TargetPath = 'powershell.exe'
$shortcut.Arguments = '-file "%userprofile%\\start-chefdk.ps1"'
$shortcut.WorkingDirectory = '%userprofile%'
$shortcut.IconLocation = "$chefdkdir\\chef-dk.ico"
$shortcut.Save()
EOH
  only_if <<-EOH
$startmenu = [System.Environment]::GetFolderPath('StartMenu')
if ((test-path "$startmenu\\ChefDK.lnk") -eq $true)
{
    exit 1
}
#{chefdk_exists}
EOH
end
