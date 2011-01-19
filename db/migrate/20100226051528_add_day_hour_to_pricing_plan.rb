class AddDayHourToPricingPlan < ActiveRecord::Migration
  def self.up
    add_column :pricing_plans, :day, :integer
    add_column :pricing_plans, :hours, :integer
    PricingPlan.reset_column_information 
    PricingPlan.create!(:plan_name => "free plan",:day=>7,:amount=>900,:max_users_in_group=>900,:max_group=>900 )
    PricingPlan.create!(:plan_name => "Tier 1",:day=>7,:amount=>900,:max_users_in_group=>900,:max_group=>900 )
    PricingPlan.create!(:plan_name => "Tier 2",:day=>7,:amount=>900,:max_users_in_group=>900,:max_group=>900 )
    PricingPlan.create!(:plan_name => "Tier 3",:day=>7,:amount=>900,:max_users_in_group=>900,:max_group=>900 )
  end

  def self.down
    remove_column :pricing_plans, :hours
    remove_column :pricing_plans, :day
  end
end
