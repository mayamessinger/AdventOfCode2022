require 'set'
require_relative 'helper'

module Challenges
    class Day9
        include Helper
    
        def main
            puts get_tail_visited_count
        end

        def get_tail_visited_count
            steps = get_steps
            visited = get_visited(steps)
            
            visited.count
        end

        def get_steps
            steps = []

            step_lines = read_file("./resources/day9.txt")
            step_lines.each do |line|
                dir, dist = line.split(" ")
                steps.push(Step.new(dir, dist.to_i))
            end

            steps
        end

        def get_visited(steps)
            visited = Set.new

            head_location = Point.new(0, 0)
            tail_location = Point.new(0, 0)
            visited.add("#{tail_location.x}.#{tail_location.y}")
            
            for step in steps
                for i in 1..step[:distance]
                    update_head_location(head_location, Step.new(step[:direction], 1))
                    update_tail_location(head_location, tail_location)

                    visited.add("#{tail_location.x}.#{tail_location.y}")
                end
            end

            visited
        end

        def update_head_location(head_location, step)
            case step[:direction]
            when Directions::L
                head_location.x -= step[:distance]
            when Directions::R
                head_location.x += step[:distance]
            when Directions::U
                head_location.y += step[:distance]
            when Directions::D
                head_location.y -= step[:distance]
            end
        end

        def update_tail_location(head_location, tail_location)
            diff_x, diff_y = head_location.x - tail_location.x, head_location.y - tail_location.y

            move_x, move_y = 0, 0
            if diff_x.abs > 1
                difference = head_location.x - tail_location.x
                move_x = difference.positive? ? difference - 1 : difference + 1

                if diff_y.abs > 0
                    move_y = head_location.y - tail_location.y
                end
            elsif diff_y.abs > 1
                difference = head_location.y - tail_location.y
                move_y = difference.positive? ? difference - 1 : difference + 1

                if diff_x.abs > 0
                    move_x = head_location.x - tail_location.x
                end
            end
            tail_location.x += move_x
            tail_location.y += move_y
        end
    end

    Step = Struct.new(:direction, :distance) do
        def initialize(direction, distance)
            self.direction = direction
            self.distance = distance
        end
    end

    Point = Struct.new(:x, :y) do
        def initialize(x, y)
            self.x = x
            self.y = y
        end
    end

    module Directions
        Dummy = "DUMMY",
        # I have no clue why, but the first variable isn't recognized so I have a useless first variable
        # for the first variable, step[:direction] == "<string>" is true, but step[:direction] == Directions::<variable> is false
        L = "L",
        R = "R",
        U = "U",
        D = "D"
    end
end

Challenges::Day9.new.main