class Chef
  class Provider
    class BswWrapExecutableInstall < Chef::Provider::LWRPBase
      def whyrun_supported?
        true
      end

      use_inline_resources

      def action_install
        with_temporary_resource do |template|
          if template.updated_by_last_action?
            converge_by "Replacing #{@new_resource.target_file} with wrapper" do
              ::FileUtils.mv @new_resource.target_file, wrapped_file
              ::FileUtils.cp template.path, @new_resource.target_file
            end
          end
        end
      end

      private

      def with_temporary_resource
        temporary_file_path = temporary_file_name
        ::FileUtils.cp @new_resource.target_file, temporary_file_path
        begin
          temp = temp_resource temporary_file_path
          temp.run_action :create
          yield temp
        ensure
          ::FileUtils.rm temporary_file_path
        end
      end

      def temporary_file_name
        Dir::Tmpname.create([::File.basename(@new_resource.target_file),'.tmp']) {}
      end

      def temp_resource(temporary_file_path)
        wrapped_file_copy = wrapped_file
        parent_resource = @new_resource
        template_source = parent_resource.source || base_target_file
        template temporary_file_path do
          sensitive true
          cookbook parent_resource.cookbook if parent_resource.cookbook
          source template_source
          variables :wrapped_file => wrapped_file_copy
        end
      end

      def base_target_file
        filename = ::File.basename @new_resource.target_file
        "#{filename}.erb"
      end

      def wrapped_file
        base_file = ::File.basename(@new_resource.target_file)
        wrapper_base = "#{base_file}-wrapped"
        ::File.join(::File.dirname(@new_resource.target_file), wrapper_base)
      end
    end
  end
end