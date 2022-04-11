### What is this?

This project contains a Makefile to backup video data from ip cameras. 
It uses [backblaze's b2](https://www.backblaze.com/b2/cloud-storage.html).
Make sure your camera dumps activity into the same machine where you are going to 
run the makefile.

```
> make
Usage:
  help             print this help message
  init             init bucket
  backup           create a snapshot
  snapshots        list snapshots
  forget           remove old snapshots
  cron             install cron jobs
  restore-help     instructions to get video for a particular day/time
    ls/<id>        list contents of snapshot <id>
    restore/<id>   print out cmd to restore files from snapshot
```

### Install

Make sure you read the `Makefile`. Create the different files and change the variables
as necessary.

Then, start by creating the bucket in BB with `make init` then run
the backup and snapshots targets a few time to make sure the backup is working properly.

Run `make cron` to install a couple of crons (see makefile).
One to start the backups against B2 and another one to clean local
files (they take a lot of space). Update the `cron-backup` and `cron-clean`
targets to trigger the cron jobs at your desired times.
