# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_12_12_112541) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "types_samples", force: :cascade do |t|
    t.string "gem_name"
    t.string "gem_version"
    t.string "receiver"
    t.string "method_name"
    t.string "location"
    t.string "type_fusion_version"
    t.string "application_name"
    t.string "source_ip"
    t.jsonb "parameters"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "return_value"
  end

end
