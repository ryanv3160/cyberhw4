Homework 4 - Powershell and Bash Scripting for Security Administration
Submit Assignment
Due Friday by 11:59pm  Points 20  Submitting a file upload
Part 1 - Powershell Scripting (15 points)

In the first part of this assignment, you are using Powershell to find potential malwares by checking for changes in the list of applications that are set to run at startup. 

To do this part, you first need to discover locations in the registry where a program can be set to run at startup. Unfortunately, there are many different ways a program can do so in Windows, and your first effort is to put together a list of places in registry where you need to monitor for such programs. For example, this article (Links to an external site.) provides a list of some of these locations and key/value pairs.  You can use other resources and guidelines on the Internet as well. At this first step, you will create a list of these registry locations. 

Then, you will write a Powershell script that every 5 minutes checks for changes in these locations and alerts in a log file if a change has occurred, and a program has been added to startup. 

You must test your code. To do so, find two programs that automatically add themselves to the startup in different ways, and install them on Windows VM. Your log file must correctly report this change in the startup. 

You must submit your code, your log file, and a report that includes your findings about the startup registry keys, and explains your code and logs.

 

Part 2 - Bash Scripting (10 points)

For the second part of this assignment, you are writing a network change monitor tool using bash scripting. 

You will write a bash script that checks all IP addresses on range 192.168.10.*/24 and ports between 1-65536 every 5 minutes and alerts in a log file if any IP or port has been opened since last execution.

You will test your code in the following setup: We use the same network setup as in the class (VMnet0), and assume that all VMs are set up as part of this network.

The bash script will run on Kali VM1. At first, only Kali VM1 and Windows VM are running. 

Then, after 10 minutes, power on Kali VM 2 on the same VMnet0 network.

After 10 minutes, run a web application on port 8008, using SimpleHTTPServer of Python.

This runs a Web application on Kali VM2 and opens up port 8008.

During these activities, your bash script is running every 5 minutes and logging the changes. 

 

For submission, you will submit your bash script code, your log file, and a short report describing your code and your log.

 

Deliverables for this assignment.

Part 1: Powershell Code, Log files, Report

Part 2: Bash Code, Logs files, Report 

Please zip your files and submit them. Your zip file must have two folders Part1 and Part2.
