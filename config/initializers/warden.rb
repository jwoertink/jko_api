JkoApi.auth_setup do
  Warden::OAuth2.configure do |config|
    if JkoApi.configuration.strategy.bearer?
      config.token_model = JkoApi.configuration.token_model
    end
  end
end
