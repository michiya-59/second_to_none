# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :seminar

  class << self
    def get_cancel_target_seminar id
      Reservation.joins(:seminar)
        .select('seminars.title, seminars.teacher, seminars.year, seminars.month, seminars.day, seminars.start_time, seminars.end_time,
              reservations.id AS reservation_id, reservations.user_id')
        .where(reservations: {id:}).first
    end

    def get_child_accounts_reservations descendants
      child_reservations = Reservation.where(user_id: descendants)
      child_reservations
    end
  end
end
