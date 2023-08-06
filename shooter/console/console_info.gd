extends ConsoleCommand

class_name ConsoleInfo

func help() -> String:
	return "Shows information about the current game"

func execute() -> String:
	var s = "[b]Local system IP addresses:[/b]\n\n"
	for x in IP.get_local_addresses():
		s = str(s, "  %s\n" % x)
	s = str(s, "\n")
	return s
