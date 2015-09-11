# Cookbook Name:: winbox
# Recipe:: powershell_dev
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

powershell_script 'ExecutionPolicyUnrestricted' do
  code <<-EOH
powershell -noprofile -executionpolicy bypass -command {set-executionpolicy unrestricted -force -scope localmachine}
exit 0
EOH
  only_if "(get-executionpolicy -scope localmachine) -ne 'unrestricted'"
end

powershell_script 'ExecutionPolicyUnrestrictedX86' do
  architecture :i386  # Handle 32-bit Powershell (no-op if OS is 32-bit)
  code <<-EOH
powershell -noprofile -executionpolicy bypass -command {set-executionpolicy unrestricted -force -scope localmachine}
exit 0
EOH
  only_if "(get-executionpolicy -scope localmachine) -ne 'unrestricted'"
end

cookbook_file "#{ENV['USERPROFILE']}/winbox-ps-profile.ps1" do
  source 'winbox-ps-profile.ps1'
  action :create_if_missing
end

cookbook_file "#{ENV['USERPROFILE']}/get-help-full.ps1" do
  source 'get-help-full.ps1'
end

cookbook_file "#{ENV['USERPROFILE']}/set-location-docs.ps1" do
  source 'set-location-docs.ps1'
end

profile ||= Proc.new do
  cmdlet = Chef::Util::Powershell::Cmdlet.new(node, '$PROFILE')
  cmdlet.run.return_value.chomp
end.call

directory ::File.split(profile.gsub(/\\/, '/'))[0] do
  recursive true
end

# Use powershell_script instead of file to create this file
# because the file resource can't handle remote profile
# paths (i.e. UNC paths) as a destination
powershell_script profile do
  code "'. ~/winbox-ps-profile.ps1' > '#{profile}'"
  not_if "test-path '#{profile}'"
end

