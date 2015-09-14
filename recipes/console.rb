# Cookbook Name:: winbox
# Recipe:: console
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

include_recipe 'winbox::chocolatey_install'

conemu_config_file = "#{ENV['ProgramW6432']}/conemu/ConEmu.xml"

cookbook_file conemu_config_file do
  action :nothing
  source 'ConEmu.xml'
end

powershell_script 'conemu' do
  code <<-EOH
chocolatey install conemu -y
if ($LASTEXITCODE -ne 0)
{
  $LASTEXITCODE = 0
  chocolatey install conemu -y
}
EOH
  only_if '(get-wmiobject Win32_MSIResource | Where-Object -Property value -like -Value conemu) -eq $null'
end

ruby_block 'check_conemu_config' do
  block {}
  not_if { ::File.exist? conemu_config_file }
  notifies :create, "cookbook_file[#{conemu_config_file}]", :immediately
end

# chocolatey 'psget'
powershell_script 'psget' do
  code 'chocolatey install psget -y'
  only_if <<-EOH
if ( ($env:username -eq 'system') -or $env:username.endswith('$') -or ($PSVersionTable.PSVersion.Major -lt 5) )
{
  exit 1
}

(get-module -listavailable psget) -eq $null
EOH
end

# install posh-git
powershell_script 'posh-git' do
  code <<-EOH
# Bootstrap provider
Get-PackageProvider -Name NuGet -ForceBootstrap

# Install post-git
Install-Module posh-git -confirm:$false -force

# Remove the un-needed example posh-git profile include
if ( test-path $PROFILE )
{
(Get-Content $PROFILE) -notmatch "posh-git" | out-file $PROFILE
}
EOH
  only_if <<-EOH
(get-module -listavailable posh-git) -eq $null -and ($PSVersionTable.PSVersion.Major -ge 5)

EOH
end
