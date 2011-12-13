domain_config = File.read(RAILS_ROOT + "/config/domain.yml")
CONFIG = YAML.load(domain_config)[RAILS_ENV].symbolize_keys