require 'json'
require_relative 'helper'

module Challenges
    class Day13
        include Helper
    
        def main
            puts sum_ordered_pairs

            puts get_decoder_key
        end

        def sum_ordered_pairs
            sum_ordered_pairs = 0

            @lines ||= read_file("./resources/day13.txt")
            0.step(@lines.length, 3) do |i|
                packet1 = get_structure(@lines[i])
                packet2 = get_structure(@lines[i + 1])

                if ordered(packet1, packet2)
                    sum_ordered_pairs += (i / 3 + 1)
                end
            end

            sum_ordered_pairs
        end

        def get_decoder_key
            sorted = quick_sort(get_packets)
            (sorted.find_index(get_structure("[[2]]")) + 1) * (sorted.find_index(get_structure("[[6]]")) + 1)
        end

        def get_packets
            packets = []

            @lines ||= read_file("./resources/day13.txt")
            for line in @lines
                packets << get_structure(line) unless line == ""
            end
            packets << get_structure("[[2]]")
            packets << get_structure("[[6]]")

            packets
        end

        def quick_sort(packets)
            return packets if packets.length <= 1

            pivot = packets[0]
            left = []
            right = []

            for i in 1..packets.length - 1
                if ordered(packets[i], pivot)
                    left << packets[i]
                else
                    right << packets[i]
                end
            end

            quick_sort(left) + [pivot] + quick_sort(right)
        end

        def ordered(packet1, packet2)
            for i in 0..packet1.length - 1
                return false if i >= packet2.length

                if packet1[i].is_a?(Array) && packet2[i].is_a?(Array)
                    result = ordered(packet1[i], packet2[i])
                    return result if !result.nil?
                elsif packet1[i].is_a?(Array) && packet2[i].is_a?(Integer)
                    result = ordered(packet1[i], [packet2[i]])
                    return result if !result.nil?
                elsif packet1[i].is_a?(Integer) && packet2[i].is_a?(Array)
                    result = ordered([packet1[i]], packet2[i])
                    return result if !result.nil?
                elsif packet1[i].is_a?(Integer) && packet2[i].is_a?(Integer)
                    return true if packet1[i] < packet2[i]
                    return false if packet1[i] > packet2[i]
                end
            end

            if packet2.empty? || packet2.length > packet1.length
                return true
            end

            nil
        end

        def get_structure(packet)
            JSON.parse packet
        end
    end
end

Challenges::Day13.new.main