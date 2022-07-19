### What is this?

![](https://restic.readthedocs.io/en/latest/_static/logo.png)

This project contains a Makefile to backup video data from security cameras. There is
really nothing specific to security cameras so you can use it to backup anything.
It uses [backblaze's b2](https://www.backblaze.com/b2/cloud-storage.html) as a backend storage.
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

Use this [ansible playbook](https://github.com/drio/restic-reolink-ansible).

