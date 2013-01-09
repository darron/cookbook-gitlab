
# Deploy via Capistrano.

log "################################# This is where you need to install Gitlab. #################################" do
  not_if { FileTest.exists?("/home/gitlab/gitlab") }
end

# Install the init script.
template "/etc/init.d/gitlab" do
  source "gitlab-init.erb"
  owner "root"
  group "root"
  mode 0755
end

service "gitlab" do
  supports :restart => true, :start => true, :stop => true, :reload => true
  action [ :enable]
end

# Install the configs.
cookbook_file "/home/gitlab/shared/config/database.yml" do
  source "database.yml"
  owner "gitlab"
  group "gitlab"
  mode 0644
end

template "/home/gitlab/shared/config/gitlab.yml" do
  source "gitlab.yml.erb"
  owner "gitlab"
  group "gitlab"
  mode 0644
end

template "/home/gitlab/shared/config/unicorn.rb" do
  source "unicorn.erb"
  owner "gitlab"
  group "gitlab"
  mode 0644
end