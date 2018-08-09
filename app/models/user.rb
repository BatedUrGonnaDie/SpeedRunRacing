class User < ApplicationRecord
  has_many :entrants
  has_many :races, through: :entrants
  has_many :chat_messages

  has_many :applications, class_name: 'Doorkeeper::Application', foreign_key: :owner_id
  has_many :access_grants, class_name: 'Doorkeeper::AccessGrant', foreign_key: :resource_owner_id
  has_many :access_tokens, class_name: 'Doorkeeper::AccessToken', foreign_key: :resource_owner_id

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  validates_uniqueness_of :username
  validates_format_of :username, with: /^[a-zA-Z0-9_]*$/, multiline: true
  validates :username, length: {minimum: 3, maximum: 16}
  validates_with DisplayNameValidator

  def self.searchable_columns
    [:username]
  end

  def to_param
    username
  end

  def active_races
    races.active
  end

  def in_active_race?
    active_races.count.positive?
  end
end
