# frozen_string_literal: true

require_relative "lib/decidim/clave/version"

Gem::Specification.new do |spec|
  spec.name = "decidim-clave"
  spec.version = Decidim::Clave::VERSION
  spec.authors = ["Oliver Valls"]
  spec.email = ["199462+tramuntanal@users.noreply.github.com"]

  spec.summary = "Decidim integration with Cl@ve."
  spec.description = "Decidim omniauth sign up and sign in with Cl@ve."
  spec.homepage = "http://github.com/CodiTramunana/decidim-module-clave"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.1"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "decidim", Decidim::Clave::COMPAT_DECIDIM_VERSION
  spec.add_dependency "omniauth-rails_csrf_protection", "~> 1.0"
  spec.add_dependency "omniauth-saml", "~> 2.1.0"
  spec.add_dependency "rails", ">= 6"

  spec.add_development_dependency "decidim-dev", Decidim::Clave::COMPAT_DECIDIM_VERSION
  spec.metadata["rubygems_mfa_required"] = "true"
end
