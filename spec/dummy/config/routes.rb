Rails.application.routes.draw do
  mount EtExporter::Engine => "/et_exporter"
end
