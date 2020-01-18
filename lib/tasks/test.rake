namespace :test do
  task erd: :environment do
    Zeitwerk::Loader.eager_load_all
    Rake::Task['erd'].invoke
  end
end
