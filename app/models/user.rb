class User < ActiveRecord::Base
   attr_accessor :password
   attr_accessible :name, :email, :password, :password_confirmation, :aboutme, :affiliatedorgs, :school, :fblink, :avatar 

   has_many :events, :dependent => :destroy
   
   has_attached_file :avatar, :styles => { :small => "150x150>" }, :storage => :s3, :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", :path => ":attachment/:id/:style.:extension", :bucket => "ColumbiaEventsApp"
   
   email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
   
   validates :name, :presence => true,
                    :length   => { :maximum => 50 }
   validates :email, :presence => true,
                     :format   => { :with => email_regex },
                     :uniqueness => { :case_sensitive => false }
   validates :password, :presence => true,
                        :confirmation => true,
                        :length => { :within => 6..40 }
                        
   before_save :encrypt_password
   
   def has_password?(submitted_password)
     encrypted_password == encrypt(submitted_password)
   end
   
   def self.authenticate(email, submitted_password)
     user = find_by_email(email)
     return nil if user.nil?
     return user if user.has_password?(submitted_password)
   end
   
   def self.authenticate_with_salt(id, cookie_salt)
     user = find_by_id(id)
     (user && user.salt == cookie_salt) ? user : nil
   end
   
   private
   
      def encrypt_password
        self.salt = make_salt if new_record?#uses an Active Record attribute
        self.encrypted_password = encrypt(password)
      end
      
      def encrypt(string)
        secure_hash("#{salt}--#{string}")
      end
      
      def make_salt
        secure_hash("#{Time.now.utc}--#{password}")
      end
      
      def secure_hash(string)
        Digest::SHA2.hexdigest(string)
      end
end
