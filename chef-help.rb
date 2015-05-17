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

# This is a script to dump information about resources. It requires
# that it is executed in Chef recipe context, specifically the context
# of passing a file to chef-apply to execute as a recipe.

module ::ChefHelp
  require 'highline'

  # We look for arguments via environment variable since chef-apply
  # gets the arguments and we can't add our own there
  def self.target_resource
    ENV['RESOURCE_NAME']
  end

  if target_resource.nil? || target_resource.length <= 0
    puts "\nUsage: \n"
    puts "\tchef-help <chef resource name>"
    puts
    puts "\tchef-help outputs the names of the attributes for the specified\n"
    puts "\tChef resource, along with (limited) type information if available."
    puts
    puts "\tDetailed information on Chef resources may be found at http://docs.chef.io/search.html."
    puts
    exit 1
  end

  def self.resource_display
    colorizer = HighLine.new
    puts "\n* Resource: #{colorizer.color(self.target_resource, :green)}"

    Proc.new do
      action :nothing

      puts "  + Attributes:"

      (self.methods - ::Chef::Resource.instance_methods).sort.each do | attribute |
        if (attribute.to_s =~ /\?|\=/).nil?
          # Catch exceptions to handle methods that aren't attributes
          # and require extra arguments
          begin
            attribute_type = self.send(attribute).class
            attribute_type_name = attribute_type != NilClass ? attribute_type.to_s : ''
            puts "    - #{colorizer.color(attribute.to_s, :cyan)} #{attribute_type_name}"
          rescue
          end
        end
      end

      puts "  + Actions:"

      allowed_actions.sort.each do | action |
        puts "    - #{colorizer.color(action.to_s, :yellow)}"
      end
    end
  end
end

self.send(::ChefHelp.target_resource, 'resource_help', &(::ChefHelp.resource_display))
puts
