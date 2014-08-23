# Encoding: utf-8

require_relative 'spec_helper'

describe 'Default target name/source works' do
  describe command('apt-get --version') do
    it { should return_stdout /apt 1\.0\.1ubuntu2 for amd64 compiled on Jun 13 2014 17:40:05.*/ }
  end

  describe file('/tmp/RAN_APT_GET_JUST_NOW') do
    it { should be_file }
  end
end

describe 'Custom source name works' do
  describe command('debconf --help') do
    it { should return_stdout /Usage: debconf [options] command [args].*/ }
  end

  describe file('/tmp/RAN_DEBCONF_GET_JUST_NOW') do
    it { should be_file }
  end
end

describe 'Custom cookbook works' do
  describe command('diff --version') do
    it { should return_stdout /diff \(GNU diffutils\) 3\.3.*/ }
  end

  describe file('/tmp/RAN_DIFF_GET_JUST_NOW') do
    it { should be_file }
  end
end
