describe "tomcat" do

  subject { command("curl -I http://localhost:8080") }
  it 'is running' do
    expect(subject.stdout).to contain "200 OK"
  end

end