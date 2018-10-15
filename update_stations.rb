require 'net/http'
require 'uri'
require 'nokogiri'

`open https://data.cityofchicago.org/Transportation/CTA-System-Information-List-of-L-Stops/8pix-ypme`
print 'Enter XML file URL (from Export): ' ; STDOUT.flush

file = STDIN.gets.chomp
contents = Net::HTTP.get(URI.parse(file))
doc = Nokogiri::XML(contents)

Station = Struct.new(:id, :name, :desc_name, :lines, :latitude, :longitude)
id_station_map = {}
name_counts = {}

doc.css('row').each do |row|
  id   = row.at_css('map_id').content.to_i
  next if id_station_map.has_key?(id)

  name = row.at_css('station_name').content
  desc_name = row.at_css('station_descriptive_name').content
  lines = desc_name.gsub(/^.+\((.+ Lines?).*\)$/, '\1')
  location = row.at_css('location')
  latitude = location['latitude']
  longitude = location['longitude']
  station = Station.new(id, name, desc_name, lines, latitude, longitude)
  id_station_map[id] = station

  name_counts[name] ||= 0
  name_counts[name] += 1
end

lines = {'Red' => [], 'Blue' => [], 'Brown' => [], 'Green' => [], 'Orange' => [], 'Purple' => [], 'Pink' => [], 'Yellow' => []}
stations = id_station_map.values.sort_by { |station| station.desc_name }
new_file = <<SWIFT
struct Station {
    var id: Int
    var name: String
    var title: String
    var subtitle: String
    var latitude: Double
    var longitude: Double
}

class CTA {
    // last updated #{Time.now.strftime('%m-%d-%Y')}
    static let stations = [
SWIFT

stations.each do |station|
  name = name_counts[station.name] > 1 ? station.desc_name : station.name
  new_file << "        #{station.id}: Station(id: #{station.id}, name: \"#{name}\", title: \"#{station.name}\", " +
              "subtitle: \"#{station.lines}\", latitude: #{station.latitude}, longitude: #{station.longitude}),\n"

  lines.each do |line, stations|
    stations << station.id if station.desc_name.include?(line)
  end
end

new_file = new_file[0..-3] # remove the trailing comma and new line
new_file << "\n    ]\n\n"

lines.each do |line, stations|
  new_file << "    static let #{line.downcase}LineStations = [#{stations.join(', ')}]\n"
end

new_file << "}\n"

File.open('Rail Line/CTA.swift', 'w') { |f| f.write(new_file) }
