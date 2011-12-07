class Slot < ActiveRecord::Base
	attr_accessor :start, :endt
	before_create :prep_times
	belongs_to :user
	belongs_to :slot
	belongs_to :kind
	has_one :bookable, :through => :slot
	has_one :owner, :through => :bookable, :class_name => 'User'
	
	def prep_times
		if self.start && self.end
			self.start_time = (self.start.split('-')[4].to_i * 60) + (self.start.split('-')[3].to_i * 60 * 60)
			self.end_time = (self.endt.split('-')[4].to_i * 60) + (self.endt.split('-')[3].to_i * 60 * 60)
		end
	end
	
	def initialize(attributes={},s,e)
		attributes[:start] = s.map{|p| p[1] }.join('-') if s
		attributes[:endt] = e.map{|p| p[1] }.join('-') if e
		super(attributes)
	end
	
	def pretty_start
		(Time.now.beginning_of_day + self.start_time.to_i).strftime("%I:%M %p")
	end
	
	def pretty_end
		(Time.now.beginning_of_day + self.end_time.to_i).strftime("%I:%M %p")
	end
	
	def start_for(day)
		(day.to_time.beginning_of_day + self.start_time).to_datetime
	end
	
	def end_for(day)
		(day.to_time.beginning_of_day + self.end_time).to_datetime
	end

end
