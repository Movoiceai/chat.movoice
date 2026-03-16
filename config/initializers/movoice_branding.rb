# Force Movoice AI branding on every startup
# This overrides the database values set during initial Chatwoot seeding

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
end
