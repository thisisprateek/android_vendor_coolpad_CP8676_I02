#!/system/bin/sh
  echo 1 > /sys/module/sec/parameters/recovery_done		#koshi   
sqlite3 /data/data/com.yulong.android.coolsafe/databases/apklock.db "update apk_lock set locked = 0"
if ! applypatch -c EMMC:recovery:9799680:e2fed1e851bbf36d1f8a1ea8dc8db9c0dd0369e6; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:boot:7755776:e56549479a1fbd62a26ad96004e9afe6e2bfa150 EMMC:recovery e2fed1e851bbf36d1f8a1ea8dc8db9c0dd0369e6 9799680 e56549479a1fbd62a26ad96004e9afe6e2bfa150:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
  if applypatch -c EMMC:recovery:9799680:e2fed1e851bbf36d1f8a1ea8dc8db9c0dd0369e6; then		#koshi
	echo 0 > /sys/module/sec/parameters/recovery_done		#koshi
        log -t recovery "Install new recovery image completed"
        
  if applysig /system/etc/recovery.sig recovery; then
    sync
    log -t recovery "Apply recovery image signature completed"
  else
    log -t recovery "Apply recovery image signature fail!!"
  fi

    
  else
	echo 2 > /sys/module/sec/parameters/recovery_done		#koshi
        log -t recovery "Install new recovery image not completed"
  fi
else
  echo 0 > /sys/module/sec/parameters/recovery_done         #koshi
  log -t recovery "Recovery image already installed"
fi
if ! applypatch -c EMMC:tee2:425984:04f0c731721c47119772454c890e38920b8e87e2; then
  log -t recovery "Installing new t-base image"
  applypatch -t /system/etc/trustzone.bin EMMC:tee2:425984:04f0c731721c47119772454c890e38920b8e87e2 
else
  log -t recovery "t-base image already installed"
fi
