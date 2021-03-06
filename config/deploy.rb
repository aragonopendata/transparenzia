require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/image_magick"
load "config/recipes/postgresql"
load "config/recipes/postgresql_backup"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/sake"
load "config/recipes/check"

server "172.27.15.158", :web, :app, :db, primary: true

set :user, "deployer"
set :application, "transparenzia"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "https://github.com/aragonopendata/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases
