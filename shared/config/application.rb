# frozen_string_literal: true

require 'aws-sdk-ssm'

if ENV.fetch('ENVIRONMENT', 'local') != 'local' && ENV.fetch('DISABLE_LOG', 'false') == 'false'
  # XRAY_LAMBDA_PATCH_CONFIG = []
  require 'aws-xray-sdk/lambda'
end

require_relative '../lib/logging/json_formatter'

module Config
  class Application
    def self.environment
      @@environment ||= nil
    end

    def self.production?
      @@environment == :production
    end

    def self.staging?
      @@environment == :staging
    end

    def self.development?
      @@environment == :development
    end

    def self.local?
      @@environment == :local
    end

    def self.test?
      @@environment == :test
    end

    def self.disable_log
      @@disable_log ||= nil
    end

    def self.disable_log?
      @@disable_log == 'true'
    end

    def self.logger
      @@logger ||= nil
    end

    def self.load
      @@environment = ENV['ENVIRONMENT'].to_sym
      @@disable_log = ENV.fetch('DISABLE_LOG', 'false')
      @@logger = Logger.new($stdout, formatter: Lib::Logging::JsonFormatter.new)
    end
  end
end
