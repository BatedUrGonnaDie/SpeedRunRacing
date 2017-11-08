class User < ApplicationRecord
  has_many :entrants
  has_many :races, through: :entrants

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  validates_uniqueness_of :username
  validates_with DisplayNameValidator

  def in_active_race?
    races.active.count > 0
  end
end
