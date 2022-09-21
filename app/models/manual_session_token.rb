class ManualSessionToken < ApplicationRecord
  belongs_to :user
  before_save :encrypt_session_key
  PEPPER = 'ThisPepperIsSoHotItWillMakeYouSweatAndStopTheHackerFromAccessingOurPasswords'.freeze

  private

  def encrypt_session_key
    self.salt = gen_salt
    self.key = Digest::SHA256.hexdigest(key + salt + PEPPER)
  end

  def gen_salt
    SecureRandom.hex(64)
  end
end
