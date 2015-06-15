# Cookbook Name:: winbox
# Recipe:: chocolatey_install
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

# This recipe works around defects in the chocolatey cookbook,
# located at (https://github.com/chocolatey/chocolatey-cookbook).
# If those bugs are addressed, the chocolatey cookbook can be used
# intsead of this one to configure chocolatey on a system.

chocolatey_path = "#{ENV['SYSTEMDRIVE']}\\ProgramData\\chocolatey\\bin"

windows_path 'update_path_for_system' do
  action :add
  path chocolatey_path
end

ruby_block 'add_chocolatey_path' do
  block do
    new_path = "#{ENV['PATH']};#{chocolatey_path}"
    ENV['PATH'] = "#{ENV['PATH']};#{new_path}"
  end

  not_if {
    (ENV['PATH'].split(';').collect { | element | element.downcase }).include? chocolatey_path.downcase
  }
end

powershell_script 'chocolatey_install' do
  code <<-EOH
powershell -noprofile -inputformat none -noninteractive -executionpolicy bypass -command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))"
EOH
 #  not_if { ChocolateyHelpers::chocolatey_installed? }
  not_if "test-path '#{chocolatey_path}\\choco.exe'"
end




