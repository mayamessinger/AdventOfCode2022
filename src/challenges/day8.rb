require_relative 'helper'

module Challenges
    class Day8
        include Helper
    
        def main
            puts get_visible_trees

            puts get_best_scenic_score
        end

        def get_visible_trees
            trees = @trees || get_trees
            columns = trees.transpose

            visible_trees = 0
            for i in 0..trees.length - 1
                for j in 0..trees[i].length - 1
                    visible_trees += 1 if at_edge(trees, i, j) || visible(trees[i], columns[j], i, j)
                end
            end

            visible_trees
        end

        def get_best_scenic_score
            trees = @trees || get_trees
            columns = trees.transpose

            best_scenic_score = 0
            for i in 0..trees.length - 1
                for j in 0..trees[i].length - 1
                    scenic_score = get_scenic_score(trees[i], columns[j], i, j)
                    if scenic_score > best_scenic_score
                        best_scenic_score = scenic_score
                    end
                end
            end

            best_scenic_score
        end

        def get_scenic_score(row, column, i, j)
            left_score, _, right_score, _ = slice_score(row, j)
            above_score, _, below_score, _ = slice_score(column, i)

            return left_score * right_score * above_score * below_score
        end

        def slice_score(slice, index)
            before_score = 0
            before_reached_end = false
            after_score = 0
            after_reached_end = false

            (index - 1).downto(0) do |k|
                if slice[k] >= slice[index]
                    before_score = index - k
                    break
                end
            end
            if before_score == 0
                before_score = index
                before_reached_end = true
            end
            for k in index + 1..slice.length - 1
                if slice[k] >= slice[index]
                    after_score = k - index
                    break
                end
            end
            if after_score == 0
                after_score = slice.length - index - 1
                after_reached_end = true
            end

            return before_score, before_reached_end, after_score, after_reached_end
        end

        def at_edge(trees, i, j)
            i == 0 || i == trees.length - 1 || j == 0 || j == trees[i].length - 1
        end

        def visible(row, column, i, j)
            visible_from_slice(column, i) || visible_from_slice(row, j)
        end

        def visible_from_slice(slice, index)
            _, bre, _, are = slice_score(slice, index)

            bre || are
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