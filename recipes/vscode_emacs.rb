# Cookbook Name:: winbox
# Recipe: vscode_emacs
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

vscode_settings_directory = "#{ENV['APPDATA']}/Code/User"

directory vscode_settings_directory do
  recursive true
end 

vscode_keybindings_file = "#{vscode_settings_directory}/keybindings.json"

file "#{vscode_keybindings_file}.bak" do
  content ::File.exist?(vscode_keybindings_file) ? lazy { IO.read(vscode_keybindings_file) } : ''
  action :create_if_missing
  notifies :create, "cookbook_file[#{vscode_keybindings_file}]", :immediately
end

cookbook_file vscode_keybindings_file do
  action :nothing
  source 'vscode-keybindings.json'
end

vscode_user_settings_file = "#{vscode_settings_directory}/settings.json"

file "#{vscode_user_settings_file}.bak" do
  content ::File.exist?(vscode_user_settings_file) ? lazy { IO.read(vscode_user_settings_file) } : ''
  action :create_if_missing
  notifies :create, "cookbook_file[#{vscode_user_settings_file}]", :immediately
end

cookbook_file vscode_user_settings_file do
  action :nothing
  source 'vscode-settings.json'
end


