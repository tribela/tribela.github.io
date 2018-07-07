---
layout: post
title: 마스토돈에서 일어난 Tootdon 삭제에 관련해서
category: mastodon
tags:
- tootdon
- privacy
date: 2018-03-28 18:38:48 +0900
---

## 모든 일의 시작

> 2018-02-13 04:16 @sftblw@twingyeo.kr: 툿돈 서치 탐라는 어떻게 구현한건지 궁금하긴 한데... [^1]

[^1]: https://twingyeo.kr/@sftblw/99513992207846752

설명: 마스토돈엔 원래 어뷰징을 방지하기 위해 해시태그를 제외하고는 사람들이 쓴 글을 일반적인 키워드 검색을 통해 찾을 수가 없게 되어 있었다. 현재는 자신이 관여 된 글에 한해서만 검색이 가능한데 이 기능이 생기기 전부터 Tootdon이라는 앱에는 일반검색이 되는 기능이 있었다.

나는 당연히 "아니 그럼 설마 사설 서버에 우리가 쓴 글을 저장하고 (마스토돈의 사상을 거스르면서까지) 검색 기능을 제공하는 거야?"라는 생각에 앱을 뜯어봤다.


## 도화선을 깔았다

> 2018-02-13 05:12 @jarm@qdon.space: 왠지 툿돈 서버에 공개 툿들을 저장해 두고 거기서 검색할 것 같다는 안 좋은 느낌이... [^2]

[^2]: https://qdon.space/@jarm/99514212223813626

> 2018-02-13 05:17 @jarm@qdon.space: DNS 쿼리 까보니까 tootdon-api-prod.us-west-2.elasticbeanstalk.com로 연결 되네요. 여기에 뭔가 있을 듯 [^3]

[^3]: https://qdon.space/@jarm/99514230017318097

> 2018-02-13 05:24 @jarm@qdon.space: api.tootdon.ooo를 사용하는 듯 한데 APK 까서 볼 수 있는 만큼 볼게요. 왠지 재밌을 것 같아요 [^4]

[^4]: https://qdon.space/@jarm/99514259677623660

> 2018-02-13 05:48 @jarm@qdon.space: api.tootdon.ooo/api/v1/statuses
> 여기에 URL 파라미터로 q, instance, ref를 넣을 수 있네요.
> 다만 Accept 헤더를 application/json으로 줘야 제대로 응답을 해서 브라우저 주소창에 그냥 치면 안 됩니다 [^5]

[^5]: https://qdon.space/@jarm/99514354143030702

이 외에도 여러 대화가 오고 갔는데 결론은 api.tootdon.ooo라는 사이트를 입구로 가지는 어딘가에 Tootdon을 이용해서 작성하는 공개설정이 `public`인 툿을 모두 저장하고 있다는 걸 알아냈다.
이 때만 해도 Tootdon으로 작성하지만 않으면 저장 될 일이 없으니 안 쓸 사람만 안 쓰면 된다고 생각했다.


## 얘들 뭔가 이상한데??

> 2018-03-28 03:11 @jarm@qdon.space: 툿돈의 검색 기능에 대해서 좀 더 파 봤는데 아무래도 툿돈에서 작성한 툿 뿐만 아니라 그 유저들이 부스트 하거나 하는 툿들도 저장하는 것 같다.
> 안 그러면 다른 앱에서 작성한 툿들이 툿돈 사설 서버에서 검색 될 이유가 전혀 없잖아.
> 한 마디로 내가 툿돈을 안 쓴다고 해서 툿돈에서 완벽히 벗어나는 게 아니라는 뜻. 대체 뭐 하는 짓이야.. 아무리 공개 범위가 public이라고 해도 그걸 저장하는 건 또 다른 찝찝함이란 말이야. [^6]

[^6]: https://qdon.space/@jarm/99757213278489523

![Tootdon search screenshot]({{ "/imgs/2018-03-28/ec9e3fbfc97c45ec.png" | absolute_url }})

갑자기 뭔 생각에 그랬는지 몰라도 미심쩍어서 다시 그 API에 요청을 때려 봤는데 Tootdon을 사용하지 않은 글들이 나왔다.
한 달 넘게 **Tootdon을 사용하지만 않으면** 내 툿은 절대로 그 서버에 저장 되지 않을 거란 믿음이 깨져버린 순간이었다. 내가 사용하지 않더라도 그걸 사용하는 사람이 내 글에 접촉(멘션, 부스트, 별글)을 하면 그걸 또 서버로 보낸다.
어차피 공개 설정이 `public`이라는 건 어디에 아카이빙 되어도 괜찮다는 뜻으로 글을 써야 하는 건 맞지만 그게 이런 식으로라면 좀 상황이 달라진다. 약관 상의 문제는 없겠지만 _어뷰징을 방지하기 위해 검색 기능을 제한하는_ 마스토돈의 결정에 정면으로 반하면서 그걸 자기들끼리만 쓴다는 게 이건 좀 아니다 싶어서 해외쪽에 글을 남겼다.

<iframe src="https://mastodon.social/@kjwon15/99757268648426867/embed" class="mastodon-embed" style="max-width: 100%; border: 0" width="400"></iframe><script src="https://mastodon.social/embed.js" async="async"></script>

https://mastodon.social/@kjwon15/99757268648426867


## 알고보니 그 도화선이 화산으로 이어져 있었다.

