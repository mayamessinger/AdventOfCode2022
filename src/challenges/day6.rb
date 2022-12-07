require_relative 'helper'

module Challenges
    class Day6
        include Helper
    
        def main
            puts get_marker_index 4

            puts get_marker_index 14
        end

        def get_marker_index(marker_length)
            stream_chars = read_file("./resources/day6.txt")

            get_marker_of_stream(stream_chars[0].split(''), marker_length)
        end

        def get_marker_of_stream(stream_chars, marker_length)
            index = 0
            most_recent_chars = Array.new

            while index < stream_chars.length do
                next_char = stream_chars[index]
                adjust_recent_chars(most_recent_chars, stream_chars[index], marker_length)

                if is_packet_start(most_recent_chars, marker_length)
                    return index + 1
                end

                index += 1
            end
        end

        def adjust_recent_chars(most_recent_chars, next_char, marker_length)
            if (most_recent_chars.length == marker_length)
                most_recent_chars.shift
            end

            most_recent_chars.push(next_char)
        end

        def is_packet_start(most_recent_chars, marker_length)
            if most_recent_chars.length != marker_length
                return false
            end

            most_recent_chars.uniq.length == marker_length
        end
    end
end

Challenges::Day6.new.main