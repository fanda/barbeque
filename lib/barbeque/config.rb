require 'erb'
require 'yaml'

module Barbeque
  class Config
    attr_accessor :exception_handler, :runner

    def initialize(options = {})
      options.each do |key, value|
        if respond_to?("#{key}=")
          public_send("#{key}=", value)
        else
          raise KeyError.new("Unexpected option '#{key}' was specified.")
        end
      end
    end
  end

  module ConfigBuilder
    DEFAULT_CONFIG = {
      'exception_handler' => 'RailsLogger',
      'runner'            => 'Docker',
    }

    def config
      @config ||= build_config
    end

    def build_config(filename = 'barbeque.yml')
      filepath = Rails.root.join('config', filename).to_s
      hash = YAML.load(ERB.new(File.read(filepath)).result)
      Config.new(DEFAULT_CONFIG.merge(hash[Rails.env]))
    end
  end

  extend ConfigBuilder
end
