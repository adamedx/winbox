# Cookbook Name:: winbox
# Recipe:: debugger
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

debugger_setup_file = ::File.join(Chef::Config[:file_cache_path], 'sdksetup.exe')

install_path = node['winbox']['debugger_install_path'].gsub(/\//, '\\')

remote_file debugger_setup_file do
  guard_interpreter :powershell_script
  source 'https://www.microsoft.com/click/services/Redirect2.ashx?CR_EAC=300135395'
  not_if "test-path '#{install_path}/debuggers/x86/ntsd.exe'"
end

powershell_script 'install debuggers' do
  code "& '#{debugger_setup_file}' /quiet /norestart /installpath '#{install_path}' /features OptionId.WindowsDesktopDebuggers"
  not_if "test-path '#{install_path}/debuggers/x86/ntsd.exe'"
end


