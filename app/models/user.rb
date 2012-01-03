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
	
	def today_appointments
		if bookable
			(Appointment.where(:user_id => self.id).where(:start => Time.now.beginning_of_day...Time.now.end_of_day) + Appointment.where(:slot_id => bookable.slots).where(:start => Time.now.beginning_of_day...Time.now.end_of_day) ).uniq
		else
			Appointment.where(:user_id => self.id).where(:start => Time.now.beginning_of_day...Time.now.end_of_day)
		end
	end
	
	def email
		"#{username}@#{APP_CONFIG[:ldap_domain_email]}"
	end
end
