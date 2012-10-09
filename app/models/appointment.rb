require 'auth.rb'

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
	before_save :fix_name
	attr_accessor :bookable_id, :date, :notes, :user_name
	belongs_to :slot
	belongs_to :user
	belongs_to :kind
	has_one :bookable, :through => :slot
	validates_with ConflictValidator, :on => :create
	
	def fix_name
		if self.user_name && self.user_name != ""
			u = User.where(:name => self.user_name).first
			unless u
				u = ldap_named_populate(self.user_name)
			end
			self.user = u
		end
	end
	
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
	
	def day
		date || self.start.to_date
	end

	def to_ical
		e = Icalendar::Event.new
		e.uid = "BAS_EVENT_ID##{self.id}"
		e.dtstart = self.start
		e.dtend = self.end
		e.summary = "#{self.user.name} - #{self.kind.name}"
		e.created=self.created_at
		e.url = "http://bas/appointments/#{self.id}"
		e.last_modified = self.updated_at
		e
	end

	#spits out a hash that will be piped through to be nicely displayed on a calendar
	def calendarify(f,highlight=false)
		slot = Slot.find(self.slot_id)
		bk = Bookable.find(slot.bookable_id)
		r={}
		r[:id] = self.id
		r[:start] = self.start.iso8601
		r[:end] = self.end.iso8601
		r[:allDay] = false
		if f.admin?
			r[:title] = "#{self.user.name} with #{bk.user.name ? bk.user.name : bk.user.username} (#{self.kind.name})"
			r[:url] = "/appointments/#{self.id}"
			r[:description] = self.kind.name
			if highlight
				r[:color] = "#3AA"
			else
				r[:color] = "#22F"
			end
			if bk.user == self.user
				if highlight
					r[:color] = "#888"
				else
					r[:color] = "#444"
				end
			end
		elsif bk.user == self.user
			r[:title] = "Unavailable"
			r[:color] = "#888"
		elsif bk == f.bookable
			r[:title] = "Appointment with #{self.user.name}"
			r[:url] = "/appointments/#{self.id}"
			r[:description] = self.kind.name
			if highlight
				r[:color] = "#AA0"
			else
				r[:color] = "#C00"
			end
		elsif self.user == f
			r[:title] = "Appointment with #{bk.user.name ? bk.user.name : bk.user.username}"
			r[:url] = "/appointments/#{self.id}"
			r[:description] = self.kind.name
			if highlight
				r[:color] = "#CC0"
			else
				r[:color] = "#C00"
			end
		else
			r[:title] = "Unavailable"
			r[:color] = "#777"
		end
		
		r
	end
end


