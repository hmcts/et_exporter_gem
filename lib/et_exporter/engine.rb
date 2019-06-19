module EtExporter
  class Engine < ::Rails::Engine
    isolate_namespace EtExporter
    config.generators.api_only = true
  end
end
