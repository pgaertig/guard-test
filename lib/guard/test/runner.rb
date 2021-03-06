# encoding: utf-8
module Guard
  class Test
    class Runner

      attr_reader :options

      def initialize(opts = {})
        @options = {
          :bundler  => File.exist?("#{Dir.pwd}/Gemfile"),
          :rubygems => false,
          :rvm      => [],
          :include  => ['test'],
          :drb      => false,
          :zeus     => false,
          :cli      => ''
        }.merge(opts)
      end

      def run(paths, opts = {})
        return true if paths.empty?

        ::Guard::UI.info(opts[:message] || "Running: #{paths.join(' ')}", :reset => true)

        system(test_unit_command(paths))
      end

      def bundler?
        if @bundler.nil?
          @bundler = options[:bundler] && !drb? && !zeus?
        end
        @bundler
      end

      def rubygems?
        !bundler? && !zeus? && options[:rubygems]
      end

      def drb?
        if @drb.nil?
          @drb = options[:drb]
          begin
            require 'spork-testunit'
          rescue LoadError
          end
          ::Guard::UI.info('Using testdrb to run the tests') if @drb
        end
        @drb
      end

      def zeus?
        if @zeus.nil?
          @zeus = options[:zeus]
          ::Guard::UI.info('Using zeus to run the tests') if @zeus
        end
        @zeus
      end

    private

      def test_unit_command(paths)
        cmd_parts = executables
        cmd_parts.concat(includes_and_requires(paths))
        cmd_parts.concat(test_files_list(paths))
        cmd_parts.concat(command_options)
        cmd_parts << options[:cli]

        cmd_parts.compact.join(' ').strip
      end

      def executables
        parts = []
        parts << "rvm #{options[:rvm].join(',')} exec" unless options[:rvm].empty?
        parts << 'bundle exec' if bundler?
        parts << case true
                 when drb? then 'testdrb'
                 when zeus? then 'zeus test'
                 else 'ruby'; end
      end

      def includes_and_requires(paths)
        parts = []
        parts << Array(options[:include]).map { |path| "-I#{path}" } unless zeus?
        parts << '-r bundler/setup' if bundler?
        parts << '-rubygems' if rubygems?
        unless drb? || zeus?
          parts << "-r #{File.expand_path("../guard_test_runner", __FILE__)}"
          parts << "-e \"%w[#{paths.join(' ')}].each { |p| load p }\""
        end

        parts
      end

      def test_files_list(paths)
        paths.map { |path| "\"./#{path}\"" }
      end

      def command_options
        if drb? || zeus?
          []
        else
          ['--use-color', '--runner=guard']
        end
      end

    end
  end
end
