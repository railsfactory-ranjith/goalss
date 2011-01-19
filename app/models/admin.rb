require 'digest/sha1'
class Admin < ActiveRecord::Base
	
	has_many :admin_logs
	
	
  # Virtual attribute for the unencrypted password
   attr_accessor :password
  validates_presence_of :firstname,:lastname
  validates_length_of :firstname,:within =>3..40,:message=>"First Name should be with 3 to 40 characters"
  validates_length_of :lastname,:within =>3..40,:message=>"Last Name should be with 3 to 40 characters"
  validates_format_of :firstname,:lastname,:with=>/^([a-zA-Z\s_])*$/,:message=>"Invalid  Name"
  validates_presence_of      :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  #validates_length_of       :email,    :within => 3..100, :message=>"Max 100 and Min 3"
  validates_uniqueness_of   :email, :case_sensitive => false, :message=>"has already taken"
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 6..32, :if => :password_required?
  validates_length_of       :password_confirmation, :within => 6..32, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  #validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 9..50

  validates_uniqueness_of    :email, :case_sensitive => false
  before_save :encrypt_password
 # before_create :make_activation_code 
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible  :email, :password, :password_confirmation,:firstname, :lastname, :is_active, :is_manager,:activated_at,:state

  # Activates the user in the database.
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(email, password)
    # u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email] # need to get the salt
    u = find :first, :conditions => ['email = ? ', email] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  def forgot_password
      @forgotten_password = true
      self.make_password_reset_code
    end
  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
	end
	def reset_password
    # First update the password_reset_code before setting the 
    # reset_password flag to avoid duplicate email notifications.
    update_attributes(:password_reset_code => nil)
    @reset_password = true
	end  
  def recently_forgot_password?
    @forgotten_password
  end
  def recently_reset_password?
    @reset_password
  end
  def recently_activated?
    @recent_active
  end
	protected
  # before filter 
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end
  def password_required?
    crypted_password.blank? || !password.blank?
  end
  def make_activation_code
  self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
	end
  def make_password_reset_code
    self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
end
