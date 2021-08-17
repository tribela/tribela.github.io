---
layout: post
title: "X-Clacks-Overhead: GNU Terry Pratchett"
category: fun
tags:
- clacks overhead
- Terry Pratchett
- discworld
- Mastodon
- Glitch
date: 2021-08-17 18:33:33 +0900
---

오늘도 브라우저가 아닌 httpie라는 커맨드라인 툴을 이용해 웹을 탐색하고 있었다.
그런데 오늘은 익숙하지 않은 헤더가 보였다.

```
X-Clacks-Overhead: GNU Natalie Nguyen
```

분명 아무리 봐도 누군가의 이름인데 그게 [GNU][] 프로젝트의 이름이 된 것으로 보였다. 하지만 아무리 검색을 해 봐도 Natalie Nguyen이라는 어떤 여성 사진작가만 찾을 수 있었다.

그래서 나는 이 헤더가 어디서 나오는지를 찾아보았다. [Mastodon][]의 포크버전인 [Glitch][]에서 뿌리는 헤더였다[^1].

결과적으로 이것의 정체를 찾아본 결과 GNU와는 그다지 관련이 없는 [GNU Terry Pratchett][]이라는 것이었다.

이 프로젝트의 설명을 보면 테리 프래쳇이라는 어떤 작가의 소설에 나오는 Clacks라는 봉화 비스무리한 것을 그대로 계승해서 인터넷 상에서 누군가의 이름을 추모하고 기억하기 위해 만든 것이라고 한다. 여기서 `GNU`는 그 소프트웨어 재단과는 관련이 없고 해당 소설(Discworld)에서 Clacks에 전해지는 명령어다.

    G: send the message on
    N: do not log the message
    U: turn the message around at the end of the line and send it back again


해당 소설에서 Robert Dearheart라는 사람은 일하다 수상하게 죽은 아들 John을 영원히 기억하기 위해 이런 설계를 했다고 한다.

> "사람은 그의 이름이 불려지는 동안에는 죽지 않는다."
> -- <cite>Going Postal, 챕터 4 프롤로그 중</cite>

소설의 작가인 테리 프래쳇이 세상을 떠나자 IT쪽 사람들은 이를 추모하기 위해 그의 소설에 나온 그대로의 방법을 인터넷에서 구현해서 메시지를 뿌리고 있는 것이었다.

2017년, 마스토돈을 비롯한 연합우주 소셜 네트워크에서는 Natalie Nguyen이라는 트랜스젠더 여성 사진가가 자살을 해서 떠들썩 했다고 한다. 마스토돈의 포크버전인 Glitch에서도 이와 똑같은 방법으로 그를 추모하고 있던 것이다[^2].

---

[GNU]: https://www.gnu.org/
[Mastodon]: https://joinmastodon.org/
[Glitch]: https://glitch-soc.github.io/docs/

[GNU Terry Pratchett]: http://www.gnuterrypratchett.com

[^1]: <https://github.com/glitch-soc/mastodon/commit/254b74c71f24304f0a723d38b3ed76f9a70b8c93>
[^2]: 마스토돈 원본 버전에는 들어있지 않다. 아마 글리치 버전의 제작자가 트랜스젠더인 것이 글리치 버전에 이 문구가 들어가게 된 계기가 아닌가 싶다.
