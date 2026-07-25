class BookingMailer < ApplicationMailer
  def request_received(booking)
    @booking = booking
    mail(to: booking.client.email_address, subject: "VinylCTRL booking request #{booking.reference}")
  end

  def new_booking_alert(booking)
    @booking = booking
    mail(to: booking.talent.email_address, subject: "New VinylCTRL booking request")
  end

  def status_update(booking)
    @booking = booking
    mail(to: booking.client.email_address, subject: "Booking #{booking.reference} is now #{booking.status}")
  end
end
