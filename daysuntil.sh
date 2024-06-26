#!/usr/bin/bash
function daysuntil() {
	local places usage target_date current_date format

	places=5 # number of decimal places to round to

	usage="usage: daysuntil <date> [<from date>]"

	if [[ "$#" -gt 2 ]]; then
		echo "too many arguments, $usage" >&2
		return 1
	fi

	if [[ "$#" -lt 1 ]]; then
		# check for date argument
		echo "missing date argument, $usage" >&2
		return 1
	fi

	target_date="$(date '+%s.%N' -d "$1")" # convert date to seconds since epoch
	if [[ -z "$target_date" ]]; then return 1; fi

	current_date="$(date '+%s.%N')" # current date

	if [[ "$#" -gt 1 ]]; then
		current_date="$(date '+%s.%N' -d "$2")" # use this date as the current date
		if [[ -z "$current_date" ]]; then return 1; fi
	fi

	function format() {
		local num name preWord postWord percent formatnum

		function formatnum() {
			local num2
			num2="$1"

			# add a leading zero before the decimal point if are less than 1
			if [[ "$num2" == "."* ]]; then num2="0$num2"; fi

			# trim the decimal places to needed
			num2="$(printf "%.*f\n" $places $num2)"

			# remove trailing zeros for decimal numbers
			if [[ "$num2" == *"."* ]]; then
				while [[ "$num2" == *"0" ]]; do
					num2="${num2%"0"}"
				done
				num2="${num2%"."}"
			fi

			printf "%s\n" "$num2"
		}

		num="$1"  # number to format
		name="$2" # name of the number (e.g days, years)

		# use "x ago" or "in x" depending on if the target date is in the past or future
		preWord=""
		postWord=""
		if [[ "$num" == "-"* ]]; then
			num="${num/-/}"
			postWord=" ago"
		else
			preWord="in "
		fi

		percent=""

		# add a percentage if the number is below 1
		# bash's (( )) does not support floating point comparison
		if [[ "$(bc -l <<<"$num <= 1")" == 1 ]]; then
			percent="$(bc -l <<<"$num*100")"
			if [[ "$percent" == "."* ]]; then percent="0$percent"; fi
			percent=" ($(formatnum "$percent"))"
		fi

		# print the output
		num="$preWord$(formatnum "$num") $name$percent$postWord"

		echo "$num"
	}

	local target_date_str current_date_str

	target_date_str="$(date -d "@$target_date")"
	current_date_str="$(date -d "@$current_date")"

	printf "From %s\nto %s\n\n" "$current_date_str" "$target_date_str" # print target date

	local seconds minutes hours days weeks months years

	# calculate
	seconds="$(bc -l <<<"$target_date-$current_date")"
	minutes="$(bc -l <<<"$seconds/60")"
	hours="$(bc -l <<<"$minutes/60")"
	days="$(bc -l <<<"$hours/24")"
	weeks="$(bc -l <<<"$days/7")"
	years="$(bc -l <<<"$days/365.25")"
	months="$(bc -l <<<"$years*12")"

	# format
	format "$seconds" seconds
	format "$minutes" minutes
	format "$hours" hours
	format "$days" days
	format "$weeks" weeks
	format "$months" months
	format "$years" years
}

daysuntil "$@"
