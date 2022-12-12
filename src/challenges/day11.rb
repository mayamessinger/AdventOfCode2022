require 'set'
require_relative 'helper'

module Challenges
    class Day11
        include Helper
    
        def main
            puts get_most_active_monkeys 20
        end

        def get_most_active_monkeys(rounds)
            monkeys = get_monkeys

            for i in 0..rounds - 1
                monkeys.each do |monkey|
                    monkey.items.each do |item|
                        new_worry, recipient = monkey.throw_item(item)
                        monkeys[recipient].items.push(new_worry)
                    end
                    monkey.items = []
                end
            end

            activity = monkeys.map(&:inspected_items).sort.reverse
            activity[0] * activity[1]
        end

        def get_monkeys
            monkeys = []

            file_lines = read_file("./resources/day11.txt")
            monkey = nil
            file_lines.each do |line|
                if line.start_with?("Monkey")
                    if (!monkey.nil?)
                        monkeys.push(monkey)
                    end
                    monkey = Monkey.new
                    monkey.inspected_items = 0
                elsif line.empty?
                    next
                else
                    update_monkey_info(line, monkey)
                end
            end
            monkeys.push(monkey) # push final monkey to array after parsing

            monkeys
        end

        def update_monkey_info(line, monkey)
            if line.start_with?("  Starting items:")
                monkey.items = line.split(": ")[1].split(", ").map(&:to_i)
            elsif line.start_with?("  Operation:")
                set_monkey_operation(line, monkey)
            elsif line.start_with?("  Test:")
                set_monkey_test(line, monkey)
            elsif line.start_with?("    If true:")
                monkey.true_throw_to = line.split("to monkey ")[1].to_i
            elsif line.start_with?("    If false:")
                monkey.false_throw_to = line.split("to monkey ")[1].to_i
            end
        end

        def set_monkey_operation(line, monkey)
            operation = line.split(": ")[1]
            regex = /new = old ([+-\/*]) ([0-9]+|old)/
            if matches = operation.match(regex)
                operator = matches[1]
                operand = matches[2] == "old" ?
                    nil :
                    matches[2].to_i

                case operator
                when "+"
                    monkey.operation = ->(old) { old + (operand || old) }
                when "-"
                    monkey.operation = ->(old) { old - (operand || old) }
                when "*"
                    monkey.operation = ->(old) { old * (operand || old) }
                when "/"
                    monkey.operation = ->(old) { old / (operand || old) }
                end
            end
        end

        def set_monkey_test(line, monkey)
            test = line.split(": ")[1]
            regex = /divisible by ([0-9]+)/
            if matches = test.match(regex)
                divisor = matches[1].to_i
                monkey.test = ->(num) { num % divisor == 0 }
            end
        end
    end

    class Monkey
        attr_accessor :items, :operation, :test, :true_throw_to, :false_throw_to, :inspected_items

        def throw_item(item_worry)
            self.inspected_items += 1
            new_worry = self.operation.call(item_worry)
            worry_at_toss = new_worry / 3
            return worry_at_toss, self.test.call(worry_at_toss) == true ?
                true_throw_to :
                false_throw_to
        end
    end
end

Challenges::Day11.new.main