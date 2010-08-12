require 'action_view'

module JcheckRails
  module Encoder
    class << self
      include ActionView::Helpers::JavaScriptHelper
      
      def convert_to_javascript(object)
        return "true" if object == {}

        case object
          when Symbol, String
            "'#{escape_javascript object.to_s}'"
          when Regexp
            "/#{object.source}/#{regex_options_string(object.options)}"
          when Hash
            convert_hash(object)
          else
            raise ArgumentError.new("can't parse object type #{object.class}")
        end
      end

      def convert_hash(hash)
        hash_pairs = []

        hash.each do |k, v|
          hash_pairs << "#{convert_to_javascript(k)}: #{convert_to_javascript(v)}"
        end

        "{#{hash_pairs.join(", ")}}"
      end

      def regex_options_string(options)
        letters = [[1, "i"], [2, "x"], [4, "m"]]

        letters.inject("") do |acc, (v, l)|
          acc << l if (options & v) > 0
          acc
        end
      end
    end
  end
end