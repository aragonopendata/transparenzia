require "bundler/capistrano"

server "146.185.146.79", :web, :app, :db, primary: true

set :user, "deployer"
set :application, "transparenzia"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:aragonopendata/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases