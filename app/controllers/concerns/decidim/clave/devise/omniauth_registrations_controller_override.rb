# frozen_string_literal: true

module Decidim
  module Clave
    module Devise
      # Override to avoid callback token error with C@lave
      module OmniauthRegistrationsControllerOverride
        extend ActiveSupport::Concern

        included do
          skip_before_action :verify_authenticity_token, only: :clave
        end
      end
    end
  end
end
