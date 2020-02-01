# Capistranoのバージョン指定（デフォルト）
lock "~> 3.11.2"

# デプロイするアプリケーションの名前と参照するGithubの設定
set :application, "shugo"
set :repo_url, "git@example.com:igatake/shugo.git"

# デプロイをするフォルダの指定
set :deploy_to, "/var/www/rails/shugo"

# シンボリックリンクをはるフォルダ
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets','public/packs','node_modules', 'vendor/bundle', 'public/system')

# 過去にリリースしたアプリケーションをキープする数（デフォルトは5）
set :keep_releases, 2

# rubyのバージョン
set :rbenv_ruby, '2.6.5'

#出力するログのレベル。
set :log_level, :debug

# デプロイの手順の設定（Rails6からyarnインストールが必要に）
namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  desc 'Create database'
  task :db_create do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:create'
        end
      end
    end
  end
before "deploy:assets:precompile", "deploy:yarn_install"
namespace :deploy do
  desc "Run rake yarn install"
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install --silent --no-progress --no-audit --no-optional")
      end
    end
  end
end

after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end