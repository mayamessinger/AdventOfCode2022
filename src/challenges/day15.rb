require 'Set'
require_relative 'helper'

module Challenges
    class Day15
        include Helper
    
        def main
            puts count_impossible_beacon_spaces 2000000

            puts get_distress_tuning_frequency 0, 4000000
        end

        def count_impossible_beacon_spaces(row)
            sensors, beacons = parse_sensors_and_beacons
            impossible_beacon_ranges(row, sensors, beacons).map { |range| range[1] - range[0] + 1 }.sum
        end

        def impossible_beacon_ranges(row, sensors, beacons, low_limit = nil, high_limit = nil)
            coverages = get_coverage(row, sensors, beacons, low_limit, high_limit)
            
            for beacon in beacons
                if beacon.y == row
                    containing_coverage = coverages.find { |coverage| coverage[0] <= beacon.x && coverage[1] >= beacon.x }
                    if !containing_coverage.nil?
                        coverages.delete(containing_coverage)
                        coverages.push([containing_coverage[0], beacon.x - 1]) unless containing_coverage[0] == beacon.x
                        coverages.push([beacon.x + 1, containing_coverage[1]]) unless containing_coverage[1] == beacon.x
                    end
                end
            end

            coverages
        end

        def get_distress_tuning_frequency(low_limit, high_limit)
            sensors, beacons = parse_sensors_and_beacons

            for row in low_limit..high_limit
                sensor_coverage_ranges = get_coverage(row, sensors, beacons, low_limit, high_limit)
                if sensor_coverage_ranges.length != 1 # if there is only one range, it is the whole row. else there are 2 ranges with a gap of a single space between
                    sorted_ranges = sensor_coverage_ranges.sort_by! { |range| range[0] }
                    y = sorted_ranges[0][1] + 1 # the beacon must be in the gap between the two ranges
                    return y * 4000000 + row
                end
            end
        end

        def get_coverage(row, sensors, beacons, low_limit, high_limit)
            sensor_coverage_ranges = sensor_covered_ranges(row, sensors, beacons, low_limit, high_limit)
             
            combine_ranges(sensor_coverage_ranges)
        end

        def combine_ranges(ranges)
            coverages = []
            
            for range in ranges
                if coverages.empty?
                    coverages.push(range)
                    next
                end

                overlap = false
                for coverage in coverages
                    # start before and end in or after, extend coverage before
                    if range[0] <= coverage[0]
                        if range[1] >= coverage[0]
                            coverage[0] = range[0]
                            overlap = true
                        end
                    end
                    # if start before or at and end after, extend coverage after
                    if range[0] <= coverage[1]
                        if range[1] > coverage[1]
                            coverage[1] = range[1]
                            overlap = true
                        end
                    end
                    # if fully contained, ignore
                    if range[0] >= coverage[0] && range[1] <= coverage[1]
                        overlap = true
                    end
                end

                coverages.push(range) unless overlap
            end

            # keep combining until no more overlaps
            coverages = combine_ranges(coverages) if coverages.length != ranges.length

            coverages
        end

        def sensor_covered_ranges(row, sensors, beacons, low_limit = nil, high_limit = nil)
            sensor_coverage_ranges = []
            for sensor in sensors
                sensor_leeway = sensor.beacon_distance - (sensor.y - row).abs
                next if sensor_leeway < 0
                range_low, range_high = exclude_outside_frame(sensor.x - sensor_leeway, sensor.x + sensor_leeway, low_limit, high_limit)
                sensor_coverage_ranges.push([range_low, range_high])
            end

            sensor_coverage_ranges
        end

        def exclude_outside_frame(set_low, set_high, low_limit, high_limit)
            return [low_limit ||= set_low, set_low].max, [high_limit ||= set_high, set_high].min
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