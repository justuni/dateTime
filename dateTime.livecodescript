script "dateTime"

on libraryStack
end libraryStack

on releaseStack
end releaseStack



function timeZoneAdjust what targetTimezone
   #takes what, assumes local timezone, moves to target timezone (which is expressed in internet notation, i.e. ±HHMM, so, PST is -0800, EST is -0500, EDT is -0400)
   #<figure out the current timezone offset to GMT>
      if (char 1 of targetTimezone is not in "+-") or length(targetTimezone is not 5) or (char 2 to 5 of targetTimezone is not a number) then return empty
      put the internet date into timezone
      put char -5 of timezone into direction #+/-
      put char -4 to -3 of timezone into localHourOffset
      put char -2 to -1 of timezone into localMinuteOffset
   #</figure out the current timezone offset to GMT>

   #<figure out the target timezone offset to GMT>
      put char -5 of targetTimezone into direction #+/-
      put char -4 to -3 of targetTimezone into targetHourOffset
      put char -2 to -1 of targetTimezone into targetMinuteOffset
   #</figure out the target timezone offset to GMT>

   convert what to dateItems
   put targetHourOffset - localHourOffset into hourAdjustment
   put targetMinuteOffset - targetMinuteOffset into minuteAdjustment
   add hourAdjustment to item 4 of what
   add minuteAdjustment to item 5 of what
   convert what to seconds
   return what
end timeZoneAdjust



function quickenDate what
   /*
   Returns current date if sent an empty string
   Returns empty if can't figure out what what is supposed to be

   Delimiter can be ".", "/", ";", <SP> or comma
   Date can be in m/d/y, m/d, or just d format
   Also accepts (upper or lower case)
   T - (T)oday
   M - First day of (M)onth
   H - Last day of mont(H)
   W - First day of (W)eek
   K - Last day of wee(K)
   Y - First day of (Y)ear
   R - Last day of yea(R)
   + - tomorrow
   +x, where x is an integer, x days from today
   - - yesterday
   -x where x is an integer, x days before today
   */

   if what is empty then return the short date # you got a better idea?

   put the short date into currentDateInDateItems
   convert currentDateInDateItems to dateItems #y,m,d,h(24 format),m,s,daynum (0 sun, 6 sat)
   put item 1 of currentDateInDateItems into currentYear
   put item 2 of currentDateInDateItems into currentMonth

   if what="T" then #today
      put the short date into what
   else if what="Y" then #first day of year
      put "01/01/"&currentYear into what
   else if what="R" then #last day of year
      put "12/31/"&currentYear into what
   else if what="M" then # first of month
      put currentMonth&slash&"01"&slash&currentYear into what
   else if what="H" then # last day of month
      if currentMonth is 12 then
         put "12/31/"&currentYear into what
      else #not 12, # the easiest way to do this math is to get midnight on the first day of the following month and then move back a second and let LC do the math on what the date is
         # since otherwise we have to figure out the 30 days have september, blah, blah, blah, and leap years, blah, blah, blah.
         add 1 to item 2 of currentDateInDateItems #next month
         put "0" into item 3 of currentDateInDateItems #I love dateItems.  How to figure out the last day of this month?  Go to first day of next month and subtract 1, (making it a 0, e.g. 5/0/17 is 4/30/17)
         put currentDateInDateItems into what
      end if #currentMonth is 12
   else if what is "W" then #first day of week #sunday is first day of week
      put last item of currentDateInDateItems into dayNumber
      subtract (dayNumber-1) from item 3 of currentDateInDateItems
      put currentDateInDateItems into what
   else if what is "K" then #last day of week #saturday is last day of week
      put last item of currentDateInDateItems into dayNumber
      add (7-dayNumber) to item 3 of currentDateInDateItems
      put currentDateInDateItems into what
      convert what to short date
   else if first char of what is "+" then #at least tomorrow, but if a nuber follows, then x days after today
      delete first char of what # "+"
      if what is empty then put 1 into what #"+" is tomorrow, i.e. +1
      add what to item 3 of currentDateInDateItems
      put currentDateInDateItems into what
   else if first char of what is "-" then # at least yesterday, or if a number follows, then x days before today
      delete first char of what #"-"
      if what is empty then put 1 into what #"-" is yesterday, i.e. -1
      subtract what from item 3 of currentDateInDateItems
      put currentDateInDateItems into what
   else # a date-ish string could be a date only or a month and a date, or a month and a date and a year
      #<determine the delimiter, if there is one.  It could be a comma, a slash, a period, or a space>
         if what contains ";" then replace ";" with slash in what
         if what contains space then replace space with slash in what
         if what contains "." then replace "." with slash in what
         if what contains comma then replace comma with slash in what
      # and, if what doesn't contain any of those, comma will be the delimiter
      #</determine the delimiter, if there is one.  It could be a comma, a slash, a period, or a space>

      set the itemDelimiter to slash

      #<date format can be D, M/D, or M/D/Y, so test and add>
      if the number of items in what is not 3 then put slash&currentYear after what   # try adding a year, first
      if the number of items in what is not 3 then put currentMonth&slash before what # try adding the month, next
      #</date format can be D, M/D, or M/D/Y, so test and add>

      if what is not a date then put empty into what #error
   end if #what="T"

   convert what to short date
   return what
end quickenDate



function dayNumber
   # 1 is Sunday, 7 is Saturday
   if paramCount() is 0 then put the short date into what else put param(1) into what
   if what is not a date then return empty
   convert what to dateitems
   return last item of what
end dayNumber
