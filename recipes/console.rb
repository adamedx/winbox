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

powershell_script 'conemu' do
  code <<-EOH
chocolatey install conemu -y
if ($LASTEXITCODE -ne 0)
{
  $LASTEXITCODE = 0
  chocolatey install conemu -y
}
EOH
#  not_if 'get-command conemu64.exe'
  only_if '(get-wmiobject Win32_MSIResource | Where-Object -Property value -like -Value conemu) -eq $null'
end

# chocolatey 'psget'

powershell_script 'psget' do
  code 'chocolatey install psget -y'
  only_if <<-EOH
if ( $env:username -eq 'system' -or $env:username.endswith('$'))
{
  exit 1
}

(get-module -listavailable psget) -eq $null
EOH
end

