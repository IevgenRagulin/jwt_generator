require_relative '../../lib/jwt_generator'
require_relative '../spec_helper'

RSpec.describe(JWTGenerator) do
  EMPTY = "\n".freeze
  VALID_USER_ID = "123\n".freeze
  VALID_EMAIL = "email@email.com\n".freeze
  INVALID_EMAIL = "email@email\n".freeze
  KEY_1 = "City\n".freeze
  VALUE_1 = "Ostrava\n".freeze

  describe 'jwt_me' do
    it 'requires user_id to be not empty' do
      generator = JWTGenerator.new
      allow(generator).to(receive(:gets).and_return(EMPTY, VALID_USER_ID, VALID_EMAIL, EMPTY))
      expect { generator.jwt_me }.to(output(/user_id cannot be empty/).to_stdout)
    end
    it 'requires email to be not empty' do
      generator = JWTGenerator.new
      allow(generator).to(receive(:gets).and_return(VALID_USER_ID, EMPTY, VALID_EMAIL, EMPTY))
      expect { generator.jwt_me }.to(output(/email  is invalid/).to_stdout)
    end
    it 'requires email to be valid' do
      generator = JWTGenerator.new
      allow(generator).to(receive(:gets).and_return(VALID_USER_ID, INVALID_EMAIL, VALID_EMAIL, EMPTY))
      expect { generator.jwt_me }.to(output(/email #{INVALID_EMAIL.chomp} is invalid/).to_stdout)
    end
    it 'skips optional keys if empty input is provided' do
      generator = JWTGenerator.new
      allow(generator).to(receive(:gets).and_return(VALID_USER_ID, INVALID_EMAIL, VALID_EMAIL, EMPTY))
      generator.jwt_me
      expect(generator.payload.keys.size).to(eql(2))
    end
    it 'requires additional keys to be not empty' do
      generator = JWTGenerator.new
      allow(generator).to(receive(:gets).and_return(VALID_USER_ID, INVALID_EMAIL, VALID_EMAIL, KEY_1, EMPTY, VALUE_1,
                                                    EMPTY))
      expect { generator.jwt_me }.to(output(/#{KEY_1.chomp} cannot be empty/).to_stdout)
    end
    it 'allows to provide additional keys' do
      generator = JWTGenerator.new
      allow(generator).to(receive(:gets).and_return(VALID_USER_ID, INVALID_EMAIL, VALID_EMAIL, KEY_1, VALUE_1, EMPTY))
      generator.jwt_me
      expect(generator.payload.keys.size).to(eql(3))
      expect(generator.payload[KEY_1.chomp]).to(eql(VALUE_1.chomp))
    end
    it 'copies correct decodable JWT to clipboard' do
      generator = JWTGenerator.new
      allow(generator).to(receive(:gets).and_return(VALID_USER_ID, INVALID_EMAIL, VALID_EMAIL, KEY_1, VALUE_1, EMPTY))
      generator.jwt_me
      token = Clipboard.paste
      expect(token).not_to(be_empty)
      decoded_token = JWT.decode(token, JWTGenerator.hmac_secret, true, { algorithm: 'HS256' })
      expect(decoded_token[0].keys.size).to(eql(3))
      expect(decoded_token[0]['user_id']).to(eql(VALID_USER_ID.chomp))
      expect(decoded_token[0]['email']).to(eql(VALID_EMAIL.chomp))
      expect(decoded_token[0][KEY_1.chomp]).to(eql(VALUE_1.chomp))
    end
  end
end