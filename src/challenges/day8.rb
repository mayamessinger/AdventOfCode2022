require_relative 'helper'

module Challenges
    class Day8
        include Helper
    
        def main
            puts get_visible_trees
        end

        def get_visible_trees
            trees = get_trees
            columns = trees.transpose

            visible_trees = 0
            for i in 0..trees.length - 1
                for j in 0..trees[i].length - 1
                    visible_trees += 1 if visible(trees, columns, i, j)
                end
            end

            visible_trees
        end

        def visible(trees, columns, i, j)
            at_edge(trees, i, j) || visible_from_column(columns[j], i) || visible_from_side(trees[i], j)
        end

        def at_edge(trees, i, j)
            i == 0 || i == trees.length - 1 || j == 0 || j == trees[i].length - 1
        end

        def visible_from_column(jthColumn, i)
            hidden_from_above = false
            hidden_from_below = false

            for k in 0..i - 1
                if jthColumn[k] >= jthColumn[i]
                    hidden_from_above = true
                end
            end
            for k in i + 1..jthColumn.length - 1
                if jthColumn[k] >= jthColumn[i]
                    hidden_from_below = true
                end
            end

            !hidden_from_above || !hidden_from_below
        end

        def visible_from_side(ithRow, j)
            hidden_from_left = false
            hidden_from_right = false

            for k in 0..j - 1
                if ithRow[k] >= ithRow[j]
                    hidden_from_left = true
                end
            end
            for k in j + 1..ithRow.length - 1
                if ithRow[k] >= ithRow[j]
                    hidden_from_right = true
                end
            end

            !hidden_from_left || !hidden_from_right
        end

        def get_trees
            trees = []

            tree_lines = read_file("./resources/day8.txt")
            tree_lines.each do |line|
                trees.push(line.split("").map(&:to_i))
            end

            trees
        end
    end
end

Challenges::Day8.new.main