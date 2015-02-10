class Gif < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :user, :gif_url
end
