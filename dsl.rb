require 'csv'

module CSVImport
  def self.from_file(filepath)
    schema = Schema.new
    yield schema
    Importer.new(schema).import(filepath)
  end

  class Schema
    attr_reader :columns
    Column = Struct.new(:name, :col_number, :type)

    def initialize
      @columns = []
    end

    def string(name, column:)
      @columns << Column.new(name, column, ->(x) { x.to_s })
    end

    def integer(name, column:)
      @columns << Column.new(name, column, ->(x) { x.to_i })
    end

    def decimal(name, column:)
      @columns << Column.new(name, column, ->(x) { x.to_f })
    end
  end

  class Importer
    attr_reader :schema

    def initialize(schema)
      @schema = schema
    end

    def import(filepath)
      rows = CSV.read(filepath, col_sep: ';')
      process(rows)
    end

    private

    def process(rows)
      rows.map { |row| process_row(row) }
    end

    def process_row(row)
      obj = {}
      @schema.columns.each do |col|
        obj[col.name] = col.type.call(row[col.col_number - 1])
      end
      obj
    end
  end
end

records = CSVImport.from_file('people.csv') do |config|
  config.string :first_name, column: 1
  config.string :last_name, column: 2
  config.integer :age, column: 4
  config.decimal :salary, column: 5
end
puts records
