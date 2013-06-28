desc "Deliver all the emails"
task :deliver_digests => :environment do
	Bookable.all.each do |b|
		AppointmentMailer.daily_digest(b.user).deliver
	end
end

task :test_digest => :environment do
	b = User.first.bookable
	AppointmentMailer.daily_digest(b.user).deliver
end
