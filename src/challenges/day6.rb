require_relative 'helper'

module Challenges
    class Day6
        include Helper
    
        def main
            puts get_packet_marker_index
        end

        def get_packet_marker_index
            stream_chars = read_file("./resources/day6.txt")

            get_packet_start_of_stream(stream_chars[0].split(''))
        end

        def get_packet_start_of_stream(stream_chars)
            index = 0
            most_recent_chars = Array.new

            while index < stream_chars.length do
                next_char = stream_chars[index]
                adjust_recent_chars(most_recent_chars, stream_chars[index])

                if is_packet_start(most_recent_chars)
                    return index + 1
                end

                index += 1
            end
        end

        def adjust_recent_chars(most_recent_chars, next_char)
            if (most_recent_chars.length == 4)
                most_recent_chars.shift
            end

            most_recent_chars.push(next_char)
        end

        def is_packet_start(most_recent_chars)
            most_recent_chars.uniq.length == 4
        end
    end
end

Challenges::Day6.new.main