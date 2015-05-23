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

# This is a script to dump information about resources. It assumes
# that the chef gem is installed.

function chef-help($resource=$null)
{
    # We're going to launch Chef, which uses, Ruby, which uses
    # mingw to provide the POSIX-like system interface that underlies
    # many implementation and interface assumptions in Ruby. Mingw
    # itself has some serious performance issues because it tries
    # to emulate some POSIX behaviors using naive approaches. In the
    # case of process startup, mingw makes a system call that
    # implicitly contacts a domain controller, which will take several
    # seconds to time out. Ruby (and thus Chef) will often take 5 or
    # more seconds to start because of this. A workaround is to set
    # the LOGONSERVER environment variable so that it points to the
    # local computer -- if it is not set, or set to an actual domain
    # controller, process start may hang. We restore this variable at
    # the end of execution.
    $oldlogonserver = $env:logonserver
    try
    {
        si env:logonserver '.'
        $arguments = @("$psscriptroot\chef-help.rb")
        if ($resource -ne $null)
        {
            $arguments += $resource
        }

        start-process 'ruby.exe' -argumentlist $arguments -wait -nonewwindow
    }
    finally
    {
        si env:logonserver $oldlogonserver
    }
}

$target_resource = $null

if ($args.length -gt 0)
{
    $target_resource = $args[0]
}

chef-help($target_resource)

