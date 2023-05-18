# frozen_string_literal: true

module BubbleRuby
  class DB::Record
    require_relative 'record/bubble'
    require_relative 'record/column'
    require_relative 'record/convert_value'
    require_relative 'record/format'
    require_relative 'record/update_query'

    attr_accessor :table_name, :column_name, :column_value, :bubble_id, :bubble_data_type

    def initialize(column:, bubble_id:, bubble_data_type:)
      self.table_name       = column.table_name
      self.column_name      = column.name
      self.column_value     = column.value
      self.bubble_id        = bubble_id
      self.bubble_data_type = bubble_data_type
    end
  end
end
