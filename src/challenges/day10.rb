require 'set'
require_relative 'helper'

module Challenges
    class Day10
        include Helper
    
        def main
            puts get_signal_strength_sum 20, 40
        end

        def get_signal_strength_sum(start, frequency)
            instructions = get_instructions
            flagged_cycle_values = process_instructions(instructions, start, frequency)

            flagged_cycle_values.take(6).each_with_index.map {|x_value, index| x_value * (40 * index + 20)}.sum
        end

        def get_instructions
            instructions = Queue.new

            instruction_lines = read_file("./resources/day10.txt")
            for i in 0..instruction_lines.length - 1
                instr, value = instruction_lines[i].split(" ")
                instructions.push(Instruction.new(instr, value.to_i))
            end

            instructions
        end

        def process_instructions(instructions, start, frequency)
            current_cycle = 0
            flagged_cycle_values = []
            threshold = start

            x = 1
            while !instructions.empty?
                current_instruction = instructions.pop

                duration = get_duration(current_instruction)
                if current_cycle <= threshold && current_cycle + duration >= threshold
                    flagged_cycle_values.push(x)
                end

                print_crt_for_instruction(current_cycle, duration, x)

                # after cycle

                x += current_instruction[:value]
                current_cycle += duration
                if current_cycle >= threshold
                    threshold += frequency
                end
            end

            flagged_cycle_values
        end

        def print_crt_for_instruction(current_cycle, duration, x)
            crt = ""

            for i in current_cycle..current_cycle + duration - 1
                position_printing = i % 40

                if x - 1 <= position_printing && position_printing <= x + 1
                    crt += "#"
                else
                    crt += "."
                end

                if position_printing % 40 == 39
                    print crt
                    $stdout.flush
                    crt = ""
                    print "\n"
                end
            end

            print crt
            $stdout.flush
        end

        def get_duration(instruction)
            case instruction[:instr]
            when "noop"
                return 1
            when "addx"
                return 2
            end

            return -1
        end
    end

    Instruction = Struct.new(:instr, :value) do
        def initialize(instr, value)
            self.instr = instr
            self.value = value
        end
    end
end

Challenges::Day10.new.main