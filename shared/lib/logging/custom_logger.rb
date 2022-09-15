# frozen_string_literal: true

require 'active_support'
require_relative './sanitizer'

module Lib
  module Logging
    class CustomLogger
      DEFAULT_LEVEL = :info
      LEVELS = %i[debug info warn error fatal].freeze
      EVENTS = {
        api_call_error: 'api_call_error',
        failed: 'failed',
        finished: 'finished',
        started: 'started'
      }.freeze

      define_method(:log_info) { |details| log(:info, details) }
      define_method(:log_warn) { |details| log(:warn, details) }
      define_method(:log_debug) { |details| log(:debug, details) }
      define_method(:log_fatal) { |details| log(:fatal, details) }

      def initialize(class_name:)
        @class_name = class_name
        @bc = backtrace_cleaner
        @logger = Lib::Configuration.config.logger
      end

      def log_request_event(event:, method:, resource:, payload:, http_code: nil)
        log_event(event: event, details: request_content(method, resource, payload, http_code))
      end

      def log_event(event:, details: {})
        content = details.merge(event: event, **generic_content)
        log(:info, content)
      end

      def log_error(error:, details: {})
        stacktrace = @bc.clean(error&.backtrace || []).join("\n")
        content = { event: EVENTS[:failed], error: stacktrace, details: details, **generic_content }
        log(:error, content)
      end

      private def log(level, content)
        return if Lib::Configuration.disable_log?

        determine_log_level(level)
          .then { |log_level| @logger.send(log_level, content) }
      end

      # :reek:FeatureEnvy
      private def request_content(method, resource, payload, http_code)
        content = {
          resource: resource,
          method: method,
          payload: Sanitizer.call(payload)
        }
        content[:http_code] = http_code if http_code.present?
        content.merge(generic_content)
      end

      private def generic_content
        { class_name: @class_name }
      end

      private def determine_log_level(level)
        level.to_sym.then { |symbol| LEVELS.include?(symbol) ? symbol : DEFAULT_LEVEL }
      end

      private def backtrace_cleaner
        bc = ActiveSupport::BacktraceCleaner.new
        # bc.add_filter { |line| line.gsub(Rails.root.to_s, '') }
        bc.add_silencer { |line| /puma|gems/.match?(line) }
        bc
      end
    end
  end
end
