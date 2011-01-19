class AddValuesInUseIndustry < ActiveRecord::Migration
  def self.up
      Industry.create!(:name=>"Accounting")
      Industry.create!(:name=>"Architecture")
      Industry.create!(:name=>"Management Consulting")
      Industry.create!(:name=>"Construction")
      Industry.create!(:name=>"Financial Services")
      Industry.create!(:name=>"Manufacturing")
      Industry.create!(:name=>"Marketing")
      Industry.create!(:name=>"Sales")
      Industry.create!(:name=>"Education")
      Demographic.create!(:name=>"Small Business (1 to 20 employees)")
      Demographic.create!(:name=>"Mid Sized Business (20 to 500 employees)")
      Demographic.create!(:name=>"Large Business (More than 500 employees)")
      Demographic.create!(:name=>"Business Team")
      Demographic.create!(:name=>"Education")
      Demographic.create!(:name=>"Non-Profit")
      Demographic.create!(:name=>"Event Planning")
      Demographic.create!(:name=>"Casual")
  end

  def self.down
  end
end
