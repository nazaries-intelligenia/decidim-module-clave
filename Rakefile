# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "decidim/dev/common_rake"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: [:spec, :rubocop]

desc "Generates a dummy app for testing"
task test_app: "decidim:generate_external_test_app" do
  ENV["RAILS_ENV"] = "test"
end
