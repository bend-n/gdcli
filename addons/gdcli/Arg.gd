extends RefCounted
class_name Arg

var n_args := 0
var arg_type := ""  # can be *
var triggers := []
var help := ""
var arg_names := ""
var action := "store"
var dest := ""
var default = ""


func find_trigger(to_find: String) -> String:
	for t in triggers:
		if t == to_find:
			return t
	return ""


func _init(
	options := {
		triggers = [],
		n_args = 0,
		help = "",
		dest = "", # defaults to longest trigger
		default = "",  # the default when (no/not enough) value(s) are given
		arg_names = "",  # names of the arguments, in string format, used in the help message
		action = "store"
	}
) -> void:
	help = options.get("help", "")
	action = options.get("action", "store")
	triggers = options.get("triggers", [])
	triggers.sort_custom(func(a: String, b: String): return len(a) < len(b))
	if options.get("n_args", 0) is String:
		arg_type = options.get("n_args", "")
		action = ""
	else:
		n_args = options.get("n_args", 0)
	dest = options.get("dest", dest_name())
	default = options.get("default", "")
	arg_names = options.get("arg_names", get_arg_names())


func opt_get(opt: Dictionary, key: String, df: Variant):
	return opt.get(key, df)


func get_arg_names():
	var r_names := ""
	if arg_type.is_empty():
		for i in n_args:
			r_names += " arg%s " % i
	else:
		r_names += "..."
	return r_names

func small_arg() -> String:
	return triggers[0] if triggers.size() > 0 else ""

func long_arg() -> String:
	return triggers[-1] if triggers.size() > 0 else ""

func dest_name() -> String:
	return long_arg().replace("-", "")

func format_triggers() -> String:
	return "%s %s" % [", ".join(triggers), "[%s]" % arg_names if arg_names else ""]

func _to_string() -> String:
	return "Arg<%s(%s%s)>" % [long_arg().replace("-", ""), action, arg_type]
