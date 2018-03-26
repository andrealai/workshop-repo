require 'spec_helper'

describe 'tomcat::server' do
  context 'When all attributes are default, on an Centos 7.4.1708' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.4.1708')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
