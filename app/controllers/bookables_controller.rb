class BookablesController < ApplicationController
	before_filter :check_for_user
  # GET /bookables
  # GET /bookables.json
  def index
    @bookables = Bookable.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bookables }
    end
  end

  # GET /bookables/1
  # GET /bookables/1.json
  def show
    @bookable = Bookable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bookable }
    end
  end

  # GET /bookables/new
  # GET /bookables/new.json
  def new
    @bookable = Bookable.new
	@bookable.user_id = params[:user_id] if params[:user_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bookable }
    end
  end

  # GET /bookables/1/edit
  def edit
    @bookable = Bookable.find(params[:id])
  end

  # POST /bookables
  # POST /bookables.json
  def create
    @bookable = Bookable.new(params[:bookable])

    respond_to do |format|
      if @bookable.save
		@bookable.slot_scaffold
        format.html { redirect_to @bookable, notice: 'Bookable was successfully created.' }
        format.json { render json: @bookable, status: :created, location: @bookable }
      else
        format.html { render action: "new" }
        format.json { render json: @bookable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bookables/1
  # PUT /bookables/1.json
  def update
    @bookable = Bookable.find(params[:id])

    respond_to do |format|
      if @bookable.update_attributes(params[:bookable])
        format.html { redirect_to @bookable, notice: 'Bookable was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @bookable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookables/1
  # DELETE /bookables/1.json
  def destroy
    @bookable = Bookable.find(params[:id])
    @bookable.destroy

    respond_to do |format|
      format.html { redirect_to bookables_url }
      format.json { head :ok }
    end
  end
  
  
  #spits out JSON of given bookable's events
  def events
	@bookable = Bookable.find(params[:id])
	@start = Time.at(params[:start].to_i) || nil
	@end = Time.at(params[:end].to_i) || nil

    respond_to do |format|
      format.json { render json: @bookable.events(@start,@end) }
    end
  end
  
  #sends email from contact form
  def contact_email
	t = User.find(params[:target])
	ContactMailer.contact_form_email(current_user,t, params[:message]).deliver
	flash[:notice] = "Email sent to #{t.email}"
	redirect_to t.bookable
  end
  
  #updates schedule with blocked out days
  def block
	#raise 'die'
	start = DateTime.new(params[:block]['begin(1i)'].to_i, params[:block]['begin(2i)'].to_i, params[:block]['begin(3i)'].to_i,params[:block]['begin(4i)'].to_i,params[:block]['begin(5i)'].to_i)
	stop = DateTime.new(params[:block]['stop(1i)'].to_i, params[:block]['stop(2i)'].to_i, params[:block]['stop(3i)'].to_i,params[:block]['stop(4i)'].to_i,params[:block]['stop(5i)'].to_i)
	bookable = Bookable.find(params[:bookable_id])
	
	start_day = start.to_date
	stop_day = stop.to_date
	
	d = start_day
	bookable.slots.each do |s|
		if s.start_time > (start.to_time - start.beginning_of_day)
		a = Appointment.new
		a.slot = s
		a.date = d
		a.user = bookable.user
		a.kind = Kind.find_by_name('Other')
		a.save
		end
	end
	
	d = stop_day
	bookable.slots.each do |s|
		if s.end_time < (stop.to_time - stop.beginning_of_day)
		a = Appointment.new
		a.slot = s
		a.date = d
		a.user = bookable.user
		a.kind = Kind.find_by_name('Other')
		a.save
		end
	end
	
	(start_day+1..stop_day-1).to_a.each do |d|
		bookable.slots.each do |s|
			a = Appointment.new
			a.slot = s
			a.date = d
			a.user = bookable.user
			a.kind = Kind.find_by_name('Other')
			a.save
		end
	end
	redirect_to bookable
	
  end
end
