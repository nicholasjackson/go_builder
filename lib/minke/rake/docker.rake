namespace :docker do
  desc "updates build images for swagger and golang will overwrite existing images"
  task :update_images do
    puts "## Updating Docker images"
  	Minke::GoDocker.pull_image 'golang:latest'

    puts ""
  end

  desc "pull images for golang from Docker registry if not already downloaded"
  task :fetch_images do
    puts "## Pulling Docker images"
  	Minke::GoDocker.pull_image 'golang' unless Minke::GoDocker.find_image 'golang:latest'

    puts ""
  end
end
