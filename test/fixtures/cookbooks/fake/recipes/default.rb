chef_gem 'with'
require 'with'

bsw_wrap_executable_install '/usr/bin/apt-get'

bsw_wrap_executable_install '/usr/bin/debconf' do
  template_source_file 'debconf-custom-wrapper.sh.erb'
end

bsw_wrap_executable_install '/usr/bin/diff' do
  cookbook 'fake2'
end