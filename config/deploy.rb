set :application, 'websitespeed'
set :repo_url, 'git@git.xiaoma.com:websitespeed'
set :branch, 'master'
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
  
set :deploy_to, '/app/rails/load.data.xiaoma.com'
set :scm, :git
  
set :format, :pretty
set :log_level, :debug
set :pty, true
  
# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
  
#set :default_env, { path: "~/.rvm/bin:$PATH" }
set :keep_releases, 5
  
# rvm setting
# set :rails_env, "production" 
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-1.9.3-p484@xmwebspeed'
set :default_env, { rvm_bin_path: '~/.rvm/bin' }
#SSHKit.config.command_map[:rake] = "bundle exec rake"
SSHKit.config.command_map[:rake] = "#{fetch(:default_env)[:rvm_bin_path]}/rvm ruby-#{fetch(:rvm_ruby_version)} do bundle exec rake"
  
# for puma
#set :puma_state, "#{shared_path}/tmp/pids/puma.state"
#set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
#set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
#set :puma_conf, "#{shared_path}/config/puma.rb"
#set :puma_access_log, "#{shared_path}/log/puma_error.log"
#set :puma_error_log, "#{shared_path}/log/puma_access.log"
#set :puma_role, :app
#set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
#set :puma_threads, [0, 16]
#set :puma_workers, 2
  
# For RVM users, it is advisable to set in your deploy.rb for now :
#set :puma_cmd, "#{fetch(:bundle_cmd, 'bundle')} exec puma"
#set :pumactl_cmd, "#{fetch(:bundle_cmd, 'bundle')} exec pumactl"
  
# For Jungle tasks, these options exist:
# set :puma_jungle_conf, '/etc/puma.conf'
# set :puma_run_path, '/usr/local/bin/run-puma'
  
#before 'puma:status', 'rvm:hook'
#before 'puma:start', 'rvm:hook'
#before 'puma:restart', 'rvm:hook'
 
desc 'make production database.yml link' 
task :symlink_db_yml do
  on roles(:all) do	
    execute "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

namespace :deploy do
  set :unicorn_config, "#{current_path}/config/unicorn.rb" 
  set :unicorn_pid, "#{shared_path}/tmp/unicorn.pid"
  set :passenger_pid, "#{shared_path}/tmp/passenger.pid"
  set :passenger_socket, "#{shared_path}/tmp/passenger.socket"
  set :passenger_port, "3102"
  set :passenger_user, "vincent"

  desc 'Restart application'
  task :restart do
    on roles(:all), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
	    execute "if [ -f #{fetch(:unicorn_pid)} ]; then kill -USR2 `cat #{fetch(:unicorn_pid)}`; fi"
    end
  end

  desc 'stop application'
  task :stop do
    on roles(:all), in: :sequence, wait: 5 do
	  execute "if [ -f #{fetch(:unicorn_pid)} ]; then kill -QUIT `cat #{fetch(:unicorn_pid)}`; fi"
    end
  end

  desc 'start application'
  task :start do
    on roles(:all), in: :sequence, wait: 5 do
	  within "#{current_path}" do
        with rails_env: "production", bundle_gemfile: fetch(:bundle_gemfile) do
	      execute :bundle, :exec, "unicorn_rails -c #{fetch(:unicorn_config)} -D"
        end
      end
    end
  end

  desc 'Restart applicationi use passenger'
  task :restart_ps do
    on roles(:all), in: :sequence, wait: 5 do
      within "#{current_path}" do
        with rails_env: "production", bundle_gemfile: fetch(:bundle_gemfile) do
          execute :bundle, :exec, "passenger stop --pid-file #{fetch(:passenger_pid)}"
	  execute :bundle, :exec, "passenger start -e production -d -p #{fetch(:passenger_port)} --pid-file #{fetch(:passenger_pid)} --user #{fetch(:passenger_user)}"	      
        end
      end
    end
  end

  desc 'stop application passenger'
  task :stop_ps do
    on roles(:all), in: :sequence, wait: 5 do
      within "#{current_path}" do
        with rails_env: "production", bundle_gemfile: fetch(:bundle_gemfile) do
              execute :bundle, :exec, "passenger stop --pid-file #{fetch(:passenger_pid)}"
        end
      end
    end
  end

  desc 'start application use passenger'
  task :start_ps do
    on roles(:all), in: :sequence, wait: 5 do
      within "#{current_path}" do
        with rails_env: "production", bundle_gemfile: fetch(:bundle_gemfile) do
              execute :bundle, :exec, "passenger start -e production -d -p #{fetch(:passenger_port)} --pid-file #{fetch(:passenger_pid)} --user #{fetch(:passenger_user)}"
        end
      end
    end
  end

  desc 'init db seed'
  task :seed do
    on roles(:all), in: :sequence, wait: 5 do
    within "#{current_path}" do
        with rails_env: "production" do
        execute :rake, "db:seed"
        end
      end
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  before 'start', 'rvm:hook' 
  before 'start_ps', 'rvm:hook'
  before 'restart_ps', 'rvm:hook'
  before 'stop_ps', 'rvm:hook'
  after :finishing, 'deploy:cleanup'
  

  after 'bundler:install', :symlink_db_yml
end 
