# frozen_string_literal: true

module QueryHelper
  RemoveSpaces = ->(value) { value.delete(" \t\r\n") }
end
