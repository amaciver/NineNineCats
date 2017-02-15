class CatRentalRequest < ApplicationRecord
  validates :cat_id, :start_date, :end_date, presence: true
  validates :status, inclusion: { in: ['PENDING', 'APPROVED', 'DENIED'] }
  validate :no_overlapping_approved_requests

  belongs_to :cat

  def approve!
    self.status = "APPROVED"
    if self.update
      redirect_to cat_url(self.cat_id)
    else
      self.status = "DENIED"
      redirect_to new_cat_rental_request_url
    end
  end

  def overlapping_requests
    CatRentalRequest.where(cat_id: self.cat_id)
      .where.not(<<-SQL, start_date: self.start_date, end_date: self.end_date)
        start_date > :end_date OR end_date < :start_date
      SQL
  end

  def no_overlapping_approved_requests
    unless overlapping_requests.where(status: "APPROVED").empty?
      errors.add(:overlap, "overlaps with existing rental")
    end
  end

end
