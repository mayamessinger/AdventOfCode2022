module Challenges
    module Helper
        def read_file(filePath)
            file = File.open(filePath, "r")
            file_data = file.readlines.map(&:chomp)
            file.close
    
            file_data
        end
    end
end