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

editor_executable = nil

if node['platform'] == "windows"
  case node['winbox']['editor']
  when :vscode
    editor_executable = 'powershell.exe -noprofile -command start-process code -wait -argumentlist @args'
    download_directory = "#{Chef::Config[:file_cache_path]}/winbox/vscode".gsub(/\\/, '/')
    download_path = ::File.join(download_directory, 'vscodesetup.exe')

    directory download_directory do
      recursive true
    end

    remote_file download_path do
      source 'https://az764295.vo.msecnd.net/public/0.8.0/VSCodeSetup.exe'
    end

    powershell_script 'install vscode' do
      code "& '#{download_path}' /verysilent /suppressmsgboxes /norestart"
      not_if {
        vscode_evidence_value = { :name => 'URLInfoAbout', :data => 'https://code.visualstudio.com/' }
        applications_key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
        registry_get_subkeys(applications_key, :i386).find do | application |
          registry_get_values([applications_key, application].join('\\'), :i386).find do | value |
            value[:name].downcase == vscode_evidence_value[:name].downcase &&
              value[:data].downcase == vscode_evidence_value[:data].downcase
          end
        end
      }
    end

  when :emacs
    editor_executable = 'emacs.exe'
    powershell_script 'install_emacs_default' do
      code 'chocolatey install emacs -y'
      not_if 'get-command emacs *>&1 | out-null ; $?'
    end
  when :atom
    editor_executable = 'atom'
    powershell_script 'install_atom' do
      code 'chocolatey install atom -y'
      not_if 'get-command atom *>&1 | out-null ; $?'
    end
  when :vim
    editor_executable = 'vim'
    powershell_script 'install_vim' do
      code 'chocolatey install vim -y'
      not_if 'get-command vim *>&1 | out-null ; $?'
    end
  else
    raise 'Invalid editor attribute was specified'
  end
end

env 'EDITOR' do
  value editor_executable
  not_if { ENV['EDITOR'] }
end
