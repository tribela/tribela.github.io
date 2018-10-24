---
layout: post
title: 우분투 서스펜드시 곧바로 깨어나는 문제 고치기
category: Ubuntu
tags:
- Ubuntu
- config
date: 2018-10-23 07:00:15 +0900
---

우분투 18.04를 사용하고 있었는데 서스펜드 상태로 시간이 지나면 필요 이상으로 배터리가 닳아 있는 문제가 있었다. 서스펜드가 잘 안 되는 건 줄 알았는데 알고보니 서스펜드가 되자마자 다시 깨어나는 것이었다.

일단 누가 깨우는지를 확인하자.

```sh
$ cat /proc/acpi/wakeup
Device	S-state	  Status   Sysfs node
PEG0	  S4	*disabled
PEGP	  S4	*disabled
PEG1	  S4	*disabled
PEGP	  S4	*disabled
PEG2	  S4	*disabled
PEGP	  S4	*disabled
GLAN	  S4	*disabled
XHC	  S3	*enabled  pci:0000:00:14.0
XDCI	  S4	*disabled
HDAS	  S4	*disabled  pci:0000:00:1f.3
RP01	  S4	*disabled  pci:0000:00:1c.0
PXSX	  S4	*disabled
RP02	  S4	*disabled
PXSX	  S4	*disabled
RP03	  S4	*disabled
생략
```

`enabled`라고 뜨는 것 중 의심 가는 것들을 끄고 테스트 해 보자

```sh
$ ehco XHC | sudo tee /proc/acpi/wakeup
$ systemctl suspend
```

제대로 서스펜드가 되는 걸 확인 했으면 설정파일을 만들자.

```sh
#!/bin/bash
# /usr/lib/pm-utils/sleep.d/45fixwakeup

case $1 in
    hibernate)
        ;;
    suspend)
        echo "Fixing acpi settings"
        blacklist=('XHC')
        for device in "${blacklist[@]}"; do
            state=$(grep "$device" /proc/acpi/wakeup | awk -c '{print $3}' | tr -d '*')
            echo "$device state = $state"
            if [ "$state" == "enabled" ]; then
                echo "$device" > /proc/acpi/wakeup
            fi
        done
        ;;
    thaw)
        ;;
    resume)
        ;;
esac
```

```sh
#!/bin/bash
# /lib/systemd/system-sleep/45-fix-wakeup
[ "$1" == "pre" ] || exit

case $2 in
    suspend)
        echo "Fixing ACPI settings"
        blacklist=('XHC')
        for device in "${blacklist[@]}"; do
            state=$(grep "$device" /proc/acpi/wakeup | awk -c '{print $3}' | tr -d '*')
            echo "$device state = $state"
            if [ "$state" == "enabled" ]; then
                echo "$device" > /proc/acpi/wakeup
            fi
        done
        ;;
esac
```

이제서야 서스펜드가 제대로 된다. 이제 노트북을 덮으면 오래 버틸 수 있다.
