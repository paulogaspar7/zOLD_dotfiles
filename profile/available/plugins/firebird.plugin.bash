cite about-plugin
about-plugin 'Firebird database related functions'

fb.restart() {
	about 'restart Firebird database server'
	group 'firebird'

	sudo /sbin/SystemStarter restart "Firebird Server"
}


fb.start() {
	about 'start Firebird database server'
	group 'firebird'

	sudo /sbin/SystemStarter stop "Firebird Server"
}



fb.stop() {
	about 'stop Firebird database server'
	group 'firebird'

	sudo /sbin/SystemStarter stop "Firebird Server"
}

