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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100807101103) do

  create_table "access_codes", :force => true do |t|
    t.string   "access_code", :limit => 50
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_logs", :force => true do |t|
    t.integer  "admin_id"
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "objective_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "firstname",                 :limit => 50
    t.string   "lastname",                  :limit => 50
    t.boolean  "is_active"
    t.boolean  "is_manager"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state"
    t.string   "password_reset_code"
  end

  create_table "attachments", :force => true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type", :limit => 100
    t.string   "content_type",    :limit => 100
    t.string   "filename",        :limit => 100
    t.string   "thumbnail",       :limit => 100
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "size"
    t.integer  "parent_id"
  end

  create_table "beta_invits", :force => true do |t|
    t.string   "email",          :limit => 100
    t.string   "first_name",     :limit => 50
    t.string   "last_name",      :limit => 50
    t.string   "organization",   :limit => 50
    t.string   "occupation",     :limit => 50
    t.string   "country",        :limit => 50
    t.integer  "demographic_id"
    t.string   "zipcode",        :limit => 20
    t.date     "dob"
    t.string   "referred_by",    :limit => 50
    t.text     "invitation_msg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "receiver_id"
  end

  create_table "coupon_codes", :force => true do |t|
    t.string   "code"
    t.string   "coupon_type", :limit => 50
    t.string   "value",       :limit => 50
    t.date     "active_from"
    t.date     "active_to"
    t.boolean  "is_active"
    t.boolean  "is_deleteds"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "demographics", :force => true do |t|
    t.string   "name",       :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dup_attachments", :force => true do |t|
    t.integer  "attach_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorites", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fb_sessions", :force => true do |t|
    t.string   "uid",              :limit => 50
    t.string   "local_session_id"
    t.string   "fb_session_key"
    t.string   "fb_user_token",    :limit => 30
    t.string   "fb_user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "group_users", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "color_code",        :limit => 10
    t.boolean  "is_active",                       :default => true
    t.boolean  "is_deleted",                      :default => false
    t.boolean  "Last_Mark_As_Read"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name",                :limit => 100
    t.text     "description"
    t.integer  "user_id"
    t.integer  "group_leader_id"
    t.datetime "due_date"
    t.boolean  "is_active"
    t.string   "leader_email_invite", :limit => 100
    t.string   "first_name",          :limit => 50
    t.string   "last_name",           :limit => 50
    t.text     "message"
    t.datetime "invited_at"
    t.string   "invitation_code",     :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "industries", :force => true do |t|
    t.string   "name",       :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "group_id"
    t.string   "first_name",      :limit => 50
    t.string   "last_name",       :limit => 50
    t.string   "email",           :limit => 100
    t.string   "image_url"
    t.string   "source_site",     :limit => 100
    t.text     "message"
    t.integer  "user_id"
    t.string   "invitation_code", :limit => 40
    t.datetime "invited_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_users", :force => true do |t|
    t.integer  "message_id"
    t.integer  "user_id"
    t.boolean  "is_read"
    t.boolean  "is_trash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",     :limit => 10
    t.boolean  "is_delete",                :default => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "subject"
    t.text     "message"
    t.boolean  "is_draft"
    t.boolean  "is_focused"
    t.boolean  "is_closed"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "objective_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "objective_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "objectives", :force => true do |t|
    t.integer  "group_id"
    t.string   "title",       :limit => 100
    t.text     "description"
    t.date     "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oldcreditcards", :force => true do |t|
    t.integer  "user_id"
    t.integer  "last_4digit"
    t.integer  "exp_year"
    t.integer  "exp_month"
    t.string   "card_type",            :limit => 20
    t.integer  "ccv_number"
    t.integer  "recurring_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_versions", :force => true do |t|
    t.integer  "page_id"
    t.string   "title",            :limit => 100
    t.text     "content"
    t.string   "meta_keywords",    :limit => 40
    t.text     "meta_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "name",             :limit => 50
    t.string   "title",            :limit => 100
    t.text     "content"
    t.string   "meta_keywords",    :limit => 40
    t.text     "meta_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "pricing_plan_id"
    t.integer  "subscription_id"
    t.float    "amount"
    t.string   "transaction_id",   :limit => 100
    t.string   "transcation_type", :limit => 100
    t.integer  "card_4digit"
    t.integer  "exp_month"
    t.integer  "exp_year"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "gateway_response", :limit => 100
    t.text     "description"
    t.boolean  "is_success"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_reads", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.text     "content"
    t.boolean  "is_group_log"
    t.integer  "receiver_id"
    t.integer  "objective_id"
    t.boolean  "is_by_leader"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pricing_plans", :force => true do |t|
    t.string   "plan_name",          :limit => 50
    t.float    "amount"
    t.integer  "max_users_in_group"
    t.integer  "max_group"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "day"
    t.integer  "hours"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "site_settings", :force => true do |t|
    t.string   "title",                      :limit => 100
    t.text     "description"
    t.string   "admin_email",                :limit => 100
    t.integer  "max_free_groups"
    t.integer  "days_of_free_use"
    t.integer  "grace_period_payment_hours"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "static_page_versions", :force => true do |t|
    t.integer  "static_page_id"
    t.integer  "version"
    t.string   "name"
    t.string   "title"
    t.text     "page_center"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "static_page_versions", ["static_page_id"], :name => "index_static_page_versions_on_static_page_id"

  create_table "static_pages", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "page_center"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "pricing_plan_id"
    t.date     "next_renewal_at"
    t.date     "billing_start_date"
    t.date     "billing_end_date"
    t.integer  "coupon_code_id"
    t.float    "discount_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "card_type",          :limit => 20
    t.float    "amount"
    t.boolean  "is_success"
  end

  create_table "user_billing_informations", :force => true do |t|
    t.integer  "user_id"
    t.string   "company_name",  :limit => 100
    t.string   "first_name",    :limit => 50
    t.string   "last_name",     :limit => 50
    t.string   "address_1",     :limit => 150
    t.string   "address_2",     :limit => 150
    t.string   "city",          :limit => 50
    t.string   "state",         :limit => 50
    t.string   "country",       :limit => 50
    t.string   "zipcode",       :limit => 20
    t.string   "phonenumber",   :limit => 20
    t.string   "email_address", :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_creditcards", :force => true do |t|
    t.integer  "user_id"
    t.integer  "last_digit"
    t.integer  "exp_year"
    t.integer  "exp_month"
    t.string   "card_type",            :limit => 20
    t.integer  "ccv_number"
    t.string   "recurring_profile_id", :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_notifications", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "status_update"
    t.boolean  "objective_update"
    t.boolean  "new_message"
    t.boolean  "new_activity_message_thread"
    t.boolean  "members_info_change"
    t.boolean  "new_group_member"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_plans", :force => true do |t|
    t.integer  "user_id"
    t.float    "amount"
    t.integer  "max_users_in_group"
    t.integer  "max_group"
    t.integer  "day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_posts", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.boolean  "is_read",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "leader_update_read", :default => true
  end

  create_table "user_profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name",             :limit => 50
    t.string   "last_name",              :limit => 50
    t.string   "organization",           :limit => 50
    t.string   "occupation",             :limit => 50
    t.string   "office_email_address",   :limit => 100
    t.string   "personal_email_address", :limit => 100
    t.string   "mobile_phone",           :limit => 40
    t.string   "office_phone",           :limit => 40
    t.string   "yahoo_id",               :limit => 50
    t.string   "windows_live_id",        :limit => 50
    t.string   "aim_id",                 :limit => 50
    t.string   "skype_id",               :limit => 50
    t.string   "mailing_address1",       :limit => 100
    t.string   "mailing_address2",       :limit => 100
    t.string   "city",                   :limit => 50
    t.string   "state",                  :limit => 50
    t.string   "country",                :limit => 50
    t.string   "zipcode",                :limit => 20
    t.integer  "demographic_id"
    t.integer  "industry_id"
    t.string   "gender",                 :limit => 1
    t.date     "dob"
    t.text     "other_info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "date_format"
    t.string   "time_zone"
    t.string   "title"
  end

  create_table "user_settings", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "organization"
    t.boolean  "occupation"
    t.boolean  "office_email_address"
    t.boolean  "personal_email_address"
    t.boolean  "mobile_phone"
    t.boolean  "ofice_phone"
    t.boolean  "yahoo_id"
    t.boolean  "windows_live_id"
    t.boolean  "AIM_id"
    t.boolean  "skype_id"
    t.boolean  "mailing_address1"
    t.boolean  "mailing_address2"
    t.boolean  "city"
    t.boolean  "state"
    t.boolean  "zip"
    t.boolean  "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "user_name",                 :limit => 50
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "password_reset_code"
    t.string   "state"
    t.datetime "deleted_at"
    t.string   "openid_url"
    t.boolean  "is_rpx"
    t.string   "signup_type",               :limit => 50
    t.string   "identifier_url",            :limit => 200
    t.boolean  "is_free_user"
    t.integer  "pricing_plan_id"
    t.string   "reason_for_delete",         :limit => 100
    t.string   "close_code"
    t.string   "primary_email"
    t.string   "primary_activiation_code"
    t.string   "access_code"
  end

end
