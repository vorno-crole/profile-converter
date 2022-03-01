#!/bin/bash

# Setup
	# set -e
	# set -o pipefail
	SECONDS=0

	YLW="\033[33;1m"
	GRN="\033[32;1m"
	WHT="\033[97;1m"
	RED="\033[91;1m"
	RES="\033[0m"

	SCR_NAME="Convert Profile Metadata script"
	VERSION="1.0"
	AUTHOR="vc@vaughancrole.com"

	MODE=""
	SHOW_MSGS="TRUE"
	IN_FILE=""
	OUT_FILE="outfile.csv"
	XSL_FILE="transform-sorted.xsl"

	title()
	{
		echo -e "${GRN}*** ${WHT}${SCR_NAME} v${VERSION}${RES}\nby ${GRN}${AUTHOR}${RES}\n"
	}
	export -f title

	usage()
	{
		# title
		echo -e "Usage:"
		echo -e "${WHITE}$0${RES} (2csv | 2xml) -i <input-file> -o <output-file> [--xsl <xsl file>]"
	}
	export -f usage

	pause()
	{
		read -p "Press Enter to continue."
	}
	export -f pause

	msgs()
	{
		if [[ ${SHOW_MSGS} == "TRUE" ]]; then
			case $1 in
				title) title;;

				echo) echo -e $2;;
			esac
		fi
	}
	export -f msgs

	while [ $# -gt 0 ] ; do
		case $1 in
			2csv) MODE="CSV";;

			2xml) MODE="XML";;

			-i) IN_FILE="$2"
				shift;;

			-o) OUT_FILE="$2"
				shift;;

			--xsl) XSL_FILE="$2"
				shift;;

			--test) MODE="TEST";;
			--quiet) SHOW_MSGS="FALSE";;
			--all) mode2="$MODE-all"
				   MODE="$mode2"
				   unset mode2;;

			-h | --help) title
						 usage
						 exit 0;;

			*) title
			   echo -e "${RED}*** Error: ${RES}Invalid option: ${WHT}$1${RES}. See usage:"
			   usage
			   exit 1;;
		esac
		shift
	done

	if [[ $MODE == "" ]]; then
		title
		echo -e "${RED}*** Error: ${RES}Mode not specified."
		usage
		exit 1
	fi

	if [[ $IN_FILE == "" ]] && [[ $MODE == "CSV" || $MODE == "XML" ]]; then
		title
		echo -e "${RED}*** Error: ${RES}In file not specified."
		usage
		exit 1
	fi

	if [[ $OUT_FILE == "" ]]; then
		OUT_FILE="/dev/stdout"
	fi
# end setup

msgs title
msgs echo "Mode: ${WHT}${MODE}${RES}\n"

if [[ "$MODE" == "CSV" ]]; then
	xsltproc $XSL_FILE "$IN_FILE" > "$OUT_FILE"

elif [[ "$MODE" == "XML" ]]; then

	split_on_commas()
	{
		local IFS=,
		local WORD_LIST=($1)
		for word in "${WORD_LIST[@]}"; do
			echo "$word"
		done
	}

	key_values()
	{
		# Custom logic goes here
		echo -ne "$INDENT" >> "${OUT_FILE}"
		echo $1 | awk -F":" '{print "<"$1">"$2"</"$1">"}' >> "${OUT_FILE}"
	}

	# Start writing out file....

	echo '<?xml version="1.0" encoding="UTF-8"?>' > "${OUT_FILE}"
	echo '<Profile xmlns="http://soap.sforce.com/2006/04/metadata">' >> "${OUT_FILE}"

	INDENT="    "

	# Read file, line by line
	while IFS= read -r line; do

		# if no []
		if [[ "$line" =~ .*"[".* ]]; then
			# eg: applicationVisibilities[application:Claims_Complaints,default:false,visible:true]
				# <applicationVisibilities>
				# 	<application>Claims_Complaints</application>
				# 	<default>false</default>
				# 	<visible>true</visible>
				# </applicationVisibilities>

			# explode on []
			node="$(echo $line | awk -F'[\\[\\]]' '{ print $1 };')"
			kvs="$(echo $line | awk -F'[\\[\\]]' '{ print $2 };')"
			# echo $node;
			# echo $kvs;
			# exit;

			# TODO: Turn keyvalues into dictionary

			echo "$INDENT<$node>" >> "${OUT_FILE}"

			INDENT="        " # Double indent

			split_on_commas "$kvs" | while read item; do
				# for each $key:$value, make xml
				key_values "${item}"
			done
			INDENT="    "

			echo "$INDENT</$node>" >> "${OUT_FILE}"

		else
			# eg: userLicense:Salesforce,userLicense2:Salesforce2
			#     <userLicense>Salesforce</userLicense>

			# explode ,
			split_on_commas "$line" | while read item; do

				# for each $key:$value, make xml
				key_values "${item}"
			done

		fi
	done < "${IN_FILE}"

	echo '</Profile>' >> "${OUT_FILE}"


elif [[ "$MODE" == "CSV-all" ]]; then

	# turn all profiles into profileCSVs
	mkdir -p force-app/main/default/profileCSVs

	find force-app/main/default/profiles -type f | while read fname; do

		echo -e "Filename: ${WHT}$fname${RES}"

		OUT_FILE=force-app/main/default/profileCSVs/$(basename "$fname" | cut -d. -f1-2).csv
		echo -e "Output  : ${WHT}${OUT_FILE}${RES}\n"

		$0 2csv -i "${fname}" -o "${OUT_FILE}" --xsl "${XSL_FILE}" --quiet
	done

elif [[ "$MODE" == "XML-all" ]]; then

	# turn all profileCSVs into profiles
	mkdir -p force-app/main/default/profileCSVs

	find force-app/main/default/profileCSVs -type f | while read fname; do

		echo -e "Filename: ${WHT}$fname${RES}"

		OUT_FILE=force-app/main/default/profiles/$(basename "$fname" | cut -d. -f1-2).xml
		echo -e "Output  : ${WHT}${OUT_FILE}${RES}\n"

		$0 2xml -i "${fname}" -o "${OUT_FILE}" --xsl "${XSL_FILE}" --quiet
	done


elif [[ "$MODE" == "TEST" ]]; then

	# run 2csv then 2xml
	# and diff the results
	find force-app/main/default/profiles -type f | while read fname; do
		echo -e "Filename: ${WHT}$fname${RES}"

		$0 2csv -i "${fname}" -o test.csv --xsl vc/xml/admin-transform.xsl --quiet
		$0 2xml -i test.csv -o test.xml --quiet
		diff -w "${fname}" test.xml
	done




else
	echo -e "${RED}*** Error: ${RES}Unknown Mode: $MODE."
	usage
	exit 1
fi

msgs echo "Time taken: ${SECONDS} seconds.\n"
# exit 0;
