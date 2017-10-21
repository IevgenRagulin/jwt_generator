class EmailValidator
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def self.valid?(email)
    email =~ VALID_EMAIL_REGEX
  end
end