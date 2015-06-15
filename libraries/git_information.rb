# Cookbook Name:: winbox
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

require_relative 'executable_finder'

class GitInformation
  def self.bin_directory
    git_exe_directory = ExecutableFinder.FindExecutableDirectory('git')
    ::File.join(::File.split(git_exe_directory)[0], 'bin')
  end
end
