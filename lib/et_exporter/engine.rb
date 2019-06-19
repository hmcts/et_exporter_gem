module EtExporter
  class Engine < ::Rails::Engine
    isolate_namespace EtExporter
    config.generators.api_only = true
    config.generators.test_framework = :rspec
  end
end
