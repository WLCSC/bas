task :deliver_digests => :environment do
	Bookable.all.each do |b|
		AppointmentMailer.daily_digest(b.user).deliver
	end
end