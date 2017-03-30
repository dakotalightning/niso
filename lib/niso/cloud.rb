module Niso
  class Cloud
    include Niso::Utility

    def initialize(cli, provider)
      @subject = case provider
      when 'droplet_kit'
        Niso::Cloud::DropletKit.new(cli, provider)
      else
        abort_with "Provider #{provider} is not valid!"
      end
    end

    def method_missing(sym, *args, &block)
      @subject.send sym, *args, &block
    end

    def respond_to?(method)
      @subject.respond_to?(sym) || super
    end
  end
end
