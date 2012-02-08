module ApplicationHelper
	#yes, I'm aware this is ugly.  It'll get refactored out sooner or later.
	def calendar_script_tag events, bookable = nil
	r = "<script>
		
function pad2(number) {
	return (number < 10 ? '0' : '') + number
}
"
	if bookable
		 r += "
			slots = [
				#{bookable.slots.map{|s| "[#{s.id}, #{s.start_time}, #{s.end_time}]"}.join(", \n")}
			];
		 "
	end
	
		r += 
	"$(document).ready(function() {
		$('#calendar').fullCalendar({
			weekends:false,
			defaultView: 'agendaWeek',
			header: {left: 'prev next', center: 'title', right: 'month agendaWeek agendaDay'},
			events: '/#{events}',
			allDaySlot: false,
			slotMinutes: 5,
			firstHour: 7,
			minTime: 7,
			maxTime: 16,
			eventColor: '#C00'
			"
			r += ",
			
			dayClick: function(date, allDay, jsEvent, view) {
				$('#date_year').val(date.getFullYear());
				$('#date_month').val(date.getMonth() + 1);
				$('#date_day').val(date.getDate());
				
				h = date.getHours();
				
				s = h*60*60 + date.getMinutes()*60;
				
				if(h > 12) {
					h = h - 12;
				}
				h = pad2(h);
				m = pad2(date.getMinutes());
				match=false;
				for(var i=0; i<slots.length; i++) {
					var slot = slots[i];
					if(slot[1] <= s && slot[2] >=s ) {
						$('#appointment_slot_id').val(slot[0]);
						match = true;
					}
				}
				if(match) {
					$('#appt_form').css('display', 'block');
				}else{
					$('#appt_form').css('display', 'none');
				}
				
			}" if bookable
		r += "});
	});
  </script>"
		r.html_safe	
	end
	
	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end
end
