class ConflictValidator < ActiveModel::Validator
	def validate(record)
		unless record.start #make sure this happens
			record.prep_time
		end
		if record.start < Time.now
			record.errors[:base] << "You can't make appointments in the past."
		end
		d = Appointment.where(:start => record.start.beginning_of_day...record.start.end_of_day) - [record]
		d.each do |x|
			if x.slot == record.slot
				record.errors[:base] << "This appointment conflicts with #{x.id}"
			end
		end
	end
end	

class Appointment < ActiveRecord::Base
	before_create :prep_time
	attr_accessor :bookable_id, :date
	belongs_to :slot
	belongs_to :user
	belongs_to :kind
	has_one :bookable, :through => :slot
	validates_with ConflictValidator, :on => :create
	
	
	def prep_time
		unless self.slot
			raise "No slot attached to appointment"
		end	
		
		self.start = date.beginning_of_day + slot.start_time
		self.end = date.beginning_of_day + slot.end_time
	end
	
	def bookable
		self.slot.bookable
	end
	
	def initialize(attributes={})
		date_hack(attributes, 'date')
		super(attributes)
	end	
	
	def date_hack(attributes, property)
		keys, values = [], []
		attributes.each_key {|k| keys << k if k =~ /#{property}/ }.sort
		keys.each { |k| values << attributes[k]; attributes.delete(k); }
		attributes[property] = values.join("-")		
	end
	
	#spits out a hash that will be piped through to be nicely displayed on a calendar
	def calendarify(f,highlight=false)
		slot = Slot.find(self.slot_id)
		bk = Bookable.find(slot.bookable_id)
		if bk.user == self.user
			r = {:id => self.id, :start => self.start.iso8601, :end => self.end.iso8601, :title => "Unavailable", :allDay => false, :description => self.kind.name, :color => "#888"}
			if highlight
				r[:color] = "#800" 
			end
		else
			r = {:id => self.id, :start => self.start.iso8601, :end => self.end.iso8601, :title => (f.bookable ? (self.user.name || self.user.username) : (bk.user.name || bk.user.username)), :allDay => false, :url => "/appointments/#{self.id}", :description => self.kind.name}
			if highlight
				r[:color] = "#CC0" 
			end
		end
		
		r
	end
end


