class AddVersions < ActiveRecord::Migration
  def self.up
       StaticPage.create_versioned_table    
       StaticPage.create!( :name => "about_us", :title => "About Us", :page_center => "about us content here")
        StaticPage.create!( :name => "features", :title => "Feature", :page_center => "feature content here")
        StaticPage.create!( :name => "support", :title => "Support", :page_center => "support content here")
        StaticPage.create!( :name => "privacy", :title => "Privacy Rights", :page_center => "privacy  content here")
  end

  def self.down
  end
end
