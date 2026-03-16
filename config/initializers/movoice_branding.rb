# Force Movoice AI branding on every startup
# Clears Redis GlobalConfig cache so new values are served immediately

Rails.application.config.after_initialize do
  branding = {
    'INSTALLATION_NAME' => 'Movoice AI',
    'BRAND_NAME'        => 'Movoice AI',
    'BRAND_URL'         => 'https://www.movoice.ai',
    'WIDGET_BRAND_URL'  => 'https://www.movoice.ai',
    'TERMS_URL'         => 'https://www.movoice.ai/terms',
    'PRIVACY_URL'       => 'https://www.movoice.ai/privacy',
  }

  branding.each do |name, value|
    config = InstallationConfig.find_by(name: name)
    config.update_column(:value, value) if config && config.value != value
  rescue StandardError => e
    Rails.logger.warn "[Movoice] Could not update #{name}: #{e.message}"
  end

  # Clear Redis cache so updated values are served immediately
  GlobalConfig.clear_cache
  Rails.logger.info '[Movoice] Branding applied and GlobalConfig cache cleared'
rescue StandardError => e
  Rails.logger.warn "[Movoice] Branding init failed: #{e.message}"
end
