class User < ApplicationRecord
  
  attr_accessor :remember_token
  
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  before_save { self.email = email.downcase }
  validates :name,  presence: true,  length: { maximum: 50 }
  validates :email, presence: true,  length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :email, format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  
  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64 # 標準のmodele
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
end