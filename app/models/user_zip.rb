class UserZip < ApplicationRecord
  belongs_to :user
  belongs_to :zippo
end
