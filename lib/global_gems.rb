# frozen_string_literal: true

require 'bundler/errors'
require 'global_gems/version'
require 'tempfile'

module GlobalGems
  class Plugin
    GLOBAL_GEMFILE = ENV['GLOBAL_GEMFILE'] || '~/.Gemfile.global'

    def register
      Bundler::Plugin::API.command('global_gems', GlobalGems::Plugin)
    end

    def exec(_command_name, args)
      global_gemfile = File.expand_path(GLOBAL_GEMFILE)
      bundle_root = locate_bundle_root

      temp = Dir.mktmpdir('global_gems-')
      at_exit { FileUtils.remove_entry(temp) }

      raise Bundler::GemfileLockNotFound.new, 'Gemfile.lock not found. Run `bundle install`.' unless File.exist? File.join(bundle_root, 'Gemfile.lock')

      Dir[
        File.join(bundle_root, 'Gemfile'),
        File.join(bundle_root, 'Gemfile.lock'),
        File.join(bundle_root, '*.gemspec'),
      ].each { |file| FileUtils.cp(file, temp) }

      File.write(File.join(temp, 'Gemfile'), File.read(global_gemfile), mode: 'a') if File.exist? global_gemfile

      Bundler::SharedHelpers.set_env('BUNDLE_GEMFILE', File.join(temp, 'Gemfile'))
      Bundler.reset_paths!

      Bundler::CLI.start(args)
    end

    private

    def locate_bundle_root
      path_array = Dir.pwd.split('/')

      until path_array.empty?
        return File.join(path_array) if File.exist? File.join(path_array, 'Gemfile')

        path_array = path_array[0..-2]
      end

      raise Bundler::GemfileNotFound.new, 'Gemfile not found.'
    end
  end
end
