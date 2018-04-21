require 'spec_helper'

describe 'tomcat::server' do
  context 'When all attributes are default on Fresh enviroment, on an Centos 7.4.1708' do

    before(:each) do
      allow(File).to receive(:exists?).with(anything).and_call_original
      allow(File).to receive(:exists?).with('apache-tomcat-8.0.50.tar.gz').and_return false
      allow(File).to receive(:exists?).with('sample.war').and_return false
      allow(File).to receive(:exists?).with('/opt/tomcat/bin').and_return false
    end

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.4.1708')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'install java-1.7.0-openjdk-devel' do
      expect(chef_run).to install_package('java-1.7.0-openjdk-devel')
    end

    it 'creates the tomcat OS group' do
      expect(chef_run).to create_group('tomcat')
    end
    
    it 'creates user tomcat' do
      expect(chef_run).to create_user('tomcat')
      expect(chef_run).to create_user('tomcat').with(group: 'tomcat')
    end  

    it 'Download the Tomcat Binary' do
      expect(chef_run).to create_remote_file('Download the Tomcat Binary')
    end

    it 'Download the Sample Content' do
      expect(chef_run).to create_remote_file('Download the Sample Content')
    end

    it 'Create the tomcat Directory' do
      expect(chef_run).to create_directory('/opt/tomcat')
    end

    it 'Unpack the Tomcat binary installation' do
      expect(chef_run).to run_execute('Extract the Tomcat Binary')
    end

    it 'Create the Tomcat folder' do
      expect(chef_run).to create_directory('/opt/tomcat/conf')
    end

    it 'Makes the tomcat configuration files own by the tomcat group' do
      execute = chef_run.execute('Make tomcat configuration files own by the tomcat group')
      expect(execute).to do_nothing
    end

    it 'Make tomcat configuration files readonly for the Tomcat group' do
      execute = chef_run.execute('Make tomcat configuration files readonly for the Tomcat group')
      expect(execute).to do_nothing
    end

    it 'Make tomcat owner of the working folder' do
      execute = chef_run.execute('Make tomcat owner of the working folder')
      expect(execute).to do_nothing
    end

    it 'Create the Tomcat service configiration file' do
      expect(chef_run).to create_template('/etc/systemd/system/tomcat.service')
    end

    it 'Reload Systemd Deamon' do
      execute = chef_run.execute('Reload Systemd Deamon')
      expect(execute).to do_nothing
    end

    it 'Starts and Enables to Tomcat Service' do
      expect(chef_run).to start_service('tomcat')
      expect(chef_run).to enable_service('tomcat')
    end
  end

  context 'When all attributes are default on Existing Installation, on an Centos 7.4.1708' do

    before(:each) do
      allow(File).to receive(:exists?).with(anything).and_call_original
      allow(File).to receive(:exists?).with('apache-tomcat-8.0.50.tar.gz').and_return true
      allow(File).to receive(:exists?).with('sample.war').and_return true
      allow(File).to receive(:exists?).with('/opt/tomcat/bin').and_return true
    end

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.4.1708')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'Does NOT Download the Tomcat Binary' do
      expect(chef_run).not_to create_remote_file('Download the Tomcat Binary')
    end

    it 'Does NOT Download the Sample Content' do
      expect(chef_run).not_to create_remote_file('Download the Sample Content')
    end

    it 'Does NOT Unpack the Tomcat binary installation' do
      expect(chef_run).not_to run_execute('Extract the Tomcat Binary')
    end
  end
end
