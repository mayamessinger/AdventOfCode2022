require_relative 'helper'

module Challenges
    class Day16
        include Helper
    
        def main
            puts avoid_eruption
        end

        def avoid_eruption
            valves = get_valves
            get_max_pressure_released(valves.find {|v| v.name == "AA" }, valves, 30, 0, 0)
        end

        def get_max_pressure_released(valve, valves, time_left, total_pressure_released, pressure_being_released)
            return total_pressure_released if time_left == 0 # spent last minute getting here
            return total_pressure_released + pressure_being_released if time_left == 1 # can't make any effective changes in only 1 minute, but can pass the minute

            pressures_released_from_connected_valves = []
            
            connected_valves = valves.select { |v| valve.connected_valve_names.include?(v.name) }
            connected_valves.each do |cv|
                unless cv.is_open || cv.name == "AA"
                    # make copy and open in that data structure
                    valves_clone = clone_valves(valves)
                    cv_clone = valves_clone.find {|v| v.name == cv.name }
                    cv_clone.is_open = true

                    pressures_released_from_connected_valves << get_max_pressure_released(cv_clone, valves_clone, time_left - 2, total_pressure_released + pressure_being_released * 2, pressure_being_released + cv_clone.flow_rate)
                end

                pressures_released_from_connected_valves << get_max_pressure_released(cv, valves, time_left - 1, total_pressure_released + pressure_being_released, pressure_being_released)
            end

            return pressures_released_from_connected_valves.max
        end

        def get_valves
            valves = []

            valve_lines = read_file("./resources/day16.txt")
            valve_lines.each do |line|
                regex = /Valve ([A-Z]+) has flow rate=([0-9]+); tunnels? leads? to valves? ((?:[A-Z+]+,? ?)+)/
                if matches = line.match(regex)
                    name = matches[1]
                    flow_rate = matches[2].to_i
                    connected_valve_names = matches[3].split(", ")

                    valves << Valve.new(name, flow_rate, connected_valve_names)
                end
            end

            valves
        end

        def clone_valves(valves)
            valves.map(&:clone)
        end
    end

    class Valve
        attr_accessor :name, :flow_rate, :is_open, :connected_valve_names

        def initialize(name, flow_rate, is_open = false, connected_valve_names)
            @name = name
            @flow_rate = flow_rate
            @is_open = is_open
            @connected_valve_names = connected_valve_names
        end

        def clone
            Valve.new(@name, @flow_rate, @is_open, @connected_valve_names.clone)
        end
    end
end

Challenges::Day16.new.main