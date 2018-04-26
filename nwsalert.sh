#!/bin/bash
#Written by KE5QKR; Emile Diodene
#Used for determining when the local NWS Forecast Offices may want Skywarn Spotter Activations from the trained people in the community
#Information is parsed from the published Hazerdous Weather Outlook text product via the internet and depending on the input will
#output an e-mail alert and read a statement via the PI's audio output jack for alerting those interested to check it out for increased awareness
#and appropriate action.
#Note the absolute paths used as well.  This script was designed on a Raspbian Platform for a RPi as the pi user.  You may have to adjust for you platforms as appropriate,
#Other software interactions are with SSMTP, an external e-mail account, cron to run it several times a day and festival, to read text to speach 
#over a repeater using the PI's output 

TODAY=$(date)

# Go get the NWSLIX current HWO output and store it local
echo "Results from downloading the HWO Feed from LIX;"
echo $'\r'
curl -o /home/pi/nwsalert/nwslix "https://forecast.weather.gov/product.php?site=NWS&product=HWO&issuedby=LIX"

# Parse local file for spotter activation string and send e-mail with link if "Spotter activation is not" does not exist.
declare file="/home/pi/nwsalert/nwslix"
declare regex="\s+Spotter activation is not\s+"

declare file_content=$( cat "${file}" )
if [[ " $file_content " =~ $regex ]] # please note the space before and after the file content
	then
		echo $'\r'
		echo "$TODAY - Spotter activation is not anticipated."
                echo "Ey,  This is the K eey 5 Q K R  Raspberry Pi Spotter Activation Statement reader application for Skywarn volunteers,  As of now, Spotter activation is not anticipated, 7 3 from k eey 5 q k r"  | festival --tts
    	else
        	mail -s "Spotter Activation" ke5qkr@ke5qkr.org <<< "Spotter activation may be needed, please review the details at the link; https://forecast.weather.gov/product.php?site=NWS&product=HWO&issuedby=LIX"
                echo "This is the K eey 5 Q K R Raspberry Pi spotter activation reader application, Activation may be needed, please check the National Weather Service New Orleans website Hazerdous Weather Outlook for more details." | festival --tts
fi
