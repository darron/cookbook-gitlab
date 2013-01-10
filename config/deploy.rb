require "bundler/capistrano"

default_run_options[:pty] = true
set :use_sudo, false

# Your gitlabhq source repo.
set :scm, :git
set :repository, "git://github.com/gitlabhq/gitlabhq.git"
set :branch, "4-0-stable"

# The server you're installing it on.
set :domain, "33.33.33.10"
role :app, domain
role :web, domain
role :db,  domain, :primary => true

# Where to install on that server.
set :user, "gitlab"
set :application, "gitlab"
set :deploy_to, "/home/#{user}"

# How you want to bundle.
set :bundle_flags, "--deployment"
set :bundle_without, [:development, :postgres, :test]
set :rails_env, :production

namespace :deploy do

  after 'deploy:setup' do    
    # Fix permissions on :deploy_to - ssh doesn't like 775: "/var/log/auth.log: bad ownership or modes for directory"
    run "chmod 755 #{deploy_to}"
  end
  
  before 'deploy:create_symlink' do
    # Symlink database.yml gitlab.yml unicorn.rb
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/gitlab.yml #{release_path}/config/gitlab.yml"
    run "ln -nfs #{shared_path}/config/unicorn.rb #{release_path}/config/unicorn.rb"
  end
  
  after 'deploy:create_symlink' do
    run "ln -nfs #{release_path} #{deploy_to}/#{application}"
  end
  
  task :restart do
    run "sudo service gitlab restart"
    run "sudo service nginx restart"
  end
  
  task :start do
    run "sudo service gitlab start"
    run "sudo service nginx start"
  end

  task :stop do
    run "sudo service gitlab stop"
    run "sudo service nginx stop"
  end
  
  task :app_setup do
    run "cd /home/gitlab/gitlab;bundle exec rake gitlab:app:setup RAILS_ENV=production"
  end

end