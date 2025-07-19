# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'joined'

line_ids = { 'red' => 'Red',
             'blue' => 'Blue',
             'brn' => 'Brown',
             'g' => 'Green',
             'o' => 'Orange',
             'p' => 'Purple',
             'pnk' => 'Pink',
             'y' => 'Yellow',
             'pexp' => 'Purple Express' }

`open https://data.cityofchicago.org/Transportation/CTA-System-Information-List-of-L-Stops/8pix-ypme`
print 'Enter XML file URL (from Export > API endpoint > JSON): '
$stdout.flush

file = $stdin.gets.chomp
contents = Net::HTTP.get(URI.parse(file))
stop_list = JSON.parse(contents)

Station = Struct.new(:id, :name, :desc_name, :lines, :latitude, :longitude)
id_station_map = {}
name_counts = {}

# NB: a station is made up of multiple stops
stop_list.each do |row|
  id = row['map_id']
  lines = Set.new
  line_ids.each do |key, value|
    lines.add(value) if row[key]
  end

  if id_station_map.key?(id)
    id_station_map[id].lines.merge(lines)
    next
  end

  name = row['station_name']
  desc_name = row['station_descriptive_name']
  latitude = row['location']['latitude']
  longitude = row['location']['longitude']
  station = Station.new(id, name, desc_name, lines, latitude, longitude)
  id_station_map[id] = station

  name_counts[name] ||= 0
  name_counts[name] += 1
end

stations_per_line = line_ids.map { |_k, v| [v, []] }.to_h
stations = id_station_map.values.sort_by(&:desc_name)
new_file = <<~SWIFT
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
  if station.lines.empty?
    puts "ERROR: Station #{station.id} (#{name}) has no lines associated with it, skipping"
    next
  end

  new_file << "        #{station.id}: Station(id: #{station.id}, name: \"#{name}\", title: \"#{station.name}\", " \
    "subtitle: \"#{station.lines.to_a.joined(last_word_connector: ' & ')} Line#{station.lines.size > 1 ? 's' : ''}\", " \
    "latitude: #{station.latitude}, longitude: #{station.longitude}),\n"

  stations_per_line.each do |line, line_stations|
    line_stations << station.id if station.lines.include?(line)
  end
end

new_file = new_file[0..-3] # remove the trailing comma and new line
new_file << "\n    ]\n\n"

stations_per_line.each do |line, line_stations|
  line_str = line.include?(' Express') ? line.downcase.gsub(' e', 'E') : line.downcase
  new_file << "    static let #{line_str}LineStations = [#{line_stations.join(', ')}]\n"
end

new_file << "}\n"

File.open('Rail Line/CTA.swift', 'w') { |f| f.write(new_file) }
