# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
# RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|on = {
    :session_key => '_siegfreud_session',
    :secret      => '96bb8a78448163d608007fe7429d20a72de0cea6e9bcdc2866ba610767fa73a48f982e385852bb4e36734c05eaeb7b78575880415029c11488913fe2094a960f'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # Please note that observers generated using script/generate observer need to have an _observer suffix
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  #	config.action_controller.relative_url_root = "/siegfreud"
  config.gem "prawn"
  config.gem(
    'thinking-sphinx',
    :lib     => 'thinking_sphinx',
    :version => '1.3.8'
  )
  config.gem 'rspec-rails', :lib => false
  config.gem 'rspec', :lib => false
  config.gem 'cucumber'
  config.gem 'webrat'
  config.gem 'authlogic'
  config.gem "declarative_authorization"
  
  config.action_controller.session = { :key => "_siegfreud_session", :secret => "96bb8a78448163d608007fe7429d20a72de0cea6e9bcdc2866ba610767fa73a48f982e385852bb4e36734c05eaeb7b78575880415029c11488913fe2094a960f" }
  if RAILS_ENV=='production'
    config.action_controller.relative_url_root = "/siegfreud"
  end
  
end
