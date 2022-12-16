require 'Set'
require_relative 'helper'

module Challenges
    class Day15
        include Helper
    
        def main
            puts count_impossible_beacon_spaces 2000000
        end

        def count_impossible_beacon_spaces(row)
            sensors, beacons = parse_sensors_and_beacons

            sensor_coverage_cols = Set.new
            for sensor in sensors
                sensor_leeway = sensor.beacon_distance - (sensor.y - row).abs
                sensor_coverage_cols.merge(sensor.x - sensor_leeway..sensor.x + sensor_leeway)
            end

            for beacon in beacons
                if beacon.y == row
                    sensor_coverage_cols.delete(beacon.x)
                end
            end

            return sensor_coverage_cols.size
        end

        def parse_sensors_and_beacons
            beacons = []
            sensors = []

            lines = read_file("./resources/day15.txt")
            for line in lines
                regex = /Sensor at x=(-?[0-9]+), y=(-?[0-9]+): closest beacon is at x=(-?[0-9]+), y=(-?[0-9]+)/
                if matches = line.match(regex)
                    beacon = beacons.find { |beacon| beacon.x == matches[3].to_i && beacon.y == matches[4].to_i }
                    if beacon.nil?
                        beacon = Beacon.new(matches[3].to_i, matches[4].to_i)
                        beacons << beacon
                    end

                    sensors << Sensor.new(matches[1].to_i, matches[2].to_i, beacon)
                end
            end

            return sensors, beacons
        end
    end

    class Sensor
        include Challenges

        attr_accessor :x, :y, :beacon_distance

        def initialize(x, y, beacon)
            @x = x
            @y = y
            @beacon_distance = manhattan_distance(x, y, beacon.x, beacon.y)
        end

        private def manhattan_distance(x1, y1, x2, y2)
            (x1 - x2).abs + (y1 - y2).abs
        end
    end

    class Beacon
        attr_accessor :id, :x, :y

        def initialize(x, y)
            @x = x
            @y = y
        end
    end
end

Challenges::Day15.new.main