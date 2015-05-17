function chef-help($resource='')
{
    si env:CHEFHELP_RESOURCE_NAME $resource
    start-process 'chef-apply' -argumentlist "$psscriptroot\chef-help.rb" -wait
}

chef-help($args[0])

