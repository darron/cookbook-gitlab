
git "/home/git/gitolite" do
    repository "https://github.com/gitlabhq/gitolite.git"
    revision "gl-v304"
    action :sync
    user "git"
    group "git"
end

bash "install gitolite to /home/git/bin" do
  user "git"
  group "git"
  cwd "/home/git"
  code <<-EOH
    /home/git/gitolite/install -ln /home/git/bin
  EOH
  not_if { FileTest.exists?("/home/git/bin/gitolite") }
end

bash "setup gitolite with public key" do
  user "root"
  cwd "/home/git"
  code <<-EOH
    sudo -u git -H sh -c "PATH=/home/git/bin:$PATH; gitolite setup -pk /home/git/gitlab.pub"
  EOH
  not_if { FileTest.exists?("/home/git/.gitolite") }
end

directory "/home/git/.gitolite" do
  owner "git"
  group "git"
  mode 00750
  action :create
end

bash "chown .gitolite folder" do
  user "root"
  cwd "/home/git"
  code <<-EOH
    chown -R git.git /home/git/.gitolite
  EOH
  only_if { FileTest.exists?("/home/git/.gitolite") }
end