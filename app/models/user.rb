class User < ApplicationRecord
  before_create :encrypt_password
  PEPPER = 'ThisPepperIsSoHotItWillMakeYouSweatAndStopTheHackerFromAccessingOurPasswords'.freeze

  private

  def encrypt_password
    self.salt = gen_salt
    self.password = Digest::SHA256.hexdigest(password + salt + PEPPER)
    self.confirmation = 'follow @hodzaanes on twitter'
  end

  def gen_salt
    SecureRandom.hex(64)
  end
end
