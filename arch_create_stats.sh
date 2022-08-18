#!/usr/bin/bash

SUM="stats/$1_summary.log"
INST="stats/$1_installed.log"
PROC="stats/$1_processes.log"
TMP="stats/$1.tmp"

mkdir -p stats

(
echo -e "
================================================================================
>>>> top -b -n 1 | head -5 <<<
"
top -b -n 1 | head -5 >$TMP
cat $TMP
echo -e "\n
================================================================================
>>>> ps -e <<<<
"
ps -e -o "%U %P %p %c" |tail -n +2 >$PROC
echo -e "#Running processes: $(wc -l $PROC)" 
echo -e "\n
================================================================================
>>>> free -h <<<<
"
free -h 
echo -e "\n
================================================================================
>>>> df -BM <<<<
"
df -BM /
echo -e "\n
================================================================================
>>>> du -s -BM <<<<
"
sudo du -s -BM  /usr /var /opt /boot /home /root
echo -e "\n
================================================================================
>>>> pacman -Qi >$INST <<<<
"
LC_ALL=C pacman -Qi | awk '/^Name/{name=$3} /^Version/{ver=$3} /^Installed Size/{print name"_"ver, $4,$5}' | sort -h >$INST
echo -e "#Installed packages: $(wc -l $INST)"
awk -f ./arch_sum_installed.awk $INST

echo -e "\
================================================================================
"
) | tee $SUM


rm $TMP
