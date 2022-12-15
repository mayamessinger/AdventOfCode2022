require 'csv'
require_relative 'helper'

module Challenges
    class Day14
        include Helper
    
        def main
            puts units_to_overflow
        end

        def units_to_overflow
            cave, x_min, max_y = parse_cave

            units_dropped = 0
            while true
                break if drop_sand(cave, 500 - x_min, max_y)
                units_dropped += 1
            end

            units_dropped
        end

        def drop_sand(cave, sand_x, max_y)
            x = sand_x
            y = 0

            while true
                if y > max_y
                    return true
                end

                if cave[x][y + 1] == nil
                    y += 1
                    next
                elsif cave[x - 1][y + 1] == nil
                    x -= 1
                    y += 1
                    next
                elsif cave[x + 1][y + 1] == nil
                    x += 1
                    y += 1
                    next
                end

                break
            end

            cave[x][y] = "O"
            false
        end

        def parse_cave
            rock_segments = []
            rock_structures = read_file("./resources/day14.txt")
            for line in rock_structures
                segments = CSV.parse(line, col_sep: " -> ")[0]
                for s in 0..segments.length - 2
                    start_coords = segments[s].split(",")
                    end_coords = segments[s + 1].split(",")
                    rock_segments.push(RockSegment.new(start_coords[0].to_i, start_coords[1].to_i, end_coords[0].to_i, end_coords[1].to_i))
                end
            end

            map_cave(rock_segments)
        end

        def map_cave(rock_segments)
            cave = Array.new()

            max_y = find_max_y(rock_segments)
            min_x, max_x = find_x_extremes(rock_segments)
            for i in 0..max_x - min_x
                cave[i] = Array.new() {"."}
            end

            for segment in rock_segments
                if segment[:start_x] == segment[:end_x]
                    for y in segment[:start_y]..segment[:end_y]
                        cave[segment[:start_x] - min_x][y] = "#"
                    end
                else
                    for x in segment[:start_x]..segment[:end_x]
                        cave[x - min_x][segment[:start_y]] = "#"
                    end
                end
            end

            return cave, min_x, max_y
        end

        def find_x_extremes(rock_segments)
            x_vals = rock_segments.map { |segment| segment[:start_x] }
            x_vals = x_vals.union(rock_segments.map { |segment| segment[:end_x] })
            return x_vals.min, x_vals.max
        end

        def find_max_y(rock_segments)
            y_vals = rock_segments.map { |segment| segment[:start_y] }
            y_vals = y_vals.union(rock_segments.map { |segment| segment[:end_y] })
            return y_vals.max
        end
    end

    RockSegment = Struct.new(:start_x, :start_y, :end_x, :end_y) do
        def initialize(x1, y1, x2, y2)
            self.start_x = [x1, x2].min
            self.start_y = [y1, y2].min
            self.end_x = [x1, x2].max
            self.end_y = [y1, y2].max
        end
    end
end

Challenges::Day14.new.main