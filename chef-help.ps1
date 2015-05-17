function chef-help($resource='')
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
    si env:CHEFHELP_RESOURCE_NAME $resource
    $oldlogonserver = $env:logonserver
    try
    {
        si env:logonserver "\\$env:computername"
        start-process 'chef-apply' -argumentlist "$psscriptroot\chef-help.rb" -wait
    }
    finally
    {
        si env:logonserver $oldlogonserver
    }
}

chef-help($args[0])

