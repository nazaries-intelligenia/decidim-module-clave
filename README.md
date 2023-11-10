# Decidim::Clave

Decidim omniauth sign up and sign in with Cl@ve.

## Installation

Install the gem in the application's Gemfile by executing:

    $ bundle add decidim-clave
    $ bundle install

Configure Cl@ve as a default omniauth provider in `config/secrets.yml`:

```yaml
# ...
default: &default
  decidim:
    <<: *decidim_default
  storage:
    <<: *storage_default
  omniauth:
    clave:
      enabled: true
      icon_path: media/images/clave-icon.svg
      sp_entity_id: <%= ENV["CLAVE_SP_ENTITY_ID"] %>
      idp_sso_service_url: <%= ENV["CLAVE_IDP_SSO_SERVICE_URL"] %>
      sp_certificate: "<%= ENV["CLAVE_SP_CERTIFICATE"] %>"
      sp_private_key: "<%= ENV["CLAVE_SP_PRIVATE_KEY"] %>"
      idp_certificate: "<%= ENV["CLAVE_IDP_CERTIFICATE"] %>"
    facebook:
      # It must be a boolean. Remember ENV variables doesn't support booleans.
      enabled: false
      app_id: <%= ENV["OMNIAUTH_FACEBOOK_APP_ID"] %>
      app_secret: <%= ENV["OMNIAUTH_FACEBOOK_APP_SECRET"] %>
    twitter:
      enabled: false
      api_key: <%= ENV["OMNIAUTH_TWITTER_API_KEY"] %>
      api_secret: <%= ENV["OMNIAUTH_TWITTER_API_SECRET"] %>
    google_oauth2:
      enabled: false
      client_id: <%= ENV["OMNIAUTH_GOOGLE_CLIENT_ID"] %>
      client_secret: <%= ENV["OMNIAUTH_GOOGLE_CLIENT_SECRET"] %>
# ...
```

Set the previously defined configuration in your application's environments. For example, if you use a config loader like Fiagaro, you can add the following test variables in your `config/application.yml`:

```
  CLAVE_IDP_SSO_SERVICE_URL: "https://xxxxxxxxxx.clave.gob.es/xxxxxxxxxx"
  CLAVE_SP_ENTITY_ID: "xxxxxxxxx_xxxxxxxxx;DecidimXxxxxxxxxxApp"
  CLAVE_SP_CERTIFICATE: "<%= File.open(::Decidim::Clave::Engine.root.join("config/clave/sello_kit_de_pruebas_ac_sector_p_blico_.crt")).read %>"
  CLAVE_SP_PRIVATE_KEY: "<%= File.open(::Decidim::Clave::Engine.root.join("config/clave/sello_kit_de_pruebas_ac_sector_p_blico_.pem")).read %>"
  CLAVE_IDP_CERTIFICATE: "<%= File.open(::Decidim::Clave::Engine.root.join("config/clave/sello_entidad_sgad_pruebas.cer")).read %>"
```

For production you will have to update the IdP SSO URL and the cryptographic assets which must NOT be added to your version control. You better load them with `Rails.root` instead of `::Decidim::Clave::Engine.root`.

Remember that you first need to register to Cl@ve before testing it in any environment.
When registered you will be provided your CLAVE_SP_ENTITY_ID code. Use this code in production, but also in your developmment and preproduction environments.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Run tests

Node 16.9.1 is required!

Create a dummy app:

```bash
bin/rails decidim:generate_external_test_app
```

And run tests:

```bash
bundle exec rspec spec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/decidim-clave. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/decidim-clave/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Decidim::Clave project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/decidim-clave/blob/master/CODE_OF_CONDUCT.md).
