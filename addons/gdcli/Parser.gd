extends RefCounted
class_name Parser

var target_args := []


func add_argument(arg: Arg):
	target_args.append(arg)

func parse_arguments(cmdline_args: PackedStringArray):
	var args := {unhandled = PackedStringArray([])}
	var i := -1
	var star: String
	while i < len(cmdline_args) - 1:  # go through the cmdline args
		i += 1
		var current = cmdline_args[i]
#		print("searching ", current)
		var res := __search_target_args(current)
		if res:  #       if we found a arg
#			print("found arg ", res)
			star = ""  # reset the star
			if res.arg_type:
				match res.arg_type:
					"*":
						star = res.dest
						args[res.dest] = PackedStringArray()
#						print("adding %s to star" % cmdline_args[i+1])
			elif res.action == "store":
#				print("fixed arg")
				var length := cmdline_args.size()-i-1-res.n_args
				if length < 0:
#					print("no args supplied")
					if res.default:
						args[res.dest] = res.default
#						print("set default")
						continue
					else:
						var errstr = "Missing %s argument%s for %s"
						errstr = errstr % [length * -1, "s" if length < -1 else "", current]
						push_error(errstr)
						return null
				for c in cmdline_args.slice(i + 1, i + 1 + res.n_args):  # search the next n_args args
#					print("adding args")
#					print("searching(nargs) ", c)
					i += 1
					if __search_target_args(c):  # if it is a argument
#						print("found arg")
						if res.default.is_empty():  # and there is no default
							var errstr := "Missing %s argument%s for %s"
							var lent := (
								len(args[res.dest]) - res.n_args
								if res.dest in args
								else -res.n_args
							)
							errstr = errstr % [lent * -1, "s" if lent < -1 else "", current]
							push_error(errstr)
							return null  # and return
						else:
#							print("set def")
							i -= 1
							args[res.dest] = res.default  # if there is a default, set it to that
							break
					if res.n_args == 1:
						args[res.dest] = c # if there is only one argument, set it to that
					elif not res.dest in args:
						args[res.dest] = PackedStringArray([c])  # otherwise put it in a array
					else:
						args[res.dest].append(c)
			elif res.action == "store_true":
				args[res.dest] = true
		else:
			if star:
				args[star].append(cmdline_args[i])
			else:
				args.unhandled.append(cmdline_args[i])
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
		return ".html"  # how do you ever manage to get here tho
	return ""
