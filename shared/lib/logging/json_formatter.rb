# frozen_string_literal: true

require 'logger'

module Lib
  module Logging
    class JsonFormatter < Logger::Formatter
      # :reek:UtilityFunction
      def call(severity, datetime, program_name, content)
        msg = content.is_a?(Hash) ? content : { content: content }
        "#{{ time: datetime.to_s,
             severity: severity.to_s,
             program_name: program_name }.merge(msg).compact.to_json}\n"
      end
    end
  end
end
