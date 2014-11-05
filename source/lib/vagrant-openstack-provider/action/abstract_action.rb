require 'colorize'

module VagrantPlugins
  module Openstack
    module Action
      class AbstractAction
        def call(env)
          execute(env)
        # rubocop:disable Lint/RescueException
        # rubocop:disable Style/SpecialGlobalVars
        # rubocop:disable Lint/RescueException
        rescue Exception => e
          puts I18n.t('vagrant_openstack.global_error').red unless e.message && e.message.start_with?('Catched Error:')
          raise $!, "Catched Error: #{$!}", $!.backtrace
        end
        # rubocop:enable Lint/RescueException
        # rubocop:enable Style/SpecialGlobalVars
      end
    end
  end
end
