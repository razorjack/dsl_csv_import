require 'faker'
require 'csv'

CSV.open('people.csv', 'w', col_sep: ';') do |csv|
  50.times do
    row = [
      Faker::Name.first_name,
      Faker::Name.last_name,
      Faker::Name.title,
      (24..70).to_a.sample,
      (35_000..120_000).to_a.sample.round(-2),
      Faker::Company.name
    ]
    csv << row
  end
end
