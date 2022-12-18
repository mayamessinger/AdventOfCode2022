require 'Set'
require_relative 'helper'

module Challenges
    class Day16
        include Helper
    
        def main
            puts avoid_eruption
        end

        def avoid_eruption
            valves = get_valves

            @best_total_pressure_released_per_minute = []
            populate_pressure_released_table(valves.find {|v| v.name == "AA" }, valves, 30, 0, 0)

            puts @best_total_pressure_released_per_minute[0]
        end

        def populate_pressure_released_table(valve, valves, time_left, total_pressure_released, pressure_being_released)
            if @best_total_pressure_released_per_minute[time_left].nil? || total_pressure_released > @best_total_pressure_released_per_minute[time_left]
                @best_total_pressure_released_per_minute[time_left] = total_pressure_released
            else
                # don't spend effort pursuing paths that likely aren't going to result in better outcome
                if total_pressure_released < (@best_total_pressure_released_per_minute[time_left + 2])
                    return
                end
            end

            if time_left == 0
                return
            elsif time_left == 1
                @best_total_pressure_released_per_minute[time_left] = [@best_total_pressure_released_per_minute[time_left], total_pressure_released + pressure_being_released].max
                return
            end
            
            if valves.all? {|v| v.is_open || v.flow_rate == 0 }
                @best_total_pressure_released_per_minute[0] = [@best_total_pressure_released_per_minute[0], total_pressure_released + (pressure_being_released * time_left)].max
                return
            end
            
            connected_valves = valves.select { |v| valve.connected_valve_names.include?(v.name) }
            connected_valves.each do |cv|
                unless cv.is_open || cv.flow_rate == 0
                    valves_clone = clone_valves(valves)
                    cv_clone = valves_clone.find {|v| v.name == cv.name }
                    cv_clone.is_open = true

                    populate_pressure_released_table(cv_clone, valves_clone, time_left - 2, total_pressure_released + pressure_being_released * 2, pressure_being_released + cv_clone.flow_rate)
                end

                populate_pressure_released_table(cv, valves, time_left - 1, total_pressure_released + pressure_being_released, pressure_being_released)
            end

            @best_total_pressure_released_per_minute[time_left] = [@best_total_pressure_released_per_minute[time_left], total_pressure_released].max
            return
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

        def get_connected_valves(valves)
            valves.select { |v| @connected_valve_names.include?(v.name) }
        end
    end
end

Challenges::Day16.new.main