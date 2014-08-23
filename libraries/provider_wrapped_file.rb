class Chef
  class Provider
    class BswWrapExecutableInstall < Chef::Provider::LWRPBase
      def whyrun_supported?
        true
      end

      def action_install
        converge_by 'doing stuff' do

        end
      end
    end
  end
end