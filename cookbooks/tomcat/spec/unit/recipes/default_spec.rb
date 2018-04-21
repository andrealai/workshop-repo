require 'spec_helper'

describe 'tomcat::default' do
  context 'When all attributes are default, on an Centos 7.4.1708' do

    before(:each) do
      allow(File).to receive(:exists?).with(anything).and_call_original
      allow(File).to receive(:exists?).with('apache-tomcat-8.0.50.tar.gz').and_return false
      allow(File).to receive(:exists?).with('sample.war').and_return false
      allow(File).to receive(:exists?).with('/opt/tomcat/bin').and_return false

      allow(File).to receive("stat('/opt/tomcat/conf/web.xml').mode.mode.to_s(8)[3..5]").and_call_original
      allow(File).to receive("stat('/opt/tomcat/conf/web.xml').mode.mode.to_s(8)[3..5]").and_return '640'
    end

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.4.1708')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes the Server recipe' do
      expect(chef_run).to include_recipe('tomcat::server')
    end
  end
end
