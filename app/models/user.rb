class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed

	#other relationship
	has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
	has_many :followers, through: :reverse_relationships, source: :follower

	before_save { self.email = email.downcase }
	before_create :create_remember_token

	has_secure_password
	validates :name,presence: true,length: { maximum: 140}
	VALID_EMAIL_REGEX=/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email,presence: true,format: { with: VALID_EMAIL_REGEX },
			   uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }

	def User.new_remember_token
    	SecureRandom.urlsafe_base64
  	end

  	def User.encrypt(token)
  		Digest::SHA1.hexdigest(token.to_s)
  	end

  	def feed
  		Micropost.where("user_id = ?", id)
  	end

  	#followed and following
  	def follow!(other_user)
  		relationships.create!(followed_id: other_user.id)
  	end

  	def following?(other_user)
  		relationships.find_by(followed_id: other_user.id)
  	end

  	def unfollowed!(other_user)
  		relationships.find(followed_id: other_user.id).destroy
  	end
  	
	private 
	def create_remember_token
		self.remember_token=User.encrypt(User.new_remember_token)
	end
end
