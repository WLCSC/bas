raw_config = File.read("#{Rails.root}/config/app_config.yml")
APP_CONFIG = YAML.load(raw_config)[Rails.env].symbolize_keys
Time.zone = "America/Indiana/Indianapolis"
Guidance::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[BAS ERROR] ",
  :sender_address => APP_CONFIG[:email_support_from],
  :exception_recipients => APP_CONFIG[:email_support_recipients].split(';')
