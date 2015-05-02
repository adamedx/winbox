# Cookbook Name:: winbox
# Recipe:: default
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

if node[:platform] == "windows"
  include_recipe 'git'
  include_recipe 'winbox::chocolatey_install'
  include_recipe 'winbox::powershell_dev'
  include_recipe 'winbox::readline'
  include_recipe 'winbox::editor'
  include_recipe 'winbox::console'
end

# Enable SSH using the ssh distributed from git
git_exe_path ||= (`powershell -nologo -noninteractive -noprofile -command "(get-command git | select-object -property path).path"`).chomp
git_path_components = git_exe_path.chomp.gsub(/\\/,'/').split('/')
git_exe_bin_path = nil
if git_path_components && git_path_components.length > 4
  git_exe_bin_path = git_path_components[0..git_path_components.length-3].join(File::ALT_SEPARATOR)
end

ruby_block 'Add ssh path from git' do
  block do
    ENV['PATH'] += ";#{get_exe_bin_path}"
  end
  action :nothing
end

windows_path git_exe_bin_path do
  action :add
  notifies :create, 'ruby_block[Add ssh path from git]', :immediately
  only_if { ! git_exe_bin_path.nil? }
end
