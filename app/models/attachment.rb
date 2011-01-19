class Attachment < ActiveRecord::Base
     belongs_to :attachable,:polymorphic=>true
     has_many :dup_attachments
	 has_attachment :storage => :file_system,
                    #~ :resize_to => '200x200',
                 #   :thumbnails => {:thumb => '50X50>',:small=>'151x151>',:large=>'392x392>'},
                    :path_prefix => 'public/attachments',
                    #~ :min_size => 0.kilobytes,
                    #~ :max_size => 10.megabytes,
                    :content_type => ['image/jpeg', 'image/jpeg', 'image/gif', 'image/png', 'image/x-png', 'image/jpg','image/bmp'],

                    :thumbnails => { :small => '10x10', :thumb => '50x50' }




 #~ def save_thumbnail
	#~ content_type = self.content_type
 #~ if content_type.split('/')[0]=="image"	
	 
    #~ require 'RMagick'
    #~ @photo=self
    #~ if @photo
      #~ maxw =  120
      #~ maxh =  50
      #~ aspectratio = maxw.to_f / maxh.to_f
      #~ pic = Magick::Image.read(RAILS_ROOT + "/public#{self.public_filename}").first
      #~ picw = @photo.width
      #~ pich = @photo.height
      #~ picratio = picw.to_f / pich.to_f 
      #~ if picratio > aspectratio then
        #~ scaleratio = maxw.to_f / picw
      #~ else
        #~ scaleratio = maxh.to_f / pich
      #~ end
      #~ begin
			  #~ thumb_col = (32*picw/pich).to_i
				#~ small_col = (51*picw/pich).to_i
        #~ thumb = scaleratio < 1 ? pic.resize(thumb_col,50) : pic        
        #~ small = scaleratio < 1 ? pic.resize(small_col,51) : pic        
        #~ thumb_temp_path =(RAILS_ROOT + "/public/#{self.public_filename(:thumb)}")	
        #~ small_temp_path =(RAILS_ROOT + "/public/#{self.public_filename(:small)}")
        #~ FileUtils.mkdir_p(File.dirname(thumb_temp_path))
        #~ FileUtils.mkdir_p(File.dirname(small_temp_path))
        #~ thumb.write(thumb_temp_path)
        #~ small.write(small_temp_path)
      #~ rescue
        #~ logger.info "Thumbnail cannot be generated"
      #~ end
    #~ end
  #~ end	
  #~ end
end
