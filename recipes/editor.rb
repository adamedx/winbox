# Cookbook Name:: winbox
# Recipe:: editor
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

if node[:platform] == "windows"
  case node['winbox']['editor']
  when :vscode
    download_directory = "#{Chef::Config[:file_cache_path]}/winbox/vscode".gsub(/\\/, '/')
    download_path = ::File.join(download_directory, 'vscodesetup.exe')

    directory download_directory do
      recursive true
    end

    remote_file download_path do
      source 'http://download.microsoft.com/download/0/D/5/0D57186C-834B-463A-AECB-BC55A8E466AE/VSCodeSetup.exe'
    end
    execute 'install vscode' do
      command download_path
      not_if "ls '#{ENV['HOME']}/AppData/Local/Code/update.exe'"
    end
  when :emacs
    powershell_script 'install_emacs_default' do
      code 'chocolatey install emacs -y'
      not_if 'get-command emacs'
    end
  when :atom
    powershell_script 'install_atom' do
      code 'chocolatey install atom -y'
      not_if 'get-command atom'
    end
  else
    raise 'Invalid editor attribute was specified'
  end
end
