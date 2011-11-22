Bookable
========

A simple appointment scheduling app.

How To
------

* bundle install
* edit/create config/database.yml & config/app_config.yml
* rake db:create

Note that at the moment, since users don't exist until either they log in or are force created by an admin, you'll need to manually add your first user via the console (create a new user with username=your username & administrator=true).  Once you have your first user, you can create more users by logging in, going to the 'manage users' link, and force creating users at the bottom of the page.

To start making appointments, first you need to mark a user as bookable.  On the 'manage users' page, there are links to do so.  Once you've done that, you need to define slots for this person's appointments - done on the 'manage slots' page.  You also need to define types of appointments on the 'manage appointment types' page.  

Once you've done that, users can click the 'make & view appointments' page, choose which person they want an appointment with, click the calendar where they want their appointment, indicate what kind of appointment it is, and confirm & save the appointment.
