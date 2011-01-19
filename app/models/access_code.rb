class AccessCode < ActiveRecord::Base
    validates_presence_of :access_code
end
