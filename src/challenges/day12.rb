require 'set'
require_relative 'helper'

module Challenges
    class Day12
        include Helper
    
        def main
            puts most_efficient_path_steps

            puts most_efficient_path_steps_all_starts
        end

        def most_efficient_path_steps
            heightmap, my_location, goal_location = get_heightmap
            
            find_best_path(heightmap, my_location, goal_location).length - 1
        end

        def most_efficient_path_steps_all_starts
            heightmap, _, goal_location = get_heightmap
            starts = get_possible_starts(heightmap)

            best_path_length = 2000000000
            for start in starts
                path = find_best_path(heightmap, start, goal_location)
                if path
                    best_path_length = path.length - 1 if path.length - 1 < best_path_length
                end
            end

            best_path_length
        end

        def get_heightmap
            heightmap = []
            my_location = nil
            goal_location = nil

            map_lines = read_file("./resources/day12.txt")
            map_lines.each_with_index do |line, index|
                elevations = line.split("")
                my_location = [index, elevations.index("S")] if elevations.include?("S")
                goal_location = [index, elevations.index("E")] if elevations.include?("E")

                heightmap.push(elevations)
            end

            return heightmap, my_location, goal_location
        end

        def get_possible_starts(heightmap)
            starts = []

            heightmap.each_with_index do |row, row_index|
                row.each_with_index do |value, column_index|
                    if value == "S" || value == "a"
                        starts.push([row_index, column_index])
                    end
                end
            end

            starts
        end

        def find_best_path(heightmap, my_location, goal_location)
            open_set = Set.new
            open_set.add(my_location)

            came_from = {}

            g_score = {}
            g_score[my_location] = 0

            f_score = {}
            f_score[my_location] = heuristic(get_value(my_location, heightmap))

            while open_set.length > 0
                current = open_set.min_by { |location| f_score[location] }
                if current == goal_location
                    return reconstruct_path(came_from, current)
                end

                open_set.delete(current)
                get_neighbors(heightmap, current).each do |neighbor|
                    tentative_g_score = g_score[current] + 1

                    if !g_score[neighbor] || tentative_g_score < g_score[neighbor]
                        came_from[neighbor] = current
                        g_score[neighbor] = tentative_g_score
                        f_score[neighbor] = tentative_g_score + heuristic(get_value(neighbor, heightmap))
                        open_set.add(neighbor)
                    end
                end
            end

            nil
        end

        def reconstruct_path(came_from, current)
            total_path = [current]
            while came_from[current]
                current = came_from[current]
                total_path.push(current)
            end

            total_path
        end

        def get_neighbors(heightmap, location)
            neighbors = []
            
            for i in -1..1
                for j in -1..1
                    if (i == 0 && j == 0) || (i != 0 && j != 0)
                        next
                    end

                    if (location[0] + i >= 0 && location[0] + i < heightmap.length && location[1] + j >= 0 && location[1] + j < heightmap[0].length)
                        if can_visit heightmap[location[0]][location[1]], heightmap[location[0] + i][location[1] + j]
                            neighbors.push([location[0] + i, location[1] + j])
                        end
                    end
                end
            end

            neighbors
        end

        def get_value(location, heightmap)
            heightmap[location[0]][location[1]]
        end

        def heuristic(start_value)
            return "z".ord - start_value.ord
        end

        def can_visit(start, destination)
            start = "a" if start == "S"
            start = "z" if start == "E"
            destination = "a" if destination == "S"
            destination = "z" if destination == "E"

            return (destination.ord - start.ord) <= 1
        end
    end
end

Challenges::Day12.new.main