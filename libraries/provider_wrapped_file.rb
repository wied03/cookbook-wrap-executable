class Chef
  class Provider
    class BswWrapExecutableInstall < Chef::Provider::LWRPBase
      def whyrun_supported?
        true
      end

      use_inline_resources

      def action_install
        converge_by "Replacing #{@new_resource.target_file} with wrapper" do
          # Can't access scope of this class methods inside the resource
          parent_resource = @new_resource
          wrapper_cmd = wrapper_command
          target_file = @new_resource.target_file
          temp = wrapper_cmd + '.tmp'
          ruby_block "Copying #{target_file} to #{temp}" do
            block do
              ::FileUtils.cp target_file, temp
            end
          end

          resource_backup_real_exe = "Moving #{target_file} to #{wrapper_cmd}"
          ruby_block resource_backup_real_exe do
            action :nothing
            block do
              ::FileUtils.mv target_file, wrapper_cmd
            end
          end

          template_source = parent_resource.source || base_target_file
          template temp do
            cookbook parent_resource.cookbook if parent_resource.cookbook
            source template_source
            variables :wrapped_file => wrapper_cmd
            notifies :run, "ruby_block[#{resource_backup_real_exe}]", :immediately
          end

          ruby_block "Moving #{temp} back to #{target_file}" do
            block do
              ::FileUtils.mv temp, target_file
            end
          end
        end
      end

      private

      def base_target_file
        filename = ::File.basename @new_resource.target_file
        "#{filename}.erb"
      end

      def wrapper_command
        base_file = ::File.basename(@new_resource.target_file)
        wrapper_base = "#{base_file}-wrapped"
        ::File.join(::File.dirname(@new_resource.target_file), wrapper_base)
      end
    end
  end
end