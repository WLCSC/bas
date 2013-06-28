class MultiviewController < ApplicationController
  def new
	  @bookables = Bookable.all
  end

  def show
	  @bookables = Bookable.where(:id => params[:BK])
	  @slot_ids = @bookables.map{|b| b.slot_ids}.flatten
	  @appointments = Appointment.where(:slot_id => @slot_ids).map{|a| a.calendarify(current_user)}
	  respond_to do |format|
		format.html 
		format.json {render json: @appointments}
	  end
  end

end
