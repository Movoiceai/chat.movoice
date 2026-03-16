# Force Movoice AI branding by overriding GlobalConfig at the method level
# Wrapped in after_initialize to ensure GlobalConfig is loaded before patching

MOVOICE_BRANDING = {
  'INSTALLATION_NAME' => 'Movoice AI',
  'BRAND_NAME'        => 'Movoice AI',
  'BRAND_URL'         => 'https://www.movoice.ai',
  'WIDGET_BRAND_URL'  => 'https://www.movoice.ai',
  'TERMS_URL'         => 'https://www.movoice.ai/terms',
  'PRIVACY_URL'       => 'https://www.movoice.ai/privacy',
}.freeze

module MovoiceBrandingOverride
  def get(*args)
    result = super(*args)
    args.each do |key|
      result[key] = MOVOICE_BRANDING[key] if MOVOICE_BRANDING.key?(key)
    end
    result
  end

  def get_value(arg)
    MOVOICE_BRANDING[arg] || super(arg)
  end
end

Rails.application.config.after_initialize do
  GlobalConfig.singleton_class.prepend(MovoiceBrandingOverride) if defined?(GlobalConfig)
end
