# Change this with your bucket name
B2_BUCKET=drio-reolink
B2_ID=003106374dd93dd0000000002
# Make sure to have the bucket key in this file
B2_KEY=$(shell cat ./b2-key.txt)
# Change the directory name within the bucket
B2_URL=b2:$(B2_BUCKET):b2_drio_repo
# Make sure you the pass.txt file with your b2 bucket password
PASS_FILE="--password-file=./pass.txt"

B2_VARS=B2_ACCOUNT_ID=$(B2_ID) B2_ACCOUNT_KEY=$(B2_KEY)
EXCLUDE=--exclude-file=exclude.txt
INCLUDE=--files-from=include.txt

# Keep the backups for 1 months
KEEP_WITHIN=--keep-within 1m # 1 months
# Remove files in local disk after 7 days
DAYS="7"

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
