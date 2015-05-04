$:.unshift './lib'

require 'mina/multistage'
require 'mina/bundler'
require 'mina/rails'
# require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm'    # for rvm support. (http://rvm.io)
require 'mina/rsync'

require 'mina/defaults'
require 'mina/extras'
require 'mina/dotenv'
require 'mina/database'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :app, 'rails-mina'
set :deploy_to, "$HOME/#{app}"

# set :domain, 'foobar.com'
# set :deploy_to, '/var/www/foobar.com'
# set :repository, 'git://...'
# set :branch, 'master'

# Rsync options
set :rsync_options, %w[
  --recursive --delete --delete-excluded
  --exclude .git*
  --exclude /config/database.yml
  --exclude /test/***
  --exclude /spec/***
  --exclude /features/***
  --exclude /lib/mina
]

# For system-wide RVM install.
set :rvm_path, '/usr/local/rvm/scripts/rvm'
set :rvm_env, "ruby-2.1.5@#{app}"

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log', '.env']

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.
set :forward_agent, true     # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :"rvm:use[#{rvm_env}]"
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[sudo mkdir -p "#{deploy_to}"]
  queue! %[sudo chmod -R g+rwx,u+rwx "#{deploy_to}"]

  queue! %[mkdir -p "#{deploy_to}/#{releases_path}"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{releases_path}"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  # queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  # queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml'."]

  invoke :'database:update'
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    # invoke :'git:clone'
    invoke :'rsync:deploy'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      # queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      # queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
    end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

invoke :'defaults:configs'