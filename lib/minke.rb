require 'consul_loader'
require 'docker'
require 'erb'
require 'fileutils'
require 'logger'
require 'rake'
require 'resolv'
require 'rest-client'
require 'rubygems'
require 'yaml'

require 'minke/version'

require 'minke/helpers/helper'

require 'minke/docker/docker_compose'
require 'minke/docker/docker_runner'

require 'minke/config/config'
require 'minke/config/reader'

require 'minke/tasks/task'
require 'minke/tasks/build'
require 'minke/tasks/cucumber'
require 'minke/tasks/fetch'
require 'minke/tasks/push'
require 'minke/tasks/run'
require 'minke/tasks/test'

require 'minke/generators/config'
require 'minke/generators/config_processor'
require 'minke/generators/config_variables'
require 'minke/generators/processor'
require 'minke/generators/register'
