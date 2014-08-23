class Chef
  class Resource
    class BswWrapExecutableInstall < Chef::Resource::LWRPBase
      actions :install
      attribute :target_file, :kind_of => String, :name_attribute => true
      attribute :template_source_file, :kind_of => String
      attribute :cookbook, :kind_of => String

      self.resource_name = :bsw_wrap_executable_install
      self.default_action :install
    end
  end
end