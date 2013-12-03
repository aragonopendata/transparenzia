namespace :sake do
  desc "Run a task on a remote server."
  # run like: cap staging rake:invoke task=a_certain_task  
  task :invoke do
    run("cd #{deploy_to}/current && bundle exec rake #{ENV['task']} RAILS_ENV=#{rails_env}")
  end
end