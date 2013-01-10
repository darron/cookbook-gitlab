# "git" group and user.

group "git"

user "git" do
  comment "Git Version Control"
  gid "git"
  home "/home/git"
  shell "/bin/sh"
  supports :manage_home => true
end

directory "/home/git/bin" do
  owner "git"
  group "git"
  mode 00755
  action :create
end

directory "/home/git/repositories" do
  owner "git"
  group "git"
  mode 06775
  action :create
end

template "/home/git/.profile" do
  source "git_profile.erb"
  owner "git"
  group "git"
  mode 0644
end

# "gitlab" group and user.

group "gitlab"

user "gitlab" do
  comment "GitLab"
  gid "gitlab"
  home "/home/gitlab"
  shell "/bin/sh"
  supports :manage_home => true
end

["/home/gitlab/releases", "/home/gitlab/shared", "/home/gitlab/shared/config", "/home/gitlab/shared/system", "/home/gitlab/shared/log", "/home/gitlab/shared/pids"].each do |dir|
  directory dir do
    owner "gitlab"
    group "gitlab"
    mode 0775
    not_if { FileTest.exists?("#{dir}") }
  end
end

template "/home/gitlab/.pam_environment" do
  source "pam_environment.erb"
  owner "gitlab"
  group "gitlab"
  mode 0750
  not_if { FileTest.exists?("/home/gitlab/.pam_environment") }
end

group "git" do
  members ['git', 'gitlab']
end

# nonfiction standard.
group "deploy" do
  members "git"
  append true
end

generate_ssh_keys "gitlab"

template "/home/gitlab/.ssh/config" do
  source "ssh_config.erb"
  owner "gitlab"
  group "gitlab"
  mode 0644
end

template "/home/gitlab/.ssh/authorized_keys" do
  source "gitlab_authorized_keys.erb"
  owner "gitlab"
  group "gitlab"
  mode 0600
end

bash "copy public key" do
  user "root"
  group "root"
  cwd "/home/git"
  code <<-EOH
    cp /home/gitlab/.ssh/id_dsa.pub /home/git/gitlab.pub
    chmod 0444 gitlab.pub
  EOH
  not_if { FileTest.exists?("/home/git/gitlab.pub") }
end

template "/home/gitlab/.gitconfig" do
  source "gitlab_git_config.erb"
  owner "gitlab"
  group "gitlab"
  mode 0644
end

sudo 'gitlab' do
  user "gitlab"
  runas 'root'
  commands ['/usr/sbin/service gitlab restart', '/usr/sbin/service nginx restart', '/usr/sbin/service gitlab start', '/usr/sbin/service nginx start', '/usr/sbin/service gitlab stop', '/usr/sbin/service nginx stop']
  nopasswd true
end