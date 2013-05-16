server '184.72.47.189', :app, :web, :db, :primary => true
set :deploy_to, "/home/ubuntu/staging/#{application}/"
set :branch, 'develop'
set :rails_env, 'production'
set :deploy_via, :remote_cache
after('deploy:create_symlink', 'cache:clear')

namespace :deploy do
	
	task :before_update_code do
		#stop solr:
		run "cd #{current_path} && rake sunspot:solr:stop RAILS_ENV=#{rails_env}"
	end
	
	namespace :solr do
			desc <<-DESC
				Symlink in-progress deployment to a shared Solr index.
			DESC
			task :symlink, :except => { :no_release => true } do
			run "ln -nfs #{shared_path}/solr #{current_path}/solr"
			run "ls -al #{current_path}/solr/pids/"
			run "cd #{current_path} && rake sunspot:solr:start RAILS_ENV=#{rails_env}"
		end
	end
	
  task :start do ; end
  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :finalize_update do
		run "ln -nfs #{deploy_to}shared/config/database.yml #{release_path}/config/database.yml"
	end  
	
	after "deploy:update_crontab", "deploy:solr:symlink"

end