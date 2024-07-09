# frozen_string_literal: true

module Decidim
  module Clave
    # Engine to integrate with the Rails application.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Clave

      initializer "psych.tmp.fix" do |_app|
        # Workaround for https://stackoverflow.com/questions/72970170/upgrading-to-rails-6-1-6-1-causes-psychdisallowedclass-tried-to-load-unspecif
        Rails.application.config.active_record.use_yaml_unsafe_load = true
      end

      initializer "decidim_clave.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      config.to_prepare do
        Decidim::Devise::OmniauthRegistrationsController.include(Decidim::Clave::Devise::OmniauthRegistrationsControllerOverride)
      end
    end
  end
end