<iframe src="https://mastodon.social/@slipstream/99757282934340893/embed" class="mastodon-embed" style="max-width: 100%; border: 0" width="400"></iframe><script src="https://mastodon.social/embed.js" async="async"></script>

https://mastodon.social/@slipstream/99757282934340893


학교에 씻고 학교에 갔다가 잠깐 확인해 보니 알림창이 폭발적이었다. 그 중 한 유저는 당장 뜯어보겠다고 했다.

<iframe src="https://mastodon.social/@slipstream/99757389248860842/embed" class="mastodon-embed" style="max-width: 100%; border: 0" width="400"></iframe><script src="https://mastodon.social/embed.js" async="async"></script>

해당 API는 인증 없이 사용할 수 있는데 잘못 뜯었는지 인증을 해야 사용 가능한 걸로 착각한 듯 한데 mobirocket이라는 회사와도 연결 되어 있다는 걸 발견했다.

<iframe src="https://mastodon.social/@slipstream/99758520139922701/embed" class="mastodon-embed" style="max-width: 100%; border: 0" width="400"></iframe><script src="https://mastodon.social/embed.js" async="async"></script>

**?!?!?!!?!**
글 뿐만 아니라 앱에서 인증 토큰을 서버로 전송하고 있었다고 한다.
이건 약관이고 뭐고 말할 것도 없이 끝났다. 이후로 많은 사용자들이 툿돈을 삭제하고 인증 된 앱 목록에서 권한까지 박탈하는 난리파티가 났고, 심지어 한 인스턴스의 관리자는 친절하게 가이드까지 해 주며 툿돈을 삭제하라는 [공지](https://monsterpit.net/@daggertooth/99758674665873612)를 썼다.

그 와중에 툿돈 공식 계정은 뭘 했냐면...

<iframe src="https://mstdn.jp/@tootdon/99759644880024717/embed" class="mastodon-embed" style="max-width: 100%; border: 0" width="400"></iframe><script src="https://mstdn.jp/embed.js" async="async"></script>

https://mstdn.jp/@tootdon/99759644880024717

> 우리는 퍼블릭으로 된 글만 수집하는데다가 툿돈 클라이언트에서 글을 삭제하면 곧바로 데이터를 지워. 그리고 한 달이 지난 것들은 모두 삭제해.

라는 평화로운 말을 했다.
툿돈 유저가 쓴 글은 툿돈을 사용해서 지운다고 치자. 나는 툿돈을 사용하지도 않았는데 자기들이 수집해 놓고선 툿돈 앱으로 들어가서 삭제하면 된다? 차라리 사람이 날갯짓을 하면 날 수 있다고 해라.

아무튼 사람들은 "이래서 오픈소스 프로젝트 사이에 클로즈드 소스 프로그램이 딱 하나 끼어 있는 게 마음에 안 들었어"라며 대체 앱으로 갈아타기 시작했다. 성향이 성향이라 그런지 안드로이드 계열은 Tusky, Mastalab 등의 괜찮은 오픈소스 앱이 있는데 비해 iOS쪽은 마땅한 대안이 Amaroq밖에 없는데 얘도 좀 비실비실 하다고 한다.


## 이후의 이야기

(가뜩이나 유저도 없는) 한국 마스토돈 유저들 사이에서 시작 된 일이 이렇게 커질 줄은 몰랐지만 아무튼 재밌었다. 그러던 중 갑자기 떠오른 툿돈의 [약관](https://tootdon.club/tos)이 있는데...

> 9-13 本サービス又は本アプリを逆アセンブル、逆コンパイル、リバースエンジニアリング、その他本サービスのソースコードを解析する行為
> 9조 13항: 이 서비스 또는 이 앱을 분해, 디컴파일, 리버스 엔지니어링 및 기타 본 서비스의 소스코드를 분석하는 행위(를 금한다)

<iframe src="https://mastodon.social/@kjwon15/99760834952447130/embed" class="mastodon-embed" style="max-width: 100%; border: 0" width="400"></iframe><script src="https://mastodon.social/embed.js" async="async"></script>

다른 앱에서야 그냥 그러려니 하고 넘어 갈 조항이지만 이 항목을 다시 보니 참 여러 생각이 든다.
(물론 조항 개무시하고 뜯었다. 약관 위반이 불법은 아니니까. 애초에 이 앱을 더 사용 할 이유도 없었고)

재밌는 건 툿돈이 마스토돈 프로젝트의 최대 후원자 중 하나다. 말도 안 되는 짓을 한 툿돈을 버린다면 후원금이 뚝 떨어지긴 할텐데 플래티넘 후원자가 되기 위한 조건이 그렇게 거대하진 않아서 아마 툿돈을 삭제 한 유저들이 1달러씩만 후원하기로 해도 매꿔 질 것 같다.

안 그래도 요즘 페이스북이 통화기록을 다 가져가는 이상한 짓을 해서 deletefacebook이니 뭐니 하는 판인데(덕분에 마스토돈 유저 늘었다) 마스토돈의 제일 잘 나가는 클라이언트 앱 하나가 이런 일을 하고 있었다는 게 밝혀지니 참..

> 2018-03-28 10:50 @kaniini@pleroma.dereferenced.org [^7]
> APP MODEL INSPIRED BY BOOKFACE OBVIOUSLY


[^7]: https://pleroma.dereferenced.org/objects/47a57bb2-c88c-4330-8b38-efe03f5ff70c
