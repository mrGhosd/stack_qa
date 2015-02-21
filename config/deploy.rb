# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'stackqa'
set :repo_url, 'git@github.com:mrGhosd/stack_qa.git'


# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/deploy/stackqa'
set :deploy_user, 'deploy'

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/private_pub.yml config/private_pub_thin.yml .env}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

namespace :private_pub do
  desc 'start private_pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C ~/stackqa/shared/config/private_pub_thin.yml start"
        end
      end
    end
  end

  desc 'stop private_pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C ~/stackqa/shared/config/private_pub_thin.yml stop"
        end
      end
    end
  end

  desc 'restart private_pub server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C ~/stackqa/shared/config/private_pub_thin.yml restart"
        end
      end
    end
  end
end

after 'deploy:restart', 'private_pub:restart'