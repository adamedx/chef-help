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

require 'chef'
require 'highline'

class ChefHelp
  def self.show_usage
    puts "\nUsage: \n"
    puts "\tchef-help <chef resource name>"
    puts
    puts "\tchef-help outputs the names of the properties (formerly known as attributes)"
    puts "\tand actions for the specified Chef resource, along with (limited) type information"
    puts "\tif available."
    puts
    puts "\tDetailed information on Chef resources may be found at https://docs.chef.io/search.html."
    puts
  end

  def self.for_command_argument
    target_resource = (ARGV[0] != nil && ARGV[0].length > 0) ? ARGV[0] : nil

    if ! target_resource || target_resource.length <= 0
      show_usage
      exit 1
    end

    begin
      help = ChefHelp.new(target_resource)
      help.show
    rescue
      exit 1
    end
  end

  def initialize(target_resource)
    @target_resource = target_resource
    @colorizer = HighLine.new

    resource_class = ::Chef::Resource.resource_matching_short_name(@target_resource)

    if resource_class
      empty_events = Chef::EventDispatch::Dispatcher.new
      node = Chef::Node.new
      anonymous_run_context = Chef::RunContext.new(node, {}, empty_events)
      @resource_instance = resource_class.new('resource_help', anonymous_run_context)
    else
      $stderr.puts "#{@colorizer.color('Error: specified resource \'', :red)}#{@colorizer.color(@target_resource, :red)}#{@colorizer.color('\' was not found.', :red)}"
      raise 'Resource does not exist'
    end
  end

  def show
    puts "\n* Resource: #{@colorizer.color(@target_resource, :green)}"
    @resource_instance.action :nothing

    puts "  - Chef Version: #{::Chef::VERSION}"
    puts "  + Attributes:"

    (@resource_instance.methods - ::Chef::Resource.instance_methods).sort.each do | attribute |
      if (attribute.to_s =~ /\?|\=/).nil?
        # Catch exceptions to handle methods that aren't attributes
        # and require extra arguments
        begin
          attribute_type = @resource_instance.send(attribute).class
          attribute_type_name = attribute_type != NilClass ? attribute_type.to_s : ''
          puts "    - #{@colorizer.color(attribute.to_s, :cyan)} #{attribute_type_name}"
        rescue
        end
      end
    end

    puts "  + Actions:"

    @resource_instance.allowed_actions.sort.each do | action |
      puts "    - #{@colorizer.color(action.to_s, :yellow)}"
    end
    puts
  end
end

ChefHelp.for_command_argument

