Niso::Dependency.load('droplet_kit')

module Niso
  class Cloud
    class DropletKit < Base
      def do_setup

        if @config["size"]
          # Choose size
          @attributes[:size_slug] = @config["size"]
          say "using config size"
        else
          choose(:size, @client.sizes.all())
        end

        if @config["region"]
          # Choose region
          @attributes[:region_slug] = @config["region"]
          say "using config region"
        else
          choose(:region, @client.regions.all())
        end

        # Choose an image
        if @config["image"]
          @attributes[:image_slug] = @config["image"]
          say "using config image"
        else
          if @config['images_filter']
            result = @client.images.all(type: @config['images_filter'])
            result = result.select{|i| i.distribution.match Regexp.new(@config['images_filter'], Regexp::IGNORECASE) }
          end
          choose(:image, result)
        end

        # Go ahead?
        say " - name => #{@ui.color(@name, :blue, :bold)}"
        @attributes.each do |k,v|
          say " - #{k} => #{@ui.color(v, :blue, :bold)}"
        end
        say " - account => #{@ui.color(@client_info.email, :blue, :bold)}"
        moveon = ask("Are you ready to go ahead? (y/n) ", ['y','n'])
        exit unless moveon == 'y'

        ssh_keys = @client.ssh_keys.all.collect { |key| key.fingerprint }

        # Create
        say "creating a new droplet..."
        droplet = ::DropletKit::Droplet.new(name: @name, region: @attributes[:region_slug], image: @attributes[:image_slug], size: @attributes[:size_slug], ssh_keys: ssh_keys)
        result = @client.droplets.create(droplet)

        @droplet_id = result.id
        say "Created a new droplet (id: #{@droplet_id}). Booting..."

        # Boot - we need this before getting public IP
        while @client.droplets.find(id: @droplet_id).status.downcase != 'active'
          sleep 3
        end

        @networks = @client.droplets.find(id: @droplet_id).networks.to_h.to_json
        say "Done."

        @instance = {
          droplet_id: @droplet_id,
          env: @env,
          name: @name,
          networks: JSON.parse(@networks),
          size_slug: @attributes[:size_slug],
          region_slug: @attributes[:region_slug],
          image_slug: @attributes[:image_slug],
        }
      end

      def choose(key, result)
        abort "no #{key} found!" if result.first.nil?
        # result.each{|i| say "#{i.slug}" }
        choices = result.map(&:slug).compact
        @attributes[:"#{key}_slug"] = ask_menu("which #{key}?: ", choices)
      end

      def do_teardown
        say 'deleting droplet...'
        @client.droplets.delete(id: @instance[:droplet_id])
      end

      # Set the client for DropletKit
      #
      # DropletKit::DropletResource
      def setup_client
        begin
          @client = ::DropletKit::Client.new(access_token: @config['access_token'])
          @client_info = @client.account.info()
        rescue ::DropletKit::Error => e
          abort_with e.message
        end
      end
    end
  end
end
