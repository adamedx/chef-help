# chef-help

[chef-help](https://github.com/adamedx/chef-help) displays basic information about
[Chef](https://github.com/chef/chef) resources. It keeps you in your
editor / command shell workflow by replacing common scenarios where
you might otherwise launch a web browser to visit
http://docs.chef.io/search.html for Chef resource documentation.

## Applicability
`chef-help` is most useful in the following situations:

* On a [Chef-DK](https://github.com/chef/chef-dk)-enabled workstation
when authoring Chef recipes
* Scenarios involving debugging of systems running `chef-client`

## Prerequisites

`chef-help` requires either of the following prerequisites to be installed:

* [Chef-DK](https://github.com/chef/chef-dk)
* [Chef](https://github.com/chef/chef)

## Installation

To install `chef-help`, clone this repository into some directory on a
system that meets the prerequisites:

```sh
git clone https://github.com/adamedx/chef-help
```

To make it easier to use `chef-help`, create a `chef-help` alias in your
command shell to one of the `chef-help` scripts below at the root of your cloned
repository:

* `chef-help` on non-Windows systems
* `chef-help.ps1` on Windows systems

Alternatively, you can *source* the appropriate script in your shell
profile, reference the script via a symbolic link from one of the
directories listed in the `$PATH` environment variable, or update
`$PATH` to include the directory into which this repository was cloned.

## Usage

To obtain information about resources built into
[Chef](https://github.com/chef/chef), execute the command with the
short name of a resource. For example, for the `group` resource the
following command can be executed

```sh
chef-help group
```

This will return the following output:

```
* Resource: group
  - Chef Version: 12.3.0
  + Attributes:
    - append FalseClass
    - excluded_members Array
    - gid
    - group_name String
    - members Array
    - non_unique FalseClass
    - system
    - users Array
  + Actions:
    - create
    - manage
    - modify
    - nothing
    - remove
```
## Limitations

`chef-help` has the following constraints:

* `chef-help` can only show information about resources that are defined
  by `chef-client` itself -- `chef-help` will **not** show resources
  that are defined in cookbooks or gems.
* Currently `chef-help` can retrieve only limited type information for
  attributes, mostly because Chef does not require resources to
  declare type information for attributes. `chef-help` will only
  display type information if the resources provides a non-`nil` default value
  for the attribute, and that still does not cover cases where the
  resource allows an attribute to have values of more than one type.
* `chef-help` can only show information about types in the version of
  `chef-client` being used on your system. If you're authoring recipes
  for a versio of `chef-client` that is different than the one
  installed on the system where you are using `chef-help`, you should
  use the same versions of `chef-client` everywhere for consistency,
  or use a separate system that has the same version of `chef-client`
  as the target system.
* Currently the tool uses `chef-apply` to execute recipe code, which
  shows some extraneous logging output that is normal for `chef-apply`
  invocations. Removing the unneeded text would improve readability of
  the output.

# TODO -- what's next?

This implementation is a proof-of-concept. A more useful
implementation might include the following:

* Re-packaging this tool as a gem, `knife` plugin, or subcommand in
  Chef-DK's `chef` command would make it easier to acquire and install
  this tool.
* The tool has no tests -- this could be easier if the tool were
  repackaged in a gem or Chef extension as suggested above.
* Additional features to display the operating systems on which th
  resource is available along with any other prerequisits would reduce the need to visit the web site.
  This can be done by takking advantage of provider mapping
  information in recent versions of Chef.
* With changes to `chef-client`, full type information about attributes could
  be required for resources and thus exposed by the tool
* Support for cookbooks available to a node or specified in an
  argument could allow the tool to support resources defined in
  cookbooks.
* Other changes to `chef-client` could allow for integrated help to be
  associated with resources and therefore exposed by the tool.

License and Authors
-------------------
Copyright:: Copyright (c) 2015 Adam Edwards (adamedx)

License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

