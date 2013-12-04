require 'hiera'


module Capistrano
  class Configuration
    module CapHiera

      def hiera lookup_key
        logger.debug "Looking up #{lookup_key}"

        hiera_get( lookup_key, {:namespace => current_task.namespace.name,
                                :task => current_task.name,
                                :environment => fetch(:environment) } )
      end

      def hiera_get hierakey, scope

        @@options ||= {
          :default => nil,
          :config => "./hiera.yaml",
          :scope => {},
          :key => nil,
          :verbose => false,
          :resolution_type => :priority
        }

        begin
          @@hiera = Hiera.new(:config => @@options[:config])
          # , :verbose => false)
        rescue Exception => e
          STDERR.puts "Failed to start Hiera: #{e.class}: #{e}"
          exit 1
        end

        # Hiera.logger = "noop"

        scope.each do |k, v|
          @@options[:scope][k.to_s] = v.to_s
        end

        @@options[:key] = hierakey

        @@hiera.lookup(@@options[:key], @@options[:default], @@options[:scope], nil, @@options[:resolution_type])

      end

    end
  end
end

module Capistrano
  class Configuration

    include CapHiera

  end
end
