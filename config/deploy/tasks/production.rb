# frozen_string_literal: true

# mina production deploy
task :production do
  set :puma, 'covid-puma'
  set :sidekiq, 'covid-sidekiq'
  set :bot, 'covid-bot'
  set :rails_env, 'production'
  set :domain, 'swarm-node-wuhan'
end
