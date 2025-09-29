require 'json'
Dir["lib/*.rb"].each {|file| require_relative file }

# verify arguments passed are either a file path or the help flag (-h)
if ARGV.size == 0 || ARGV.include?('-h')
  puts "Usage: ruby reimburse.rb [-h | -verbose] [projects_json_file]"
  puts "e.g. bundle exec ruby reimburse.rb -verbose examples/sample1.json"
  puts
  puts "-h:\t\t\tShows this message."
  puts "-verbose:\t\tShow verbose listing of reimbursement."
  puts "projects_json_file:\tPath to a JSON file that describes the projects to be reimbursed."
  puts "\t\t\te.g."
  puts "\t\t\t{"
  puts "\t\t\t  \"projects\" : ["
  puts "\t\t\t    {\"start_date\" : \"10/01/2024\", \"end_date\" : \"10/03/2024\", \"cost\" : \"high\"},"
  puts "\t\t\t    ...,"
  puts "\t\t\t  ]"
  puts "\t\t\t}"
  
  exit
end

# Load the json file
json = JSON.load_file(ARGV.last, { symbolize_names: true })
raise "Invalid JSON File: Missing projects" unless json[:projects].is_a?(Array) && json[:projects].size > 0

# build the projects
projects = []
json[:projects].each_with_index do |project_details, index|
  raise "Invalid JSON File: invalid project(#{index})" unless project_details.is_a?(Hash)

  begin
    [:start_date, :end_date].each do |key|
      raise "Invalid #{key}" unless project_details[key] =~ /\d\d\/\d\d\/\d\d\d\d/
    end
    start_date = Date.strptime(project_details[:start_date], '%m/%d/%Y')
    end_date = Date.strptime(project_details[:end_date], '%m/%d/%Y')
    projects << Project.new(start_date, end_date, project_details[:cost])
  rescue => e
    raise "Invalid JSON File: invalid project(#{index}) - #{e.message}"
    exit
  end
end

# calculate the reimbursement
reimbursement = Reimbursement.new(projects)

# display results
if ARGV.include?('-verbose')
  puts "Date, City Cost, Day Type, Rate for Day"
  reimbursement.by_date.keys.sort.each do |key|
    day = reimbursement.by_date[key]
    puts [key, day[:cost], day[:day_type], day[:rate]].join(", ")
  end
end
puts
puts "Total Reimbursement: #{reimbursement.total}"