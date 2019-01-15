---
layout: post
title: 리눅스에서 가상 모니터 기능을 이용해 아이패드를 추가 모니터처럼 사용하기
category: Hack
tags:
- linux
- ubuntu
- virtual display
- ipad
- vnc
date: 2018-12-08 21:27:06 +0900
---

리눅스에선 xrandr라는 프로그램을 이용해서 디스플레이의 해상도, 주파수 등을 조절할 수 있다. 이를 이용해 재밌는 걸 할 수 있는데, 가상 장치를 만들어서 모니터를 두 개 장착한 것처럼 만들고 다른 장비에서 vnc를 이용해 해당 가상 모니터 영역만큼만 보여주면 듀얼모니터와는 미묘하게 다른 무언가를 만들 수 있다.

아래의 스크립트는 다른 사람의 [블로그](https://kbumsik.io/using-ipad-as-a-2nd-monitor-on-linux)에서 가져 온 건데 x11vnc만 미리 설치해 두면 된다.


```bash
#!/bin/bash
# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <k.bumsik@gmail.com> wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return. - Bumsik Kim
# ----------------------------------------------------------------------------

# Configuration
WIDTH=1368  # 1368 for iPad Pro
HEIGHT=1024  # 1024 for iPad Pro
MODE_NAME="mode_ipad"       # Set whatever name you like, you may need to change
                            # this when you change resolution, or just reboot.
DIS_NAME="VIRTUAL1"         # Don't change it unless you know what it is
RANDR_POS="--right-of"      # Default position setting for xrandr command

# Parse arguments
while [ "$#" -gt 0 ]; do
  case $1 in
    -l|--left)      RANDR_POS="--left-of"  ;;
    -r|--right)     RANDR_POS="--right-of" ;;
    -a|--above)     RANDR_POS="--above"    ;;
    -b|--below)     RANDR_POS="--below"    ;;
    -p|--portrait)  TMP=$WIDTH; WIDTH=$HEIGHT; HEIGHT=$TMP
                    MODE_NAME="$MODE_NAME""_port"  ;;
    -h|--hidpi)     WIDTH=$(($WIDTH * 2)); HEIGHT=$(($HEIGHT * 2))
                    MODE_NAME="$MODE_NAME""_hidpi" ;;
    *) echo "'$1' cannot be a monitor position"; exit 1 ;;
  esac
  shift
done

# Detect primary display
PRIMARY_DISPLAY=$(xrandr | perl -ne 'print "$1" if /([A-Za-z0-9-]*)\s*connected\s*primary/')

# Add display mode
RANDR_MODE=$(cvt "$WIDTH" "$HEIGHT" 60 | sed '2s/^.*Modeline\s*\".*\"//;2q;d')
xrandr --addmode $DIS_NAME $MODE_NAME 2>/dev/null
# If the mode doesn't exist then make mode and retry
if ! [ $? -eq 0 ]; then
  xrandr --newmode $MODE_NAME $RANDR_MODE
  xrandr --addmode $DIS_NAME $MODE_NAME
fi

# Show display first
xrandr --output $DIS_NAME --mode $MODE_NAME
# Then move display
sleep 5 # A short delay is needed. Otherwise sometimes the below command is ignored.
xrandr --output $DIS_NAME $RANDR_POS $PRIMARY_DISPLAY

# Cleanup before exit
finish() {
  xrandr --output $DIS_NAME --off 
  xrandr --delmode $DIS_NAME $MODE_NAME
  echo "Second monitor disabled."
}

trap finish EXIT

# Get the display's position
CLIP_POS=$(xrandr | perl -ne 'print "$1" if /'$DIS_NAME'\s*connected\s*(\d*x\d*\+\d*\+\d*)/')
echo $CLIP_POS
# Share screen
# x11vnc -multiptr -repeat -clip $CLIP_POS
x11vnc -multiptr -repeat -clip $CLIP_POS
# Possible alternative is x0vncserver but it does not show the mouse cursor.
#   x0vncserver -display :0 -geometry $DIS_NAME -overlaymode -passwordfile ~/.vnc/passwd
if ! [ $? -eq 0 ]; then
  echo x11vnc failed, did you \'apt-get install x11vnc\'?
fi
```

장점은 vnc의 멀티포인터 기능을 이용해서 마우스가 두 개 있는 것처럼 사용할 수 있다는 점이고 단점은 역시나 자원 소모가 좀 큰데다가 레이턴시가 크다는 거다. 스트리밍을 할 때 채팅만 간단하게 띄우거나 OBS 모니터링 용으로 쓰기에 적당한 것 같다.
