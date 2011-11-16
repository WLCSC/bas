class User < ActiveRecord::Base
	attr_accessor :password
	
	has_many :appointments
	has_one :bookable
	
	def admin?
		self.administrator
	end
	
	def appointments
		if bookable
			(Appointment.where(:user_id => self.id) + Appointment.where(:slot_id => bookable.slots)).uniq
		else
			Appointment.where(:user_id => self.id)
		end
	end
	
	def email
		"#{username}@wl.k12.in.us"
	end
end
