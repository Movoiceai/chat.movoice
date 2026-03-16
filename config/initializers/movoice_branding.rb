# Force Movoice AI branding by overriding GlobalConfig at the method level
# This bypasses both the database AND Redis cache entirely

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

GlobalConfig.singleton_class.prepend(MovoiceBrandingOverride)
