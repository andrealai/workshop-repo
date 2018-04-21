package 'java-1.7.0-openjdk-devel'

group 'tomcat'

user 'tomcat' do
  group 'tomcat'
end

remote_file 'Download the Tomcat Binary' do
  path 'apache-tomcat-8.0.50.tar.gz'
  source 'http://apache.mirrors.hoobly.com/tomcat/tomcat-8/v8.0.51/bin/apache-tomcat-8.0.51.tar.gz'
  not_if { ::File.exists? 'apache-tomcat-8.0.50.tar.gz' }
end

remote_file 'Download the Sample Content' do
  path 'sample.war'
  source 'https://github.com/johnfitzpatrick/certification-workshops/blob/master/Tomcat/sample.war'
  not_if { ::File.exists? 'sample.war' }
end

directory '/opt/tomcat'

execute 'Extract the Tomcat Binary' do
  command 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
  not_if { ::File.exists? '/opt/tomcat/bin'}
  notifies :run, 'execute[Make tomcat configuration files own by the tomcat group]', :immediately
end

directory '/opt/tomcat/conf' do
  group 'tomcat'
  mode '770'
  recursive true
end

execute 'Make tomcat configuration files own by the tomcat group' do
  command 'chgrp -R tomcat /opt/tomcat/conf'
  action :nothing
  notifies :run, 'execute[Make tomcat configuration files readonly for the Tomcat group]', :immediately
end

execute 'Make tomcat configuration files readonly for the Tomcat group' do
  command 'chmod g+r /opt/tomcat/conf/*'
  notifies :run, 'execute[Make tomcat owner of the working folder]', :immediately
  action :nothing
end

execute 'Make tomcat owner of the working folder' do
  command 'chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/'
  action :nothing
end

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
  notifies :run, 'execute[Reload Systemd Deamon]', :immediately
end

execute 'Reload Systemd Deamon' do
  command 'systemctl daemon-reload'
  action :nothing
end

service 'tomcat' do
  action [:start, :enable] 
end
