# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in decidim-clave.gemspec
gemspec

require_relative "lib/decidim/clave/version"

group :development, :test do
  gem "bootsnap", require: false
  gem "byebug", platform: :mri
  gem "decidim", Decidim::Clave::DECIDIM_VERSION, require: true
  gem "faker"
  gem "letter_opener_web"
  gem "listen"
end

group :development do
  gem "rake", "~> 13.0"
  gem "rubocop"
end

group :test do
  gem "rspec", "~> 3.0"
end
