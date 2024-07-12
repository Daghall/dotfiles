# Bash functions that can be used in the shell or included in scripts

# UNIX timestamp to date
# ts2date [timestamp [, format]]
# Reads from stdin if no arguments
ts2date() {
	local format="%F %R"

	case $# in
		2 )
			format=$2
      ;&
		1 )
			ts=$1
      ;;
		0 )
			read ts
      ;;
	esac

  if [[ -z $ts ]]; then
    echo "No timestamp given. Aborting" 1>&2
    return 1
  fi
	gawk "BEGIN { printf(\"%s\n\", strftime(\"$format\", $ts)) }"
}

# Debug logging
DEBUG_LOG() {
  if [[ ! -z $DEBUG ]]; then
    case $DEBUG in
      1 )
        echo "$@"
        ;;
      2 )
        echo -e "\e[37m$@\e[0m"
        ;;
    esac
  fi
}
