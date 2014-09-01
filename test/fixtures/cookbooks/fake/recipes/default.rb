file '/tmp/replaced_apt_wrapper_once' do
  action :nothing
end

bsw_wrap_executable_install '/usr/bin/apt-get' do
  notifies :touch, 'file[/tmp/replaced_apt_wrapper_once]', :immediately
end

bsw_wrap_executable_install '/usr/bin/debconf' do
  source 'debconf-custom-wrapper.sh.erb'
end

bsw_wrap_executable_install '/usr/bin/diff' do
  cookbook 'fake2'
end

file '/tmp/replaced_apt_wrapper_twice' do
  action :nothing
end

# Make sure if we run this again that we don't mess up a wrapper that has already been done
bsw_wrap_executable_install 'again' do
  target_file '/usr/bin/apt-get'
  notifies :touch, 'file[/tmp/replaced_apt_wrapper_twice]', :immediately
end

bsw_wrap_executable_install '/usr/bin/gpg'

bsw_wrap_executable_install 'gpg_again' do
  action :nothing
  target_file '/usr/bin/gpg'
end

# Simulate something switching it back
ruby_block 'wreck stuff' do
  block do
    ::FileUtils.mv '/usr/bin/gpg-wrapped', '/usr/bin/gpg'
  end
  notifies :install, 'bsw_wrap_executable_install[gpg_again]', :immediately
end