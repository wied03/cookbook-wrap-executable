# Encoding: utf-8

require_relative 'spec_helper'

def clear_tmp_files
  Dir.glob '/tmp/RAN_*' do |f|
    puts "Removing #{f} before test"
    FileUtils.rm_rf f
  end
end

describe 'Default target name/source works' do
  before(:all) do
    clear_tmp_files
  end

  describe command('apt-get --version') do
    it { should return_stdout /apt 1\.0\.1ubuntu2.*/ }
  end

  describe file('/tmp/RAN_APT_GET_JUST_NOW') do
    it { should be_file }
  end

  describe file('/tmp/replaced_apt_wrapper_once') do
    it { should be_file }
  end

  describe file('/tmp/replaced_apt_wrapper_twice') do
    it { should_not be_file }
  end
end

describe 'Custom source name works' do
  before(:all) do
    clear_tmp_files
  end

  describe command('debconf --help') do
    it { should return_stdout /Usage: debconf \[options\] command \[args\].*/ }
  end

  describe file('/tmp/RAN_DEBCONF_GET_JUST_NOW') do
    it { should be_file }
  end
end

describe 'Custom cookbook works' do
  before(:all) do
    clear_tmp_files
  end

  describe command('diff --version') do
    it { should return_stdout /diff \(GNU diffutils\) 3\.3.*/ }
  end

  describe file('/tmp/RAN_DIFF_GET_JUST_NOW') do
    it { should be_file }
  end
end

describe 'Notification TO the wrapper works, even after the first run was replaced' do
  before(:all) do
    clear_tmp_files
  end

  describe command('gpg --version') do
    it { should return_stdout /gpg \(GnuPG\) 1\..*/ }
  end

  describe file('/tmp/RAN_GPG_JUST_NOW') do
    it { should be_file }
  end
end
