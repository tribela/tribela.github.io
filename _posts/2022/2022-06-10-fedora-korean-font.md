---
layout: post
title: Fedora에서 '가' 이후의 한글 자모가 분리되는 문제 해결
category: settings
tags:
- linux
- fedora
- CJK
date: 2022-06-10 19:19:07 +0900
lastmod: 2022-08-17 01:17:13 +0900
---

우분투에서 페도라로 갈아탄지 얼마 안 되었을 때 discord에서 한글 자모가 분리되어 입력되는 현상이 있었다. 입력기의 버그인 줄 알았는데 입력하고 난 뒤 폰에서 열어보면 자모가 분리되어 있지 않았기에 좀 이상했었고 결과적으로 내가 쓴 글이 아니어도 '가' 이후의 모든 글자들이 깨져 보이는 문제가 있었다.

이것저것 찾아보니 원인은 페도라에서는 droid-sans 폰트가 fallback 폰트로 사용되는데 이 폰트엔 없는 글자도 있고 이상한 데이터도 끼어 있어서 특정 문자들 (대표적으로 '가') 이후 문자들이 전부 깨져 보이는 문제가 있었다. 다들 그 폰트는 이제 더이상 관리도 안 되고 noto-sans가 훨씬 더 좋으니 그걸 쓰라는 말밖에 없었다.

문제는 fedora에서 google-droid-sans-fonts 패키지를 지우려고 하면 의존성 문제로 gimp, imagemagick 등의 패키지들도 같이 지워진다는 점이었다. 그래서 한동안은 패키지는 안 지우고 데이터(/usr/share/fonts/google-droid-sans/*)만 지워버린 채 사용하고 있었다. 그래도 해결은 되니까.

다만 페도라 36으로 업데이트를 했더니 해당 패키지의 버전이 올라갔는지 다시 설치가 되었는데 매번 이렇게 패키지는 살려둔 채 데이터만 지우는 것도 좀 아니다 싶었다. 그 때 마침 fontconfig를 이용해서 폰트를 그냥 무시해버리는 설정이 있다는 소식을 들었다. 기존 패키지 데이터를 삭제하는 것이 아니라 추가로 설정을 하는 것이고 심지어 유저 개인 설정으로도 들어갈 수 있어서 루트 권한 없이도 가능한 방법이었다.

```xml
<!-- ~/.config/fontconfig/fonts.conf -->
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <rejectfont>
    <glob>/usr/share/fonts/google-droid-sans-fonts/*</glob>
  </rejectfont>
</fontconfig>
```

---

https://phoikoi.io/2018/04/27/disable-unwanted-fonts-linux.html
