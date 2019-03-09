---
layout: post
title: Fix restic full disk error with overlayfs
category: sysop
tags:
- restic
- overlayfs
- backup
date: 2019-03-09 12:57:55 +0900
---

난 [Restic][]을 이용해 시스템 백업을 주기적으로 하고 있었다. 중복제거, 증분백업 등 장점이야 여러가지가 있는데 딱 하나가 문제였다. 백업 도중에 하드가 가득 차면 더이상 진행이 안 되는데 중간에 남겨진 파일은 삭제가 안 된다. 여기서 문제는 `restic prune` 명령을 하면 사용되지 않는 파일을 삭제해 주지만 구현 방식상 이 상황에선 쓰지 못한다는 것이다.

`restic prune` 명령을 사용하면 스냅샷을 쭉 둘러보고 인덱스를 새로 구축한 다음에 안 쓰는 파일을 삭제하는데 이미 용량을 다 쓴 드라이브에서 삭제를 먼저 하지 않고 인덱스 재구축이 될 리가 없다. 링크가 없는 블롭만 먼저 찾아 없애주면 좋겠다만 아직은 그렇지를 않으니 다른 해결법을 찾아봤다.

> 임시로 용량을 늘려주면 되는 거 아니야?

더 큰 하드에 저장소를 몽땅 복사 한 다음에 prune을 돌리고 다시 복사하면 문제는 해결 되지만 그 큰 저장소를 하드 간에 복사 하기란 말도 안 되게 오래 걸리는 일이다. 그래서 [overlayfs][]를 쓰기로 했다.
overlayfs는 기존 파일들은 그대로 두고 변경사항만 따로 다른 파일시스템/디렉터리에 저장하는 방식인데 수정이나 추가 된 파일은 upper라고 불리는 곳에 그대로 써버리고 파일 삭제는 character 특수파일을 만들어서 마킹을 하게 된다. 결국 원본은 안 건드리고 새 마운트 지점에 파일을 추가/수정/삭제 할 수 있다는 얘기니까 여기서 prune 명령을 돌려서 용량을 줄인 다음에 [rsync][] 등으로 싱크를 돌려 주면 된다.

이 예제에서 원본 저장소는 `/mnt/backup`이다. 말 안 해도 알아서 수정해서 쓰면 된다.

```sh
mkdir /tmp/{upper,overlay,workdir}
mount -t overlay overlay -o upperdir=/tmp/upper,lowerdir=/mnt/backup,workdir=/tmp/workdir /tmp/overlay
restic -r /tmp/overlay prune
rsync --delete-before -rulHtv /tmp/overlay/ /mnt/backup/
umount /tmp/overlay
rm -r /tmp/{upper,overlay,workdir}
```

[Restic]: https://restic.net/
[overlayfs]: https://wiki.archlinux.org/index.php/Overlay_filesystem
[rsync]: https://wiki.archlinux.org/index.php/rsync
