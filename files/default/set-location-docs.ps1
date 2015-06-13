# Documents directory shortcut
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

# Set the current directory to the location of the
# Documents directory, and also set up an environment
# variables called DOCS.
function set-location-docs
{

    if ($env:DOCS -eq $null)
    {
        $myDocsPath = [environment]::GetFolderPath("MyDocuments")
        $env:DOCS = $myDocsPath
    }

    pushd $env:DOCS
}
