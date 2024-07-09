# frozen_string_literal: true

require "omniauth/strategies/clave"

OmniAuth.config.logger = Rails.logger

if ActiveModel::Type::Boolean.new.cast(Rails.application.secrets.dig(:omniauth, :clave, :enabled))
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(
      :clave,
      setup: ->(env) { Decidim::Clave.setup_clave_env(env) },
      scope: :autenticacio_usuari
    )
  end
end
