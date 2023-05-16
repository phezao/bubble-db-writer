# frozen_string_literal: true

module BubbleRuby
  module DB::Record::Format
    IsBubbleIdOrString = ->(value) { value.match?(/\d{13}x\d{18}/) || value.is_a?(String) }
    CleanString = ->(value) { value.gsub(/'/, ' ').gsub(/"/, '%') }
    IsDate = ->(value) { value.match?(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z/) }

    def self.call(value)
      return value                                        if value.is_a?(Integer)
      return value                                        if value.is_a?(TrueClass)
      return value                                        if value.is_a?(FalseClass)
      return value                                        if value.is_a?(Float)
      return "\'{#{value.join(', ')}}\'"                  if value.is_a?(Array)
      return "\'#{value.to_json.gsub(/'/, ' ')}\'"        if value.is_a?(Hash) || value.nil?
      return "\'#{value}\'"                               if IsDate[value]
      return "\'#{CleanString[value]}\'"                  if IsBubbleIdOrString[value]
    end
  end
end
