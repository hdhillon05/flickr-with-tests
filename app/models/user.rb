class User < ActiveRecord::Base
  has_secure_password validations: false

  validates :username, :email, presence: true
  validates :username, :email, uniqueness: true

      def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.info.name
      user.email = auth.info.name
      user.password = auth.credentials.token 
      user.password_confirmation = auth.credentials.token
      user.oauth_token = auth.credentials.oauth_token
      user.save!
    end
  end
end
