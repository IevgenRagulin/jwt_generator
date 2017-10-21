require 'email_validator'
require_relative 'spec_helper'

RSpec.describe(EmailValidator) do
  describe :valid? do
    it 'returns 0 for valid email' do
      expect(EmailValidator.valid?('email@email.com')).to(eql(0))
    end
    it 'returns nil for invalid email' do
      expect(EmailValidator.valid?('email')).to(be_nil)
    end
    it 'returns nil for invalid email' do
      expect(EmailValidator.valid?('email@')).to(be_nil)
    end
    it 'returns nil for invalid email' do
      expect(EmailValidator.valid?('email@mail')).to(be_nil)
    end
    it 'returns nil for invalid email' do
      expect(EmailValidator.valid?('@mail.com')).to(be_nil)
    end
    it 'returns nil for invalid email' do
      expect(EmailValidator.valid?('e!@#$%^&**(.@mail.com')).to(be_nil)
    end
  end
end