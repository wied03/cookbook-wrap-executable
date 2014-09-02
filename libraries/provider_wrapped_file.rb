class Chef
  class Provider
    class BswWrapExecutableInstall < Chef::Provider::LWRPBase
      def whyrun_supported?
        true
      end

      use_inline_resources

      def action_install
        current = get_current_contents
        draft = get_draft_contents
        if current != draft
          converge_by "Replacing #{@new_resource.target_file} with wrapper" do
            wrapped = get_wrapped_file_name
            ::FileUtils.mv @new_resource.target_file, wrapped
            existing_permissions = ::File.stat(wrapped).mode
            ::File.open @new_resource.target_file, 'w', existing_permissions do |file|
              file << draft
            end
          end
        end
      end

      private

      def get_template_file_contents(source, cookbook_name)
        ::File.read(get_template_location(source, cookbook_name))
      end

      def get_template_location(source, cookbook_name)
        cookbook = run_context.cookbook_collection[cookbook_name]
        cookbook.preferred_filename_on_disk_location(node, :templates, source)
      end

      def get_draft_contents
        cookbook = @new_resource.cookbook || @new_resource.cookbook_name
        template_contents = get_template_file_contents get_source_file_name, cookbook
        # used in the template
        @wrapped_file = get_wrapped_file_name
        ERB.new(template_contents).result(binding)
      end

      def get_current_contents
        ::File.read(@new_resource.target_file)
      end

      def get_source_file_name
        candidate = @new_resource.source || ::File.basename(@new_resource.target_file)
        if ::File.extname(candidate) != '.erb'
          candidate += '.erb'
        end
        candidate
      end

      def get_wrapped_file_name
        base_file = ::File.basename(@new_resource.target_file)
        wrapper_base = "#{base_file}-wrapped"
        ::File.join(::File.dirname(@new_resource.target_file), wrapper_base)
      end
    end
  end
end