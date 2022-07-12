extends Reference
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
		dest = "",
		default = "",  # the default when (no/not enough) value(s) are given
		arg_names = "",  # names of the arguments, in string format, used in the help message
		action = "store"
	}
) -> void:
	help = opt_get(options, "help", "")
	triggers = opt_get(options, "triggers", [])
	if typeof(opt_get(options, "n_args", 0)) == TYPE_STRING:
		arg_type = opt_get(options, "n_args", "")
	else:
		n_args = opt_get(options, "n_args", 0)
	dest = opt_get(options, "dest", dest_name())
	default = opt_get(options, "default", "")
	arg_names = opt_get(options, "arg_names", get_arg_names())
	action = opt_get(options, "action", "store")


func opt_get(opt: Dictionary, key: String, df):
	return opt[key] if key in opt else df


func get_arg_names():
	var r_names := ""
	if not arg_type:
		for i in n_args:
			r_names += " arg%s " % i
	else:
		r_names += "..."
	return r_names


func small_arg() -> String:
	return triggers.min()


func long_arg() -> String:
	return triggers.max()


func dest_name() -> String:
	return small_arg().replace("-", "")


func format_triggers() -> String:
	return "%s %s" % [PoolStringArray(triggers).join(", "), "[%s]" % arg_names if arg_names else ""]
