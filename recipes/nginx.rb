package "nginx"

# open standard http port to tcp traffic only; insert as first rule
firewall_rule "http" do
  port 80
  protocol :tcp
  position 1
  action :allow
end

template "/etc/nginx/sites-enabled/gitlab" do
  source "gitlab-nginx.erb"
  owner "root"
  group "root"
  mode 0644
end