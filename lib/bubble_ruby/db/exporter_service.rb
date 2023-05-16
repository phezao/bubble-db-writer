# frozen_string_literal: true

require 'json'

module BubbleRuby
  # class ExporterService is responsible to export a file as json and rb
  class ExporterService
    def write(filename, data)
      if Dir.children('./').include?(filename)
        export_sequence_file(filename, data)
      else
        export_first_file(filename, data)
      end
    end

    def export_sequence_file(filename, data)
      last_file = Dir.children('./').select { |name| name.match?(/#{filename}\d*.rb/) }.last
      new_export_index = last_file[/#{filename}(.*?).rb/].to_i + 1
      File.write("#{filename + new_export_index}.rb", data)
      File.write("#{filename + new_export_index}.json", data.to_json)
    end

    def export_first_file(filename, data)
      File.write("#{filename}.json", data.to_json)
      File.write("#{filename}.rb", data)
    end

    alias overwrite export_first_file
  end
end
