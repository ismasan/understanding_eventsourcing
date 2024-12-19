# frozen_string_literal: true

require 'zeitwerk'
require 'logger'
require 'sourced'
require 'sequel'
require 'dotenv'
Dotenv.load '.env'

CODE_LOADER = Zeitwerk::Loader.new

CODE_LOADER.push_dir("#{__dir__}/domain")
CODE_LOADER.setup

$LOAD_PATH.unshift File.dirname(__FILE__)

if ENV['ENVIRONMENT'] != 'test'
  if (db_url = ENV['DATABASE_URL'])
    Sourced.configure do |config|
      config.backend = Sequel.connect(db_url)
    end
    Sourced.config.logger.info 'Using database backend'
    Sourced.config.backend.install
  else
    Sourced.config.logger.warn 'No DATABASE_URL found, using in-memory backend'
  end
end
