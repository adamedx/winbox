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

if node['platform'] == "windows"
  include_recipe 'git'
  include_recipe 'winbox::chocolatey_install'
  include_recipe 'winbox::powershell_dev'
  include_recipe 'winbox::readline'
  include_recipe 'winbox::editor'
  include_recipe 'winbox::console'
end

# Fix terminal variable to avoid warnings
# when running certain git commands
env 'TERM' do
  value 'msys'
  not_if { ENV['TERM'] }
end

# Enable SSH using the ssh distributed from git
# if there is no ssh already available on the system
ruby_block 'Add ssh to current shell path' do
  action :nothing
  block do
    ENV['PATH'] += ";#{GitInformation.bin_directory.gsub(/\//, '\\')}"
  end
  only_if { ! ExecutableFinder.FindExecutableDirectory('ssh') }
end

windows_path 'Add ssh to system path' do
  path lazy { GitInformation.bin_directory.gsub(/\//, '\\') }
  action :add
  notifies :run, 'ruby_block[Add ssh to current shell path]', :immediately
  only_if do
    ! ExecutableFinder.FindExecutableDirectory('ssh') && ExecutableFinder.FindExecutableDirectory('git')
  end
end
