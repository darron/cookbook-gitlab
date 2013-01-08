apt_repository "redis" do
  uri "http://ppa.launchpad.net/chris-lea/redis-server/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "C7917B12"
  action :add
end

package "redis-server"

service "redis-server" do
  service_name "redis-server"
  restart_command "/usr/sbin/service redis-server restart"
  action [:start, :enable]
end