class Bookable < ActiveRecord::Base
	has_many :slots
	belongs_to :user
	
	has_attached_file :avatar, :styles => { :medium => "200x200>", :thumb => "64x64>" }	
	def appointments
		Appointment.where(:slot_id => self.slots.map{|s| s.id})
	end
	
	def events(s,e)
		if s && e
			e = self.appointments.where(:start => Time.at(s)...Time.at(e))
		else
			e = self.appointments.all
		end
		
		e.map{|a| a.calendarify(self.user)}
	end
	
	def busy? time
		appointments.each do |a|
			return true if (time < a.end && time > a.start)
		end
		false
	end
	
	def busy time
		busy? time
	end
	
	def slot_scaffold
		self.slots.each do |s|
			s.delete
		end
		
		#load scaffold
		scaffold = ""
		File.open('lib/scaffold.txt','r') do |f|
			scaffold  = f.read
		end
		i=1
		scaffold.each_line do |line|
			times = line.split("-")
			s = Slot.new nil, nil
			s.name = self.user.name + " " + i.to_s
			i+= 1
			s.bookable_id = self.id
			s.start_time = times[0].to_i
			s.end_time = times[1].to_i
			s.save
		end
	end
	
	
end
