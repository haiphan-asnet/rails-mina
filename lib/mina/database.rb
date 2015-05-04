namespace :database do
  desc "Set defaults config for database"
  task :defaults do
    set_default :db_adapter           , 'postgresql'
    set_default :db_host              , '<%= ENV["DB_HOST"] %>'
    set_default :db_database          , '<%= ENV["DB_DATABASE"] %>'
    set_default :db_username          , '<%= ENV["DB_USERNAME"] %>'
    set_default :db_password          , '<%= ENV["DB_PASSWORD"] %>'
    set_default :db_template          , 'database.yml'
  end

  desc "Upload database.yml config file"
  task :update => [:upload]

  desc "Parses database.yml config file and uploads it to server"
  task :upload => [:'upload:config']

  namespace :upload do
    desc "Parses database config file and uploads it to server"
    task :config do
      queue %{echo "-----> Uploading database configs"}
      upload_template 'Database config', "#{db_template!}", "#{config_path!}/database.yml"
    end
  end
end

invoke :'database:defaults'
