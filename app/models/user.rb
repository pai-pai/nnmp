class User < ActiveRecord::Base
    include BCrypt

    attr_accessible :email, :password, :remember_token

    validates_presence_of :email, :password

    validates_uniqueness_of :email

    validates_format_of :email, :with => /.+@.+\..+/i

    before_save { |user| user.email = email.downcase }
    before_save :create_remember_token

    def password
        @password ||= Password.new(password_hash)
    end

    def password=(new_password)
        @password =Password.create(new_password)
        self.password_hash = @password
    end

    private
        def create_remember_token
            self.remember_token = SecureRandom.urlsafe_base64
        end
end
