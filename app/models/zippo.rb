class Zippo < ApplicationRecord
  has_many :user_zips
  has_many :users, through: :user_zips

  validates :zipcode, presence: true
  validates :country, presence: true

  scope :recent_user_searches, -> (user_id) { joins(:users).where("users.id = ?", user_id).order('created_at desc') }

  def self.build_with_json(obj)
    z = {}
    z[:zipcode] = obj['post code']
    z[:country] = obj['country']
    z[:country_abbr] = obj['country abbreviation']
    z[:places] = obj['places'].to_json

    z
  end
end
