namespace(:maze) do
  default_maze_path = "data/**/*.maze"
  desc("Import Maze file: default MAZE_PATH is #{default_maze_path}")
  task(import: :environment) do
    maze_paths = Pathname.glob(ENV["MAZE_PATH"] || default_maze_path).sort
    Maze.transaction do
      maze_paths.each do |path|
        puts("importing #{path}...")
        Maze.create!(correct_answer: path.read)
      end
    end
    puts("#{maze_paths.length} mazes was imported.")
  end
end
