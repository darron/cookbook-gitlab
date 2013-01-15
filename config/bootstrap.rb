bash -c '
if [ ! -f /usr/local/bin/chef-client ]; then
  apt-get update
  # Work around interactive grub problem: http://askubuntu.com/questions/146921/how-do-i-apt-get-y-dist-upgrade-without-a-grub-config-prompt
  DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
  apt-get install -y build-essential openssl wget curl zlib1g-dev libssl-dev libffi-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev autoconf libc6-dev libncurses5-dev automake libtool bison
  cd /usr/src
  wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p327.tar.bz2
  tar xjf ruby-1.9.3-p327.tar.bz2
  cd ruby-1.9.3-p327
  ./configure
  make
  make install

  cd ext/openssl/
  ruby extconf.rb
  make
  make install

  cd ../readline/
  ruby extconf.rb
  make
  make install
  ln -s /usr/local/bin/ruby /usr/bin/ruby
  
  wget http://production.cf.rubygems.org/rubygems/rubygems-1.8.24.tgz
  tar zxf rubygems-1.8.24.tgz
  cd rubygems-1.8.24
  ruby setup.rb --no-format-executable
fi

gem install ohai chef --no-rdoc --no-ri --verbose <%= '--prerelease' if @config[:prerelease] %>
gem install fog --no-rdoc --no-ri
gem install ruby-shadow --no-rdoc --no-ri

mkdir -p /etc/chef

(
cat <<'EOP'
<%= IO.read(Chef::Config[:validation_key]) %>
EOP
) > /tmp/validation.pem
awk NF /tmp/validation.pem > /etc/chef/validation.pem
rm /tmp/validation.pem

(
cat <<'EOP'
log_level        :info
log_location     STDOUT
chef_server_url  "<%= Chef::Config[:chef_server_url] %>"
validation_client_name "<%= Chef::Config[:validation_client_name] %>"
<% if @config[:chef_node_name] == nil %>
# Using default node name"
<% else %>
node_name "<%= @config[:chef_node_name] %>"
<% end %>
environment "<%= Chef::Config[:environment] %>"
EOP
) > /etc/chef/client.rb

(
cat <<'EOP'
<%= { "run_list" => @run_list }.to_json %>
EOP
) > /etc/chef/first-boot.json

/usr/local/bin/chef-client -j /etc/chef/first-boot.json'
