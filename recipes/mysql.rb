package "makepasswd"

bash "setup mysql password" do
  user "root"
  cwd "/root"
  code <<-EOH
    userPassword=$(makepasswd --char=10) # Generate a random MySQL password
    echo mysql-server mysql-server/root_password password $userPassword | sudo debconf-set-selections
    echo mysql-server mysql-server/root_password_again password $userPassword | sudo debconf-set-selections
  EOH
  not_if { FileTest.exists?("/usr/sbin/mysqld") }
end

package "mysql-server"
package "mysql-client"
package "libmysqlclient-dev"