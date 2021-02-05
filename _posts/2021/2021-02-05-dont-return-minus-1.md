---
layout: post
title: return -1 / exit(-1)을 사용하지 마세요
date: 2021-02-05 11:17:00 +0900
category: programming
tags:
- c
- linux
- posix
- shell scripting
---

주로 POSIX OS 밑에서 프로그램을 작성할 때 에러가 나면 메인 함수에서는 `return -1;`, 다른 함수에서는 `exit(-1);`을 쓰는 경우를 굉장히 자주 목격할 수 있습니다. 단언하자면 이건 틀렸으며 사용하지 말아야 합니다. 전부 `-1`을 `1`로 바꿔야 합니다.

아래는 표준 exit code들에 대한 설명입니다[^1].

`1` : Catchall for general errors
`2` : Misuse of shell builtins
`126` : Command invoked cannot execute
`127` : Command not found
`128` : Invalid argument to exit
`128+n` : Fatal error signal "n"
`130` : Script terminated by Control-C
`255`* : Exit status out of range
*: 255를 넘어가는 exit code에 대해서는 mod256을 적용해 0-255 범위에 맞춘다.

우리가 늘상 써왔던 웬만한 모든 종류에 대한 에러를 위한 exit code는 보시다시피 `1`입니다. 그렇다면 `-1`을 리턴하면 어떻게 될까요?
주석에 쓰인대로 mod256을 해서 0-255 범위로 맞춘다고 되어 있는데 다시 말해서 최하위 1바이트만 남기고 나머지는 다 버린다는 뜻입니다. `-1`은 `0xffffffff`처럼 표기되죠? 1바이트만 남으면 `0xff`가 되고 255 = Out of range 코드가 된다는 뜻입니다. 한마디로 올바르지 않은 exit code인 것이죠.

---

[^1]: https://tldp.org/LDP/abs/html/exitcodes.html
