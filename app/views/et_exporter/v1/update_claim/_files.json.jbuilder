json.uploaded_files do
  json.partial! "et_exporter/v1/uploaded_file", collection: files, as: :uploaded_file, formats: [:json]
end
