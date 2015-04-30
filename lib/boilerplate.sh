shopt -s expand_aliases

declare -a __oo__importedTypes
declare -A __oo__storage
declare -A __oo__objects
declare -A __oo__objects_private
declare -a __oo__functionsTernaryOperator

# http://stackoverflow.com/questions/2990414/echo-that-outputs-to-stderr
#oo:echoerr() { cat <<< "$@" 1>&2; }
oo:echoerr() { cat <<< "$*" 1>&2; }

oo:debug() {
    # http://stackoverflow.com/questions/16623835/bash-remove-a-fixed-prefix-suffix-from-a-string
    local script=${BASH_SOURCE[1]}
    local prefix='./'
    script="${script#$prefix}"
    [ ! -z $__oo__debug ] && oo:echoerr "[${script}:${BASH_LINENO[1]}] $*"
}
alias oo:debug:1="oo:debug"

oo:debug:2() {
    local script=${BASH_SOURCE[1]}
    local prefix='./'
    script="${script#$prefix}"
    #set -xv
    [ ! -z $__oo__debug ] && [ $__oo__debug -gt 1 ] && oo:echoerr "[${script}:${BASH_LINENO[1]}] $*"
    #set +xv
}

oo:debug:3() {
    local script=${BASH_SOURCE[1]}
    local prefix='./'
    script="${script#$prefix}"
    [ ! -z $__oo__debug ] && [ $__oo__debug -gt 2 ] && oo:echoerr "[${script}:${BASH_LINENO[1]}] $*"
}

oo:debug:enable() {
    declare -ig "__oo__debug=${1:-1}"
    # [[ -z "$1" ]] && declare -ig "__oo__debug=1"
    # [[ -z "$1" ]] || declare -ig "__oo__debug=$1"
}

oo:throw() {
    oo:echoerr "[oo-error] " "$@"
}

oo:import() {
    local libPath
	for libPath in "$@"; do
	    ## correct path if relative
	    [ ! -e "$libPath" ] && libPath="${__oo__path}/${libPath}"
        [ ! -e "$libPath" ] && libPath="${libPath}.sh"
        [ ! -e "$libPath" ] && oo:throw "cannot import $libPath" && return 1

		if [ -d "$libPath" ]; then
		    local file
			for file in $libPath/*.sh
			do
			    source "$file"
			done
		elif [ -f "$libPath" ]; then
			source "$libPath"
		fi
	done
}

oo:array:contains(){
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}
