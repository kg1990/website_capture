MongoMapper.setup({
  'production' => {
  'hosts' => ['localhost:27017']
  }}, 'production', :read_secondary => false, :pool_size => 5, :pool_timeout => 5)

Sidekiq.configure_server do |config|
  # config.redis = { :namespace => 'manage', :url => "redis://#{REDIS_HOST}:#{REDIS_PORT}/4" }
  #config.redis = ConnectionPool.new(:size => 2, :timeout => 30) do
   # Redis.new(:host => REDIS_HOST, :port => REDIS_PORT, :db => 4)
  #end
  #config.error_handlers << Proc.new {|ex,ctx_hash| Airbrake.notify(ex) }
end

Sidekiq.configure_client do |config|
  #config.redis = ConnectionPool.new(:size => 1, :timeout => 30) do
  #  Redis.new(:host => REDIS_HOST, :port => REDIS_PORT, :db => 4)
  #end
  # config.redis = { :namespace => 'manage', :url => "redis://#{REDIS_HOST}:#{REDIS_PORT}/4" }
end