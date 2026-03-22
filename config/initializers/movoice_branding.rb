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

  # Unlock all EE features by making the app appear as enterprise
  if defined?(ChatwootApp)
    ChatwootApp.instance_eval do
      def self.enterprise?
        true
      end
    end
  end

  # Set pricing plan to enterprise so all EE features are unlocked
  if defined?(InstallationConfig)
    begin
      config = InstallationConfig.find_or_initialize_by(name: 'INSTALLATION_PRICING_PLAN')
      config.value = 'enterprise' unless config.value == 'enterprise'
      config.save if config.changed?
    rescue => e
      Rails.logger.warn "[Movoice] Could not set INSTALLATION_PRICING_PLAN: #{e.message}"
    end
  end
end
