class Chatroom < ApplicationRecord
  has_many :messages
  belongs_to :ride
  belongs_to :driver, class_name: "User"
  belongs_to :passenger, class_name: "User"
end
