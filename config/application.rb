require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RunApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    config.api_only = true

    config.i18n.default_locale = :ja
    # config.i18n.load_path += Dir[Rails.root.join('config/locales/**/ja.yml').to_s]
  end
end
