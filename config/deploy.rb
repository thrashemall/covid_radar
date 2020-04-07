# frozen_string_literal: true

require 'pathname'
require 'mina/rails'
require 'pry'
require 'dotenv'

Dir[Pathname.new(File.expand_path('deploy', __dir__)).join('tasks', '*.rb')].each(&method(:load))

# SSH
set :user, 'root'
set :forward_agent, true # /usr/bin/ssh-add -K ~/.ssh/id_rsa

# Application
set :puma, -> { raise }
set :bot, -> { raise }
set :sidekiq, -> { raise }
set :rails_env, -> { raise }
set :registry, 'registry.gitlab.com/alex.shilov.by/covid_radar:latest'
set :migrate, -> { ENV['MIGRATE'] }

task :provision do
  command <<~CMD
    docker service create \
      --name #{fetch(:puma)} \
      --with-registry-auth \
      --env RAILS_ENV=#{fetch(:rails_env)} \
      --network overlay \
      --replicas=2 \
      #{fetch(:registry)} \
      bundle exec puma -t 0:8 -p 3000
  CMD

  command <<~CMD
    docker service create \
      --name #{fetch(:bot)} \
      --with-registry-auth \
      --env RAILS_ENV=#{fetch(:rails_env)} \
      --network overlay \
      #{fetch(:registry)} \
      ruby bot.rb
  CMD

  command <<~CMD
    docker service create \
      --name #{fetch(:sidekiq)} \
      --with-registry-auth \
      --env RAILS_ENV=#{fetch(:rails_env)} \
      --network overlay \
      --stop-grace-period 120s \
      #{fetch(:registry)} \
      bundle exec sidekiq -t 120
  CMD
end

task :deploy do
  invoke :make, 'docker:push'

  if fetch(:migrate)
    invoke :'docker_service:shot', "migrate-#{fetch(:puma)}", <<~CMD
    docker service create \
      --network overlay \
      --with-registry-auth \
      --env RAILS_ENV=#{fetch(:rails_env)} \
      --detach \
      --name $SHOT_NAME \
      --restart-condition none \
      #{fetch(:registry)} bundle exec rake db:migrate
    CMD
  else
    puts '🚫 Migrations skipped'
  end

  invoke :'docker_service:update', fetch(:puma), "--force --with-registry-auth --image #{fetch(:registry)}"
  invoke :'docker_service:update', fetch(:bot), "--force --with-registry-auth --image #{fetch(:registry)}"
  invoke :'docker_service:update', fetch(:sidekiq), "--force --with-registry-auth --image #{fetch(:registry)}"

  command "tput -Txterm-color setaf 3; echo 'Done RAILS_ENV=#{fetch(:rails_env)}, domain <#{fetch(:domain)}>'"
end
