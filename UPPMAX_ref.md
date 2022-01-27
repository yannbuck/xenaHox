### UPPMAX reference commands
##### UPPMAX directory to local directory
`rsync -ah [user]@[cluster].uppmax.uu.se:/UPPMAX_PATH/ /LOCAL_PATH/`
##### local directory to UPPMAX directory
`rsync -ah /LOCAL_PATH/ [user]@[cluster].uppmax.uu.se:/UPPMAX_PATH/`
##### list memory availability; contents; list subdirectory sizes
`uquota` ; `uquota -f` ; `du -sh -- *`
##### list subdirectories by size/proportional size
`du -b $PWD | sort -rn | awk 'NR==1 {ALL=$1} {print int($1*100/ALL) "% " $0}'`
##### list files in working directory taking up most space
`find $PWD -print0 -type f | xargs -0 stat -c "%s %n" | sort -rn`
##### shell script (run; cancel; user job queue; job info)
`sbatch [job ID]`; `scancel [job ID]`; `jobinfo -u [user]`; `jobstats -p -r [job ID]`
##### SLURM shell script
```
#!/bin/bash -l
#SBATCH -A snic2021-22-562
#SBATCH -p core
#SBATCH -n #
#SBATCH -t 00-00:00:00
#SBATCH -J [name]
#SBATCH -o job_[name]_%j.out
#SBATCH -e job_[name]_%j.err
#SBATCH --mail-user=[address]
#SBATCH --mail-type=END
```
