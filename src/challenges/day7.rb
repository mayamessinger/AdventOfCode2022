require_relative 'helper'

module Challenges
    class Day7
        include Helper
    
        def main
            puts get_sum_of_folders_of_size(100000)

            puts get_smallest_folder_to_delete
        end

        def get_sum_of_folders_of_size(size)
            get_folder_sizes.filter { |folder| folder[:size] <= size }.map { |folder| folder[:size] }.sum
        end

        def get_smallest_folder_to_delete
            folder_sizes = get_folder_sizes
            space_free = 70000000 - folder_sizes[folder_sizes.length - 1][:size]

            get_smallest_folder_of_size(30000000 - space_free)
        end

        def get_smallest_folder_of_size(size)
            get_folder_sizes.filter { |folder| folder[:size] >= size }.min_by { |folder| folder[:size] }[:size]
        end

        def get_folder_sizes
            folder_sizes = []
            get_folder_size(get_file_tree, folder_sizes)
           
            folder_sizes
        end

        def get_folder_size(folder, folder_sizes)
            size = folder.files.map(&:size).sum + folder.folders.map { |folder| get_folder_size(folder, folder_sizes) }.sum
            folder_sizes.push({ name: folder.name, size: size })

            size
        end

        def get_file_tree
            console_log = read_file('./resources/day7.txt')

            root_folder = parse_log(console_log)
        end

        def parse_log(log)
            root_folder = nil

            current_folder = nil
            log.each do |line|
                if line.start_with?("$")
                    current_folder = parse_command(line, current_folder)

                    if root_folder.nil?
                        root_folder = current_folder
                    end
                else
                    add_content(line, current_folder)
                end
            end

            root_folder
        end

        def parse_command(command, current_folder)
            if command.start_with?("$ cd ")
                destination = command.split(" ")[2]

                if destination == ".."
                    return current_folder.parent
                end

                if current_folder.nil?
                    return FolderStruct.new(destination, current_folder)
                end

                return current_folder.get_folder(destination) || FolderStruct.new(destination, current_folder)
            elsif command.start_with?("$ ls")
                return current_folder
            end

            nil
        end

        def add_content(content, folder)
            if content.start_with?("dir ")
                folder_name = content.split(" ")[1]
                folder.add_folder(FolderStruct.new(folder_name, folder))
            elsif content.start_with?(/[0-9]{1,}/)
                file_size, file = content.split(" ")
                file_name, file_extension = file.split(".")

                folder.add_file(FileStruct.new(file_name, file_extension, Integer(file_size)))
            end
        end
    end

    FolderStruct = Struct.new(:name, :files, :folders, :parent) do
        def initialize(name, parent)
            self.name = name
            self.files = []
            self.folders = []
            self.parent = parent
        end

        def add_file(file)
            self.files.append file
        end

        def add_folder(folder)
            self.folders.append folder
        end

        def get_file(name, extension)
            self.files.find { |file| file.name == name && file.extension == extension }
        end

        def get_folder(name)
            self.folders.find { |folder| folder.name == name }
        end
    end

    FileStruct = Struct.new(:name, :extension, :size) do
        def initialize(name, extension, size)
            self.name = name
            self.extension = extension
            self.size = size
        end
    end

    module Actions
        CHANGE_FOLDER = "cd",
        LIST_FILES = "ls"
    end
end

Challenges::Day7.new.main