require "csv"

# Base class for all export services.
# Subclasses must implement: csv_headers, csv_row, json_record
class BaseExportService
  def self.csv_headers
    raise NotImplementedError, "#{name} must implement csv_headers"
  end

  def self.csv_row(record)
    raise NotImplementedError, "#{name} must implement csv_row"
  end

  def self.json_record(record)
    raise NotImplementedError, "#{name} must implement json_record"
  end

  def self.to_csv(records)
    CSV.generate(headers: true) do |csv|
      csv << csv_headers
      records.each { |record| csv << csv_row(record) }
    end
  end

  def self.to_json(records)
    records.map { |record| json_record(record) }.to_json
  end
end
