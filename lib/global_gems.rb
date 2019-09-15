# frozen_string_literal: true

require 'global_gems/version'

module GlobalGems
  class Plugin
    def register
      Bundler::Plugin::API.command('global_gems', GlobalGems::Plugin)
    end

    def exec(command_name, args)
      puts "Running #{command_name} with #{args}"
    end
  end
end
