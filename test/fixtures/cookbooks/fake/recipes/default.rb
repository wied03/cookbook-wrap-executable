bsw_wrap_executable_install '/usr/bin/apt-get'

bsw_wrap_executable_install '/usr/bin/debconf' do
  source 'debconf-custom-wrapper.sh.erb'
end

bsw_wrap_executable_install '/usr/bin/diff' do
  cookbook 'fake2'
end

# Make sure if we run this again that we don't mess up a wrapper that has already been done
bsw_wrap_executable_install 'again' do
  target_file '/usr/bin/apt-get'
end