namespace :dotenv do
  desc "Set defaults config for dotenv"
  task :defaults do
    set_default :dotenv_template          , '.env'
  end

  desc "Upload .env config file"
  task :update => [:upload]

  desc "Parses .env config file and uploads it to server"
  task :upload => [:'upload:config']

  namespace :upload do
    desc "Parses Rails ENV variables config file and uploads it to server"
    task :config do
      queue %{echo "-----> Uploading dotenv ..."}
      upload_template 'Rails ENV variables config', "#{dotenv_template!}", "#{deploy_to}/shared/.env"
    end
  end

  desc "Parses .env config file and shows them in output"
  task :parse => [:'parse:config']

  namespace :parse do
    desc "Parses .env config file and shows it in output"
    task :config do
      puts erb("#{config_templates_path}/env.erb")
    end
  end
end

invoke :'dotenv:defaults'
