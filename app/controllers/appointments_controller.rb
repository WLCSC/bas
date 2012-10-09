class AppointmentsController < ApplicationController
	before_filter :check_for_user
	autocomplete :user, :name
	# GET /appointments
	# GET /appointments.json
	def index
		@appointments = Appointment.all
		if params[:bookable_id]
			@bookable = Bookable.find(params[:bookable_id])
		end

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @appointments.map{|a| a.calendarify(current_user)} }
		end
	end

	# GET /appointments/1
	# GET /appointments/1.json
	def show
		@appointment = Appointment.find(params[:id])
		@slot = Slot.find(@appointment.slot_id)
		@bookable = Bookable.find(@slot.bookable_id)

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @appointment }
			format.ics
		end
	end

	# GET /appointments/new
	# GET /appointments/new.json
	def new
		if params[:bookable_id]
			@appointment = Appointment.new
			@bookable = Bookable.find(params[:bookable_id])

			respond_to do |format|
				format.html # new.html.erb
				format.json { render json: @appointment }
			end
		else
			redirect_to bookables_path
		end
	end

	# GET /appointments/1/edit
	def edit
		@appointment = Appointment.find(params[:id])
	end

	# POST /appointments
	# POST /appointments.json
	def create
		@appointment = Appointment.new(params[:appointment])

		if params[:date]
			y = params[:date][:year].to_i
			m = params[:date][:month].to_i
			d= params[:date][:day].to_i
			@appointment.date = Date.new(y,m,d)
		end
		failure = false
		if !current_user.administrator && (@appointment.date >= (Date.today + 2.weeks + 1.day))
			failure = true
			#raise "Fail"
		end

		@slot = Slot.find(@appointment.slot_id)
		@bookable = Bookable.find(@slot.bookable_id)

		respond_to do |format|
			unless failure
			if @appointment.save
				x = Date.today + 3
				r = Date.today ... x
				if r === @appointment.day
					logger.info "Sending notice"
					AppointmentMailer.today_change_email(@appointment).deliver
				end
				format.html { redirect_to @appointment, notice: 'Appointment was successfully created.  Please make sure the listed time & date are correct and that you are seeing the right person.' }
				format.json { render json: @appointment, status: :created, location: @appointment }
			else
				format.html { render action: "new", notice: @appointment.errors.first }
				format.json { render json: @appointment.errors, status: :unprocessable_entity }
			end
			else
				format.html { redirect_to @bookable, notice: "You are not allowed to make appointments that far in the future." }
				format.json { render json: @appointment.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /appointments/1
	# PUT /appointments/1.json
	def update
		@appointment = Appointment.find(params[:id])

		respond_to do |format|
			if @appointment.update_attributes(params[:appointment])
				format.html { redirect_to @appointment, notice: 'Appointment was successfully updated.' }
				format.json { head :ok }
			else
				format.html { render action: "edit" }
				format.json { render json: @appointment.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /appointments/1
	# DELETE /appointments/1.json
	def destroy
		@appointment = Appointment.find(params[:id])
		x = Date.today + 3
		r = Date.today ... x
		if r === @appointment.day
			logger.info "Sending Cancellation Notice"
			AppointmentMailer.today_cancel_email(@appointment).deliver
		end
		@appointment.destroy

		respond_to do |format|
			format.html { redirect_to root_url }
			format.json { head :ok }
		end
	end


	#JSON of all appointments for a given user
	def for
		@user = User.find params[:id]
		respond_to do |format|
			format.json { render json: @user.appointments.map{|a| a.id==params[:h].to_i ? a.calendarify(current_user, true) : a.calendarify(current_user)} }
		end
	end
end
