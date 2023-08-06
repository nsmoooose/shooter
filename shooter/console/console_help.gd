extends ConsoleCommand

class_name ConsoleHelp

func help() -> String:
	return "Shows help about known commands"

func execute() -> String:
	var s : String = "[b]Help about commands that can be used.[/b]\n\n"

	var p = get_parent()
	for cmd in p.get_children():
		s = str(s, "  [b][color=green]%-20s[/color][/b] %s\n" % [cmd.name, cmd.help()])
	return s
