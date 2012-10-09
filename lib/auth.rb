require 'simple_ldap_authenticator.rb'

SimpleLdapAuthenticator.servers = [APP_CONFIG[:ldap_domain_controller]]
SimpleLdapAuthenticator.logger = Rails.logger
SimpleLdapAuthenticator.use_ssl = true

def ldap_login user,pass
	#r = Logger.new('auth.txt')
	#r.info("Testing user #{user}")
	if l = SimpleLdapAuthenticator.valid?(user,pass)
		#r.info("Validated user #{user}")
		l
	else
		#r.info("Denied user #{user}")
		false
	end
end

def ldap_populate u, user, pass=nil
	if l = (pass ? SimpleLdapAuthenticator.valid?(user,pass)[0] : ldap_search(user))
		u.username = user
		u.name = l['givenname'][0].to_s + " " + l['sn'][0].to_s
		u.administrator = true if(l[:memberof].include? APP_CONFIG[:ldap_domain_administrator_ou] || l[:department] == "Guidance")
		u.save
		u
	else
		false
	end
end

def ldap_named_populate user
	u = User.new
	if l = ldap_name_search(user)
		u.username = user
		u.name = l['givenname'][0].to_s + " " + l['sn'][0].to_s
		u.administrator = false
		u.save
		u
	else
		false
	end
end
	
def ldap_search user
	if l = SimpleLdapAuthenticator.search(user)
		l[0]
	else
		nil
	end
end

def ldap_name_search name
	if l = SimpleLdapAuthenticator.name_search(name)
		l[0]
	else
		nil
	end
end
