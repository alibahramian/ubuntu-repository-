how to make ubuntu repository

you need to have at least 2.1 terabyte for this repository

install requied packages:

# apt-get install rsync mailx apache2

# mkdir /media/mirror/ubuntu
 
# rsync -a --bwlimit=128 rsync://archive.ubuntu.com/ubuntu /media/mirror/ubuntu
--
Building the script to keep it up to date
 
Caution: Do not initialize your script or set your cron job until the initial download is done!

Open an editor (vi, pico, or gedit) and save the following code as /usr/local/bin/ubuntu-mirror-sync.sh

# vi /usr/local/bin/ubuntu-mirror-sync.sh

    # Mirror Synchronization Script /usr/local/bin/ubuntu-mirror-sync.sh
    ## Version 1.01 Updated 13 Feb 2007 by Peter Noble
    ## Point our log file to somewhere and setup our admin email
    log=/var/log/mirrorsync.log

    adminmail=admin@my.domain
    # Set to 0 if you do not want to receive email
    sendemail=1

    # Subject is the subject of our email
    subject="Ubuntu Mirror Sync Finished"

    ## Setup the server to mirror
    remote=rsync://archive.ubuntu.com/ubuntu

    ## Setup the local directory / Our mirror
    local=/media/mirror/ubuntu

    ## Initialize some other variables
    complete="false"
    failures=0
    status=1
    pid=$$

    echo "`date +%x-%R` - $pid - Started Ubuntu Mirror Sync" >> $log
    while [[ "$complete" != "true" ]]; do

        if [[ $failures -gt 0 ]]; then
                ## Sleep for 5 minutes for sanity's sake
                ## The most common reason for a failure at this point
                ##  is that the rsync server is handling too many concurrent connections.
                sleep 5m
        fi

        if [[ $1 == "debug" ]]; then
                echo "Working on attempt number $failures"
                rsync -a --delete-after --progress $remote $local
                status=$?
        else
                rsync -a --delete-after $remote $local >> $log
                status=$?
        fi
        
        if [[ $status -ne "0" ]]; then
                complete="false"
                (( failures += 1 ))
        else
                echo "`date +%x-%R` - $pid - Finished Ubuntu Mirror Sync" >> $log

                # Send the email
                if [[ -x /usr/bin/mail && "$sendemail" -eq "1" ]]; then
                mail -s "$subject" "$adminmail" <<OUTMAIL
    Summary of Ubuntu Mirror Synchronization
    PID: $pid
    Failures: $failures
    Finish Time: `date`

    Sincerely,
    $HOSTNAME

    OUTMAIL
                fi
        complete="true"
        fi
    done

    exit 0


Use Cron to keep the mirror up to date 
# crontab -e

 15 21 * * * /usr/local/bin/sync-ubuntu-mirror.sh > /dev/null 2> /dev/null

Publish the mirror on the Apache server
# cd /var/www/
# ln /media/mirror/ubuntu -s

# systemctl restart apache2


#replace new ubuntu repository 

#if you want change your current repository or your costumer you can use the script

#just replace your domain simply

#dont forget to command "chmod 755 ubuntu-replace.sh" before run
