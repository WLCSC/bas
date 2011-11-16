class ContactMailer < ActionMailer::Base
  default from: "support@wl.k12.in.us"
  
  def contact_form_email user, target, message
	@user = user
	@target = target
	@message = message
	mail(:to => target.email, :subject => "Message from the Scheduling System")
  end
end
