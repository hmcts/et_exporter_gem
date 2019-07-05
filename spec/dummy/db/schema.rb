# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_18_153701) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "building"
    t.string "street"
    t.string "locality"
    t.string "county"
    t.string "string"
    t.string "post_code"
    t.string "country", null: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "claim_claimants", force: :cascade do |t|
    t.bigint "claim_id"
    t.bigint "claimant_id"
    t.index ["claim_id"], name: "index_claim_claimants_on_claim_id"
    t.index ["claimant_id"], name: "index_claim_claimants_on_claimant_id"
  end

  create_table "claim_representatives", force: :cascade do |t|
    t.bigint "claim_id"
    t.bigint "representative_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["claim_id"], name: "index_claim_representatives_on_claim_id"
    t.index ["representative_id"], name: "index_claim_representatives_on_representative_id"
  end

  create_table "claim_respondents", force: :cascade do |t|
    t.bigint "claim_id"
    t.bigint "respondent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["claim_id"], name: "index_claim_respondents_on_claim_id"
    t.index ["respondent_id"], name: "index_claim_respondents_on_respondent_id"
  end

  create_table "claim_uploaded_files", force: :cascade do |t|
    t.bigint "claim_id"
    t.bigint "uploaded_file_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["claim_id"], name: "index_claim_uploaded_files_on_claim_id"
    t.index ["uploaded_file_id"], name: "index_claim_uploaded_files_on_uploaded_file_id"
  end

  create_table "claimants", force: :cascade do |t|
    t.string "title"
    t.string "first_name"
    t.string "last_name"
    t.bigint "address_id"
    t.string "address_telephone_number"
    t.string "mobile_number"
    t.string "email_address"
    t.string "contact_preference"
    t.string "gender"
    t.date "date_of_birth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fax_number"
    t.text "special_needs"
    t.index ["address_id"], name: "index_claimants_on_address_id"
  end

  create_table "claims", force: :cascade do |t|
    t.string "reference"
    t.string "submission_reference"
    t.integer "claimant_count", default: 0, null: false
    t.string "submission_channel"
    t.string "case_type"
    t.integer "jurisdiction"
    t.integer "office_code"
    t.datetime "date_of_receipt"
    t.boolean "administrator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "primary_claimant_id", null: false
    t.string "other_known_claimant_names"
    t.string "discrimination_claims", default: [], null: false, array: true
    t.string "pay_claims", default: [], null: false, array: true
    t.string "desired_outcomes", default: [], null: false, array: true
    t.text "other_claim_details"
    t.text "claim_details"
    t.string "other_outcome"
    t.boolean "send_claim_to_whistleblowing_entity"
    t.text "miscellaneous_information"
    t.jsonb "employment_details", default: {}, null: false
    t.boolean "is_unfair_dismissal"
    t.bigint "primary_respondent_id"
    t.bigint "primary_representative_id"
    t.string "pdf_template_reference", null: false
    t.index ["primary_claimant_id"], name: "index_claims_on_primary_claimant_id"
    t.index ["primary_representative_id"], name: "index_claims_on_primary_representative_id"
    t.index ["primary_respondent_id"], name: "index_claims_on_primary_respondent_id"
  end


  create_table "exports", force: :cascade do |t|
    t.bigint "resource_id"
    t.bigint "pdf_file_id"
    t.boolean "in_progress"
    t.string "messages", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "resource_type"
    t.bigint "external_system_id", null: false
    t.index ["external_system_id"], name: "index_exports_on_external_system_id"
    t.index ["resource_id"], name: "index_exports_on_resource_id"
  end

  create_table "external_system_configurations", force: :cascade do |t|
    t.bigint "external_system_id", null: false
    t.string "key", null: false
    t.string "value", null: false
    t.boolean "can_read", default: true, null: false
    t.boolean "can_write", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_system_id"], name: "index_external_system_configurations_on_external_system_id"
  end

  create_table "external_systems", force: :cascade do |t|
    t.string "name", null: false
    t.string "reference", null: false
    t.integer "office_codes", default: [], array: true
    t.boolean "enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "export_queue"
    t.boolean "export", default: false
    t.index ["reference"], name: "index_external_systems_on_reference", unique: true
  end


  create_table "representatives", force: :cascade do |t|
    t.string "name"
    t.string "organisation_name"
    t.bigint "address_id"
    t.string "address_telephone_number"
    t.string "mobile_number"
    t.string "email_address"
    t.string "representative_type"
    t.string "dx_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference"
    t.string "contact_preference"
    t.string "fax_number"
    t.index ["address_id"], name: "index_representatives_on_address_id"
  end

  create_table "respondents", force: :cascade do |t|
    t.string "name"
    t.bigint "address_id"
    t.string "work_address_telephone_number"
    t.string "address_telephone_number"
    t.string "acas_number"
    t.bigint "work_address_id"
    t.string "alt_phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contact"
    t.string "dx_number"
    t.string "contact_preference"
    t.string "email_address"
    t.string "fax_number"
    t.integer "organisation_employ_gb"
    t.boolean "organisation_more_than_one_site"
    t.integer "employment_at_site_number"
    t.boolean "disability"
    t.string "disability_information"
    t.string "acas_certificate_number"
    t.string "acas_exemption_code"
    t.index ["address_id"], name: "index_respondents_on_address_id"
    t.index ["work_address_id"], name: "index_respondents_on_work_address_id"
  end

  create_table "uploaded_files", force: :cascade do |t|
    t.string "filename"
    t.string "checksum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "import_file_url"
    t.string "import_from_key"
  end

  add_foreign_key "claim_claimants", "claimants"
  add_foreign_key "claim_claimants", "claims"
  add_foreign_key "claim_representatives", "claims"
  add_foreign_key "claim_representatives", "representatives"
  add_foreign_key "claim_respondents", "claims"
  add_foreign_key "claim_respondents", "respondents"
  add_foreign_key "claim_uploaded_files", "claims"
  add_foreign_key "claim_uploaded_files", "uploaded_files"
  add_foreign_key "claimants", "addresses"
  add_foreign_key "exports", "external_systems"
  add_foreign_key "representatives", "addresses"
  add_foreign_key "respondents", "addresses"
  add_foreign_key "respondents", "addresses", column: "work_address_id"
end
