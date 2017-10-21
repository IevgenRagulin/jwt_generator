require_relative 'email_validator'
require 'jwt'
require 'clipboard'

class JWTGenerator
  @@HMAC_SECRET = 'SecretKey'.freeze

  attr_reader :payload
  # Gets key/value pairs from the user, generates JWT token based on the input,
  # copies the JWT token to the clipboard
  def jwt_me
    @keys = %w[user_id email]
    @payload = {}
    puts('Starting with JWT token generation.')
    @payload['user_id'] = get_value_from_cmd('user_id', false)
    @payload['email'] = get_value_from_cmd('email', true)
    ask_for_optional_keys_values
    token = JWT.encode(@payload, @@HMAC_SECRET, 'HS256')
    Clipboard.copy(token)
    puts('The JWT token has been copied to your clipboard!')
  end

  def self.hmac_secret
    # Return the value of this variable
    @@HMAC_SECRET
  end

  private

  # Asks for additional optional key/value pairs
  def ask_for_optional_keys_values
    @key_num = 3
    loop do
      puts("You have entered #{@keys.join(', ')}. Enter Key##{@key_num}."\
       " Leave input empty if you don't want an additional key")
      key = gets.chomp
      break if key.empty?
      @keys << key
      @payload[key] = get_value_from_cmd(key, false)
      @key_num += 1
    end
  end

  # Gets value for key from CMD. Doesn't allow empty values
  # If is_email is true, validates email
  def get_value_from_cmd(key, is_email)
    puts("Enter #{key} value")
    value = gets.chomp
    if is_email && !EmailValidator.valid?(value)
      puts("email #{value} is invalid")
      get_value_from_cmd(key, true)
    elsif value.empty?
      puts("#{key} cannot be empty")
      get_value_from_cmd(key, false)
    else
      return value
    end
  end
end