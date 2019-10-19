#!/bin/bash

# File for the previose scan
oldfile='/root/Desktop/Hwk4/Part2/oldfile.txt' 
# File for the next scan
newfile='/root/Desktop/Hwk4/Part2/newfile.txt'
# File for the logs to print if a new IP/Port has been found or not
logfile='/root/Desktop/Hwk4/Part2/logfile.txt'

# Var for comparison of prev vs next scan
DIFFERENT=""
# Var for seconds bash feature for time in seconds since script started
SECONDS=0
# Var constant for 5 minute delay "300 seconds"
DELAYTIME=300

# Mapfile command to make an array out of the output inside ()
# Call nmap with option -n to... , option -sn to ..., 
# This is then converted to grepable output with -oG and piped into
# awk to only capture the ip address's that are labeled up by nmap "Active IP's"
mapfile -t linesOld < <(nmap -n -sn 192.168.10.1/24 -oG - | awk '/Up$/{print $2}') 

# Print to std out the time of intial scan
echo "$(date) Initial scan of network starting"

# Loop through all IP's captured in nmap
for (( i=0; i<${#linesOld[@]}; i++ ))
do      # Print to previose file the intial scan
	echo ${linesOld[i]} >> $oldfile
	# Use nmap with option -n to ... , option -sT to ... ,
	# option -F to ... , with the IP's found we now want to get the ports open 
	# We pipe the raw port data into the grep fucntion to only get the lines
	# with port numbers using egrep then append the port numbers to the prev file
	nmap -n -sT -F ${linesOld[i]} | grep "tcp" | egrep -o '[0-9]+[0-9]' >> $oldfile
done;

# Print to stdout that we have completed the intitial scan
echo "$(date) Initial scan of network end"

# Loop to now make the next scans to compare against the previose scan
# This is where we check for the difference in IP's / Ports from subsequent scans
while true; do
	# Calculate the delay time to be set, added this feature since we want to scan every 5
	# minutes, however the scan eats up time aswell, so we take the 5 minute time - last scan time.
	DIFF=$(($DELAYTIME - $SECONDS))
	# Print to stdout the next wait time
	echo "$(date) Going to sleep for $DIFF seconds"
	# Begin the wait
	sleep $DIFF
	# Wait has elapsed and starting next scan.
	# Print to stdout that we are starting the next scan
	echo "$(date) Scan of network starting"
	# Reset scan timer
	SECONDS=0

	# Mapfile command to make an array out of the output inside ()
	# Call nmap with option -n to... , option -sn to ..., 
	# This is then converted to grepable output with -oG and piped into
	# awk to only capture the ip address's that are labeled up by nmap "Active IP's"
	mapfile -t linesNew < <(nmap -n -sn 192.168.10.1/24 -oG - | awk '/Up$/{print $2}')

	# Loop through each new captured IP
	for (( i=0; i<${#linesNew[@]}; i++ ))
	do 	# Print to comparison file the IP's
		echo ${linesNew[i]} >> $newfile
		# Use nmap with option -n to ... , option -sT to ... ,
		# option -F to ... , with the IP's found we now want to get the ports open 
		# We pipe the raw port data into the grep fucntion to only get the lines
		# with port numbers using egrep then append the port numbers to the prev file
		nmap -n -sT -F ${linesNew[i]} | grep "tcp" | egrep -o '[0-9]+[0-9]' >> $newfile
	done;

	# See if there is a difference in the files 
	DIFFERENT=$(comm -23 $newfile $oldfile 2>/dev/null)

	# If there is not a difference then we have not opened another Port or IP address on the network
	if [ "$DIFFERENT" == "" ]; then
		# Print to the logfile we have not found a difference
		echo "$(date) --- No New IPAddress or Open Port ---" >> $logfile
		
	else 	# Else print we found a difference
		echo "$(date) --- New IPAddress or Open Port ---" >> $logfile
		# Print to the logfile the difference between the files which is the 
		# New port or IP added to the network
		comm -23 $newfile $oldfile 2>/dev/null >> $logfile
	fi

	# Now since we have compared the previose scan witht he next scan we must reset
	# the files ... copy the new file into the old file overwritting, setting up for
	# the next loop iteration to compare again after the set delay
	yes | cp -rf $newfile $oldfile

	# Clear out the file the next scan will go into
	> $newfile

	# Print to stdout that the scan has completed
	echo "$(date) scan of network end"
done



