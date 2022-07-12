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
			star = ""
			if res.action == "store":
				args[res.dest] = cmdline_args.slice(i + 1, i + res.n_args)
				i += res.n_args
			elif res.action == "store_true":
				args[res.dest] = true
			else:
				match res.arg_type:
					"*":
						star = res.dest
						args[res.dest] = cmdline_args.slice(i + 1, i)
		else:
			if star:
				args[star].append(cmdline_args[i])
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


func help(description := "") -> String:
	var size = 1
	for arg in target_args:  # find the longest arguments
		size = len(arg.format_triggers()) if len(arg.format_triggers()) > size else size

	var options := ""
	var usage := (
		"%s%s [options...]"
		% [ProjectSettings.get_setting("application/config/name"), exec_ext()]
	)
	for arg in target_args:
		options += arg.format_triggers() + "   "

		for _i in range(size - len(arg.format_triggers())):
			options += " "  # add spaces to align the options
		options += arg.help + "\n"
	var help = """
usage: {usage}
{description}
options: 
{options}
""".format(
		{
			usage = usage,
			description = "\n%s\n" % description if description else "",
			options = options.indent("  ")
		}
	)
	return help


static func exec_ext() -> String:
	if OS.has_feature("Windows"):
		return ".exe"
	elif OS.has_feature("OSX"):
		return ""
	elif OS.has_feature("X11"):
		return ".x86_64"
	elif OS.has_feature("web"):
		return ".html" # how do you ever manage to get here tho
	return ""
