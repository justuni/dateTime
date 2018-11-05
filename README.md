# Date/Time:

- **dayNumber{(what)}**
	
	fn	Returns 1..7 - 1 is Sunday, 7 is Saturday, or empty if there’s an error


- **quickenDate(what)**
	
	fn	Returns a short date, given a mikey-tweaked-quicken date formula OR empty if we can’t figure out what what means
			• Can use slashes, commas, periods, spaces, or semicolons as delimiters
			• If what is empty: return the current date
			T - today
			Y - first day of (Y)ear
			R - last day of (Y)ear
			M - first day of (M)onth
			H - last day of mont(H)
			W - first day of (W)eek
			K - last day of wee(K)
			+{x} - tomorrow, or if x is a number, x days after today
			-{x} - yesterday, or if x is an integer, x days ago
			(anything else) -
				• Takes M/D/Y, M/D, or just D and makes them into dates.
				• If it can’t figure out what what is supposed to be, returns empty
			

- **timezoneAdjust (what, newTimezone)**

	fn	given a date/time and a timezone in ±HHMM (i.e. internet) format, Returns seconds of what in the new timezone.



