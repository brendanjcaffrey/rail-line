require 'net/http'
require 'uri'
require 'nokogiri'

`open https://data.cityofchicago.org/Transportation/CTA-System-Information-List-of-L-Stops/8pix-ypme`
print 'Enter XML file URL (from Export): ' ; STDOUT.flush

file = STDIN.gets.chomp
contents = Net::HTTP.get(URI.parse(file))
doc = Nokogiri::XML(contents)

Station = Struct.new(:id, :name, :desc_name, :latitude, :longitude)
id_station_map = {}
name_counts = {}

doc.css('row').each do |row|
  id   = row.at_css('map_id').content.to_i
  next if id_station_map.has_key?(id)

  name = row.at_css('station_name').content
  desc_name = row.at_css('station_descriptive_name').content
  location = row.at_css('location')
  latitude = location['latitude']
  longitude = location['longitude']
  station = Station.new(id, name, desc_name, latitude, longitude)
  id_station_map[id] = station

  name_counts[name] ||= 0
  name_counts[name] += 1
end

stations = id_station_map.values.sort_by { |station| station.desc_name }
new_file = "Station = Struct.new(:id, :name, :latitude, :longitude)
class CTAInfo
  class << self ; attr_reader :stations ; end

  # last updated #{Time.now.strftime('%m-%d-%Y')}
  @stations = {"


stations.each do |station|
  name = name_counts[station.name] > 1 ? station.desc_name : station.name
  new_file << "\n    #{station.id} => Station.new(#{station.id}, \"#{name}\", #{station.latitude}, #{station.longitude}),"
end

new_file = new_file[0..-2] # remove the trailing comma
new_file << "\n  }\nend\n"

File.open('app/cta_info.rb', 'w') { |f| f.write(new_file) }
