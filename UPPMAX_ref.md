### UPPMAX reference commands
##### UPPMAX to local
`rsync -ah [user]@[cluster].uppmax.uu.se:/UPPMAX_PATH/ /LOCAL_PATH/`
##### local to UPPMAX
`rsync -ah /LOCAL_PATH/ [user]@[cluster].uppmax.uu.se:/UPPMAX_PATH/`

##### list subdirectories by size/proportional size
`du -b $PWD | sort -rn | awk 'NR==1 {ALL=$1} {print int($1*100/ALL) "% " $0}'`
##### list files in working directory taking up most space
`find $PWD -print0 -type f | xargs -0 stat -c "%s %n" | sort -rn`

##### SLURM shell script
```
#SBATCH -A snic2021-22-562
#SBATCH -p core
#SBATCH -n #
#SBATCH -t 00-00:00:00
#SBATCH -J [name]
#SBATCH -o job_[name]_%j.out
#SBATCH -e job_[name]_%j.err
```
