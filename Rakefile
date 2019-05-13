$LOAD_PATH.unshift(File.expand_path('.', 'lib'))

require 'sql_migration_helper'
require 'standalone_migrations'

StandaloneMigrations::Tasks.load_tasks

ActiveRecord::Base.schema_format = ENV['SCHEMA_FORMAT']&.to_sym || :ruby
