Niso::Dependency.load('highline')

module Niso
  class Cloud
    class Base
      include Niso::Utility

      def initialize(cli, provider)
        @provider = provider
        @cli = cli
        @ui = HighLine.new
      end

      def setup
        unless File.exist? provider_config_path
          @cli.empty_directory "#{@provider}/instances"
          @cli.template "templates/setup/#{@provider}.yml", provider_config_path
          exit_with "Now go ahead and update the access_token:, name: of #{@provider}.yml, then run this command again!"
        end

        # get the config { provider }.yml
        assign_config

        if @config['name'] == 'example-droplet-01'
          abort_with "You must update the name in your settings file #{@provider}.yml"
        end

        if @config['access_token'] == 'your_api_key'
          abort_with "Access Token is invalid, please check your #{@provider}.yml"
        end

        # Ask environment and hostname
        @env = ask_menu("environment?", @config['environments'])

        @name = "#{@config['name']}-#{@env}"
        abort_with "#{@name} already exists!" if instance_config_path.exist?

        # get the client @client
        setup_client

        @attributes = {}
        do_setup

        # Save instance info
        @cli.create_file instance_config_path, YAML.dump(@instance)
      end

      def teardown
        names = Dir.glob("#{@provider}/instances/*.yml").map{|i| i.split('/').last.sub('.yml','') }
        abort_with "No match found with #{@provider}/instances/*.yml" if names.empty?

        @name = ask_menu("which instance?: ", names)

        assign_config

        @instance = YAML.load(instance_config_path.read)

        # Are you sure?
        moveon = ask("Are you sure about deleting #{@instance[:name]} permanently? (y/n) ", String) {|q| q.in = ['y','n']}
        exit unless moveon == 'y'

        # Run Linode / DigitalOcean specific tasks
        setup_client
        do_teardown

        # Remove the instance config file
        @cli.remove_file instance_config_path

        say 'Done.'
      end

      def assign_config
        @config = YAML.load(provider_config_path.read)
      end

      def provider_config_path
        Pathname.new "#{@provider}/#{@provider}.yml"
      end

      def instance_config_path
        Pathname.new "#{@provider}/instances/#{@name}.yml"
      end

      def ask(question, answer_type, &details)
        @ui.ask(@ui.color(question, :green, :bold), answer_type, &details)
      end

      def ask_menu(question, choices)
        answer = @ui.choose do |menu|
          menu.prompt = "#{@ui.color(question, :green, :bold)} "
          choices.each { |n| menu.choice(n) }
        end
        say("=> #{answer}")
        answer
      end

      def proceed?
        moveon = ask("Are you ready to go ahead and create #{@name}? (y/n) ", String) {|q| q.in = ['y','n']}
        exit unless moveon == 'y'
      end
    end
  end
end
