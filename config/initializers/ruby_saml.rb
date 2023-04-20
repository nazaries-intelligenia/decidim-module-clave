# frozen_string_literal: true

OneLogin::RubySaml::Response.class_eval do
  def validate_structure
    true
  end
end
