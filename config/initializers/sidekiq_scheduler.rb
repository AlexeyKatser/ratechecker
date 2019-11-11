require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq-scheduler'
require 'sidekiq-scheduler/web'

redis_url = 'redis://localhost:6379/0'
#if defined? Sidekiq
#	redis_url = ENV['REDIS_URL']
#end
Sidekiq::Extensions.enable_delay!

Sidekiq.configure_server do |config|
	config.redis = {url: redis_url}
  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file(File.expand_path("#{Rails.root}/config/sidekiq.yml", __FILE__))
    SidekiqScheduler::Scheduler.instance.reload_schedule!
    p 'scheduler started!'
  end
end

Sidekiq.configure_client do |config|
	config.redis = {url: redis_url}
end
