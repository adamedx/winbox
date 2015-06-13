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

# Shows help page with full help, rather than the
# abbreviated help which is the default for get-help
function get-help-full
{
    try
    {
        get-help @args -full | out-host -paging
    }
    catch [System.Management.Automation.HaltCommandException]
    {
        # Do nothing if the user chooses 'q'
    }
}

