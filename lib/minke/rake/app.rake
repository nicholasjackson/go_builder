namespace :app do

  desc "fetch dependent packages"
  task :fetch => ['config:set_docker_env', 'docker:fetch_images'] do
    create_dependencies
    runner = Minke::Tasks::Fetch.new @config, :fetch, @generator_config, @docker_runner, @docker_compose_factory, @logger, @helper
    runner.run
  end

  desc "build application"
  task :build => [:fetch] do
    create_dependencies
    runner = Minke::Tasks::Build.new @config, :build, @generator_config, @docker_runner, @docker_compose_factory, @logger, @helper
    runner.run
  end

  desc "run unit tests"
  task :test => [:build] do
    create_dependencies
    runner = Minke::Tasks::Test.new @config, :test, @generator_config, @docker_runner, @docker_compose_factory, @logger, @helper
    runner.run
  end

  desc "build Docker image for application"
  task :build_image => [:test] do
    create_dependencies
    runner = Minke::Tasks::BuildImage.new @config, :test, @generator_config, @docker_runner, @docker_compose_factory, @logger, @helper
    runner.run
  end

  desc "run application with Docker Compose"
  task :run => ['config:set_docker_env'] do
    create_dependencies
    runner = Minke::Tasks::Run.new @config, :run, @generator_config, @docker_runner, @docker_compose_factory, @logger, @helper
    runner.run
  end

  desc "build and run application with Docker Compose"
  task :build_and_run => [:build_image, :run]

  desc "run end to end Cucumber tests USAGE: rake app:cucumber[@tag]"
  task :cucumber, [:feature] => ['config:set_docker_env'] do |t, args|
    create_dependencies
    runner = Minke::Tasks::Cucumber.new @config, :cucumber, @generator_config, @docker_runner, @docker_compose_factory, @logger, @helper
    runner.run
  end

  desc "push built image to Docker registry"
  task :push  do
    create_dependencies
    runner = Minke::Tasks::Push.new
    runner.run
  end

  def create_dependencies
    @system_runner = Minke::Docker::SystemRunner.new
    @docker_compose_factory ||= Minke::Docker::DockerComposeFactory.new @system_runner

    if @config == nil
      reader = Minke::Config::Reader.new
      @config = reader.read './config.yml'
    end

    if @generator_config == nil
      variables = Minke::Generators::ConfigVariables.new.tap do |v|
        v.application_name = @config.application_name
        v.namespace = @config.namespace
        v.src_root = File.expand_path('../', __FILE__)
      end

      processor = Minke::Generators::Processor.new variables
      processor.load_generators
      @generator_config = processor.get_generator @config.generator_name
    end

    @docker_runner ||= Minke::Docker::DockerRunner.new
    @logger ||= Logger.new(STDOUT)
    @helper ||= Minke::Helpers::Helper.new
  end
end
