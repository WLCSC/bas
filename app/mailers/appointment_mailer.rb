class AppointmentMailer < ActionMailer::Base
  default from: "guidance@wl.k12.in.us"
  
  def today_change_email appointment
	@user = appointment.user
	slot = Slot.find(appointment.slot_id)
	@bookable = Bookable.find(slot.bookable_id)
	@appointment = appointment
	mail(:to => @bookable.user.email, :subject => "New appointment scheduled for today")
  end
  
  def today_cancel_email appointment
	@user = appointment.user
	slot = Slot.find(appointment.slot_id)
	@bookable = Bookable.find(slot.bookable_id)
	@appointment = appointment
	mail(:to => @bookable.user.email, :subject => "Canceled appointment")
  end
end
