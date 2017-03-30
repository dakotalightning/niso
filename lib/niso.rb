require 'thor'
require 'rainbow'
require 'yaml'

# Starting 2.0.0, Rainbow no longer patches string with the color method by default.
require 'rainbow/version'
require 'rainbow/ext/string' unless Rainbow::VERSION < '2.0.0'

module Sunzi
  autoload :Cli,        'niso/cli'
  autoload :Cloud,      'niso/cloud'
  autoload :Dependency, 'niso/dependency'
  autoload :Logger,     'niso/logger'
  autoload :Utility,    'niso/utility'

  class Cloud
    autoload :Base,         'niso/cloud/base'
    autoload :DropletKit,   'niso/cloud/droplet_kit'
  end
end
