class Cat < ApplicationRecord
  COLORS = ['Red', 'Blue', 'Green', 'Purple']

  validates :birth_date, :color, :name, :sex, presence: true
  validates :color, inclusion: { in: COLORS }
  validates :sex, inclusion: { in: ['M', "F"] }

  has_many :cat_rental_requests, :dependent => :destroy

  def age
    ((Date.today - self.birth_date)/365).to_i
  end
end
