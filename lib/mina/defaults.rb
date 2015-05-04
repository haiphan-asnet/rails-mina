namespace :defaults do
  task :configs do
    set_default :app_path               , "#{deploy_to}/#{current_path}"
    set_default :config_path            , "#{deploy_to}/#{shared_path}/config"
    set_default :pids_path              , "#{deploy_to}/#{shared_path}/pids"
    set_default :sockets_path           , "#{deploy_to}/#{shared_path}/sockets"
    set_default :logs_path              , "#{deploy_to}/#{shared_path}/log"

    set_default :config_templates_path  , "lib/mina/templates"
    set_default :services_path          , '/etc/init.d'
  end
end
