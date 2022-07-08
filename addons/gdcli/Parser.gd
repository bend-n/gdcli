extends Reference
class_name Parser

var target_args := []


func add_argument(arg: Arg):
	target_args.append(arg)


func parse_arguments():
	var cmdline_args = Array(OS.get_cmdline_args())
	var args := {unhandled = []}
	var i := -1
	var star: String
	while i < len(cmdline_args) - 1:
		i += 1
		var res := __search_target_args(cmdline_args[i])
		if res:
			if res.n_args:
				args[res.dest] = cmdline_args.slice(i + 1, i + res.n_args)
				i += res.n_args
				star = ""
			else:
				match res.arg_type:
					"*":
						star = res.dest
						args[res.dest] = cmdline_args.slice(i + 1, i)
		else:
			if star:
				args[star].append(cmdline_args[i])
				breakpoint
			else:
				args.unhandled.append(cmdline_args[i])
	for r in target_args:
		if not r.dest in args:
			args[r.dest] = r.default
	return args


func __search_target_args(to_find: String) -> Arg:
	for arg in target_args:
		if arg.find_trigger(to_find):
			return arg
	return null


func help() -> String:
	var size = 1
	for arg in target_args:  # find the longest arguments
		size = len(arg.format_triggers()) if len(arg.format_triggers()) > size else size

	var options := ""
	var usage := "godot "
	for arg in target_args:
		usage += "[%s] " % arg.small_arg()
		options += arg.format_triggers() + "   "

		for _i in range(size - len(arg.format_triggers())):
			options += " "
		options += arg.help + "\n"
	var help = """
usage: {usage}

{description}

options: 
{options}
""".format(
		{usage = usage, description = "", options = options.indent("  ")}
	)
	return help
