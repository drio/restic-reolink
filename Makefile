include .env

PASS_FILE="--password-file=./pass.txt"
B2_URL=b2:$(B2_BUCKET):$(BUCKET_DIR_NAME)
B2_VARS=B2_ACCOUNT_ID=$(B2_ID) B2_ACCOUNT_KEY=$(B2_KEY)
EXCLUDE=--exclude-file=exclude.txt
INCLUDE=--files-from=include.txt

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

## init: init bucket
.PHONY: init
init:
	$(B2_VARS) restic -r $(B2_URL) init $(PASS_FILE)

## backup: create a snapshot
.PHONY: backup
backup:
	@$(B2_VARS) restic -r $(B2_URL) backup $(INCLUDE) $(PASS_FILE) $(EXCLUDE)

## snapshots: list snapshots
.PHONY: snapshots
snapshots:
	@$(B2_VARS) restic --verbose -r $(B2_URL) snapshots $(PASS_FILE)

## forget: remove old snapshots
.PHONY: forget
forget:
	@$(B2_VARS) restic --verbose -r $(B2_URL) $(PASS_FILE) forget --prune $(KEEP_WITHIN)

## cron: install cron jobs
.PHONY: cron
cron: cron-backup cron-clean

## restore-help: instructions to get video for a particular day/time
.PHONY: restore-help
restore-help:
	@echo "1. Find the id of the snapshot you want to use: (make snapshots)"	
	@echo "2. List the contents of the snapshot: make ls/7518e078"
	@echo "3. Restore the directory where your video is on: (make restore/id)"

##   ls/<id>: list contents of snapshot <id>
.PHONY: ls
ls/%:
	@$(B2_VARS) restic -r $(B2_URL) $(PASS_FILE) ls $*

##   restore/<id>: print out cmd to restore files from snapshot
.PHONY: restore
restore/%:
	@echo "mkdir ./restore && \
		$(B2_VARS) restic -r $(B2_URL) $(PASS_FILE) restore $* --target ./restore --include /path/file_or_dir"

cron-backup:
	./install-cron-job.sh "0 23,5 * * *" `pwd`/reolink-run-backup.sh

cron-clean:
	sudo cp ./install-cron-job.sh ./reolink-clean-local.sh /home/reolink/ 
	sudo chown reolink:reolink /home/reolink/*.sh 
	sudo chmod 755 /home/reolink/*.sh
	sudo -u reolink ./install-cron-job.sh "0 1 * * *" /home/reolink/reolink-clean-local.sh

check:
	@$(B2_VARS) restic --verbose -r $(B2_URL) check $(PASS_FILE)

rsync:
	rsync -avz -e ssh --exclude=.git ../restic-reolink pi4t:.
