module Niso
  class Dependency
    def self.all
      {
        'highline' => { :require => 'highline', :version => '>= 1.7.8'},
        'droplet_kit' =>  { :require => 'droplet_kit',  :version => '>= 2.1.0' },
      }
    end

    def self.load(name)
      begin
        gem(name, all[name][:version])
        require(all[name][:require])
      rescue LoadError
        if $!.to_s =~ /Gemfile/
          Logger.error <<-EOS
Dependency missing: #{name}
Add this line to your application's Gemfile.

    gem '#{name}', '#{all[name][:version]}'

Please try again after running "bundle install".
          EOS
        else
          Logger.error <<-EOS
Dependency missing: #{name}
To install the gem, issue the following command:

    gem install #{name} -v '#{all[name][:version]}'

Please try again after installing the missing dependency.
          EOS
        end
        abort
      end
    end
  end
end
