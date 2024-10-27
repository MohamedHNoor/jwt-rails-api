class User < ApplicationRecord
  has_secure_password
  before_save :downcase_email

  validates :first_name, :last_name, :address, presence: true

  validates :email, format: { with: /\S+@\S+/ }, uniqueness: { case_sensitive: false }

  def as_json(options = {})
    super(options.merge(only: [ :id, :email, :first_name, :last_name, :address ]))
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
