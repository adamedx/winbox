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

include_recipe 'winbox::console'

# Enable SSH using the ssh distributed from git
windows_path "#{ENV['PROGRAMFILES']}\\Git\\Cmd" do
  action :remove
end

windows_path "#{ENV['PROGRAMFILES']}\\Git\\bin" do
  action :add  
end

powershell_script 'Install Posh-Git' do
  code <<-EOH
import-module "$env:programfiles/common files/modules/psget" -force
psget\\install-module posh-git
  EOH
  only_if <<-EOH
if ( $env:username -eq 'system' -or $env:username.endswith('$'))
{
  exit 1
}

(get-module -listavailable posh-git) -eq $null
EOH
end