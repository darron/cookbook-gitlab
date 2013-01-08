#
# Cookbook Name:: gitlab
# Recipe:: prerequisites
#
# Copyright (C) 2013 Darron Froese
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "build-essential"
package "openssl"
package "wget"
package "curl"
package "zlib1g-dev"
package "libssl-dev"
package "libffi-dev"
package "libreadline6"
package "libreadline6-dev"
package "zlib1g"
package "zlib1g-dev"
package "libyaml-dev"
package "libsqlite3-0"
package "libsqlite3-dev"
package "sqlite3"
package "libxml2-dev"
package "libxslt1-dev"
package "autoconf"
package "libc6-dev"
package "libncurses5-dev"
package "automake"
package "libtool"
package "bison"
package "checkinstall"
package "openssh-server"
package "git-core"
package "libicu-dev"
package "python"
package "python-software-properties"

gem_package "bundler"

firewall "ufw" do
  action :enable
end

firewall_rule "ssh" do
  port 22
  action :allow
  notifies :enable, "firewall[ufw]"
end
