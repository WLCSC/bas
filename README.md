BAS
========

A simple appointment scheduling app.

How To
------

* bundle install
* edit/create config/database.yml & config/app_config.yml
* edit config/initializers/setup_mail.rb with your mail server details
* rake db:setup

Note that at the moment, since users don't exist until either they log in or are force created by an admin, you'll need to manually add your first user via the console (create a new user with username=your username & administrator=true).  Once you have your first user, you can create more users by logging in, going to the 'manage users' link, and force creating users at the bottom of the page.

To start making appointments, first you need to mark a user as bookable.  On the 'manage users' page, there are links to do so.  Once you've done that, you need to define slots for this person's appointments - done on the 'manage slots' page.  You also need to define types of appointments on the 'manage appointment types' page.  

Once you've done that, users can click the 'make & view appointments' page, choose which person they want an appointment with, click the calendar where they want their appointment, indicate what kind of appointment it is, and confirm & save the appointment.

Copyright 2011, 2012 Brad Thompson
Distributed under the terms of the GNU General Public License

    BAS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    BAS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with BAS.  If not, see <http://www.gnu.org/licenses/>.