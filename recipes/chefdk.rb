# Cookbook Name:: winbox
# Recipe:: chefdk
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

chefdk_setup_file = ::File.join(Chef::Config[:file_cache_path], 'chefdk.msi')

remote_file chefdk_setup_file do
  guard_interpreter :powershell_script
  source 'https://www.chef.io/chef/download-chefdk?p=windows&pv=2008r2&m=x86_64&v=latest'
  not_if 'get-command chef *>&1 | out-null; $?'
end

package chefdk_setup_file do
  timeout 1200
  not_if 'get-command chef *>&1 | out-null; $?'
end

include_recipe 'winbox::chefdk_shortcut'
