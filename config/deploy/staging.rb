set :domain, '192.168.13.3'
set :deploy_to, "/var/www/#{app}"
set :repository, 'https://github.com/user/repo'
set :branch, 'master'
set :user, 'vagrant'
set :rails_env, 'staging'
