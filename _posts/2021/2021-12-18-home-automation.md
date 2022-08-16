---
layout: post
title: 홈 오토메이션
category: home automation
tags:
- home automation
- homeassistant
- google home
date: 2021-12-18 18:22:11 +0900
---

홈 오토메이션이 활성화가 되기 이전부터 손수 하나하나 깎아가며 홈 오토메이션을 만들어 왔던 입장에서 Home Assistant로 넘어온 이후까지 대충 정리해보는 글


## 원시시대

내가 처음으로 홈 오토메이션을 시작할 당시에는 구글 홈 같은 것도 없었다. 그나마 비슷한 게 있었다면 핸드폰 앱으로 스위치를 원격 조작할 수 있는 스위처 같은 제품들이 있었는데, 나왔을 당시부터 나는 해당 제품을 말이 안 된다고 생각했기에 구입조차 하질 않았다.

따로 태스커 등의 앱과 연동도 안 되고 프로토콜이 공개되어 있지도 않아서 결국은 핸드폰에서 전용 앱을 열어서 조작을 해야 하는 방법밖에는 없는데, 주머니에서 폰을 꺼내서, 잠금을 해제하고, 앱을 찾아 열어서, 버튼을 누른다 - 여기까지의 과정이 딱히 편한 것으로 보이질 않았다. 태스커 연동이라도 되면 내가 침대에 누워 폰을 충전기에 연결하면 알아서 아무런 조작도 필요치 않고 그냥 불을 끌 수도 있는데 굳이 눈을 뜬 채 폰을 조작해야 하는가 하는 의문이 들었기 때문에, 자작을 하기로 결심했다.

### 자작의 장점

#### 확장성

그냥 파이썬으로 HTTP 서버와 GPIO로 릴레이를 조작하면 되는 수준이라 코드만 짤 줄 알면 누구나 만들 수 있는데 비해 할 수 있는 것은 무궁무진해진다. HTTP 요청만 날리면 되기 때문에 폰에서 태스커를 이용해서 조작할 수도 있고 심지어는 노트북에서 명령줄을 통해서도 요청할 수 있으며 crontab에 넣어서 일정 시각이 되면 알아서 작동하게 할 수도 있다.

지금이야 "구글 홈 루틴으로 다 되는 거 아닌가?"라고 생각할 수 있겠지만, 그런 게 없던 시절이다. 그리고 현재도 구글 홈의 루틴 기능은 멍청하기 짝이 없기 때문에 아직도 자작이 더 나은 확장성을 제공한다.

구글 홈과의 연동이 안 된다는 단점이 있기는 했지만 지금은 SDK과 API가 열렸기 때문에 구글 홈의 프로토콜만 맞춰 주면 자작한 장비를 구글 홈에 등록할 수도 있다. 그렇게 어렵지도 않다.

#### 안정성

구글 홈을 사용해보면 알겠지만, 구글 홈의 모든 명령은 구글 클라우드를 통한다. 내가 내 집 안에서 내 집 안에 있는 기기를 조작하는데 왜 미국에 있는 구글 서버를 거쳐야 하지? 하는 생각이 강하게 드는 지점이다. 물론 집 밖에서 조작할 때야 그러려니 하지만 집 안에서는 납득이 안 간다.

더군다나 구글 홈은 구글이 죽으면 집 안에서 집 안을 조작하는 게 아예 안 되기 때문에 더 말이 안 된다. 구글이 설마 죽겠어 싶지만, 올 해에 실제로 일어났던 일이다.

반면에 자작을 하면 집 안에선 공유기만 안 죽으면 바로 옆에서 패킷을 쏴서 조작할 수 있다. 집 밖으로 나갈 일도 없고 Firebase도 안 쓰기 때문에 빠르기도 하다.


### 자작으로 어디까지 해봤나

뭘 자동화에 사용했나 살펴보면 대표적으로 아래와 같다.

- 형광등은 Onion Omega라는 장치에 릴레이를 달아서 조작했다
  - [apagando](https://github.com/tribela/apagando)
- Yeelight bedside라는 제품은 전용 앱을 사용하기 싫어서 블루투스 패킷 분석을 통해 해킹해서 컴퓨터에 연동해 사용했다
  - [yeelight](https://github.com/tribela/yeelight)
- 와이파이의 모니터 모드를 이용해서 집에 누가 들어왔나 체크했다
  - [wifi-monitor](https://github.com/tribela/wifi-monitor)

위의 3개와 더불어 여러가지를 추가해서 뭘 했나 살펴보면

- 집에 들어가면 불이 켜지고 나가면 불이 꺼지도록 했다 - 제일 기초적인 자동화다
- 아침에 일어날 시간이 되면 자동으로 불을 켜면서 MPD와 연동해 음악을 재생시켰다 - 강력추천
- 집에 들어가기 1시간 전에 에어컨을 틀려고 적외선 리모컨 프로토콜을 분석했다 - 결국 여러 문제로 못 했다
- 음성명령을 쓰기 너무 싫기도 하고 음악을 틀어 두면 음성을 인식하기 어려우니 휘파람으로 모든 것을 조작했다
  - [whistle](https://github.com/tribela/whistle)


## Home assistant의 적용

하지만 시대가 많이 지났기 때문에 홈 오토메이션 관련해서 좋은 제품들이 많이 나왔다. 하지만 여전히 구글 홈은 멍청했고, 셀프호스트가 되는 Home Assistant를 사용하기로 결정했다.

### 자작의 단점

다른 사람은 그렇지 않겠지만 나는 자작을 하면서 마이크로 서비스를 여러 개 만들었다. 형광등은 형광들을 조작하는 장치를 스위치 부근에 달았고, 아침에 형광등을 켜는 것은 홈서버, 내가 집에 들어오는 것을 감지하는 와이파이 모니터는 또 다른 장치가 감지해서 형광등에 직접 명령을 내리고.. 암튼 하나가 죽어도 다른 애들은 작동한다는 장점은 있었지만 복잡하다는 문제가 있었다. 그래서 하나의 좋은 서비스를 이용하기로 했다.

추가적으로 자작을 하면 기성 제품들을 연동하기 어렵다. 매번 프로토콜을 분석해서 해킹해야 하고.. 원시시대엔 이 방법이 차라리 나았지만 지금은 시대가 바뀌었기 때문에 누가 잘 만들어 놓은 것을 최대한 잘 이용하는 게 새로운 길이 되었다.

### Home assistant의 장점

#### 점진적인 적용이 가능하다

처음부터 기존 환경을 아예 갈아타는 건 귀찮고 어렵다. Home assistant는 Smart things나 구글 홈과의 연동을 지원하기 때문에 거기에 등록된 기기를 Home Assistant에서 끌어와 사용하는 것이 가능하다 (하지만 이렇게 사용하면 구글 클라우드를 거친다)


#### 로컬에서 사용이 가능하다

외부에서 원격으로 사용하는 것도 가능하지만 기본적으로 로컬 사용이 가능하다면 로컬을 우선으로 사용하기 때문에 아주 빠릿빠릿하고 외부 서버들이 죽어도 잘 돌아간다. 집 안에서 와이파이 통신이나 직비 통신만 가능하다면 멀쩡하다.


#### 초보자부터 고급 유저까지 모두 고려가 되어 있다

블럭식 코딩과 비슷한 오토메이션 설정을 지원해서 코딩의 경험이 없는 사람들도 쉽게 오토메이션을 설정 가능한데, 이게 구글 홈의 멍청한 루틴보다 직관적이고 기능도 다양하다. 예시로 다음과 같은 일들을 할 수 있다.

- 트리거 - 폰이 충전기에 꽂아질 때
- 조건 - 밤 9시가 넘음 AND 내가 집 안에 있음 AND 형광등이 꺼진 상태
- 실행할 내용 - 잠자기 스크립트 실행

- 트리거 - 구성원 중 하나가 집에 들어올 때
- 실행할 내용
  - 집에 아무도 없었으면 - 거실과 안방 불을 켜기
  - 집에 누군가 있었으면 - 거실 불만 켜기

- 트리거 - 폰이 충전기에서 분리될 때
- 조건 - 집에 있었어야 함
- 실행할 내용 - 일기예보 실행, 안방과 거실 불 켜기

- 트리거 - 해가 뜰 시각에서 1시간 전
- 조건 - 누군가는 집에 있어야 함
- 실행할 내용 - 30분에 걸쳐 서서히 무드등을 이용해 밝아지게 하고 이후 무드등은 끄면서 형광등 켜기

위 내용들 전부 다 구글 홈이나 스마트띵스에서는 안 되지만 홈 어시스턴트에서는 간단하게 작성이 가능하다.

반면 고급 사용자를 위해서 Yaml을 이용한 고오급 스크립팅도 지원한다. Jinja2 템플릿도 이용 가능하기 때문에 Yaml로 프로그래밍을 하게 되는 수준인데, 일기예보 상태를 불러와서 날씨에 따라 다른 색으로 조명을 설정하는 것도 가능하고 뭣하면 파이썬 등으로 스크립트를 만들어서 플러그인으로 넣는 것도 가능하고 아무튼 확장성은 무한하다.

API도 제공하기 때문에 토큰만 발급하면 예전처럼 CLI에서 명령으로 불을 켜고 끄는 것도 가능해지는데, 개인적으로 컴퓨터로 일을 하는 사람으로서 컴퓨터에 항상 붙어 있게 되는데 "OK 구글, 불 꺼줘"라고 하는 것보다는 그냥 이미 열려 있는 터미널에서 `sw 0` 같은 명령을 치는 게 20배는 빠르다. (추가적으로 구글은 이제 OK Google에 띠링! 하는 소리마저 내지 않기 때문에 이 놈이 듣고 있는지 아닌지도 모른다. 너무 답답하다)


#### 화면구성 + 앱이 잘 되어 있다

자작을 하던 시절엔 원래부터 UI를 짜는 것을 싫어했고, 내가 직접 명령을 내리는 것은 초짜들이나 하는 거라는 마음가짐도 조금 가졌기 때문에 모든 것을 직접적인 조작 없이 알아서 작동하도록 만들었었다. 하지만 누군가가 집에 놀러왔을 때라든지. 언젠가는 명시적인 조작이 필요할 때가 있다. 홈 어시스턴트는 대시보드를 만들기 아주 좋게 되어 있고 안 쓰는 태블릿이나 폰을 이용해 대시보드만 켜 놓는 머신으로 활용할 수도 있다.

앱을 설치하면 폰에 있는 센서들도 몽땅 활용이 가능해지기 때문에 자동화 스크립트에서 원하는만큼 이용할 수 있게 된다.

- 사람마다 트래킹 장비를 지정해서 폰이 집에 들어오면 내가 집에 들어온 것으로 인식하기
- 배터리가 부족한 상태 인식 가능
- 안드로이드의 활동 센서를 이용해 잠을 자는지 운동 중인지 차에 탔는지 알 수 있음
- 충전기에 꽂는 것을 이벤트로 활용 가능하며 충전기의 종류도 대략적으로 구분함
- NFC 태그 이용 가능
- 전화를 받는 중인지도 파악 가능

저게 굳이 필요한가? 싶은 것들도 있겠지만 상상력을 동원하면 어떻게든 유용하게 쓸 수 있다. 모든 건 자동화 스크립트를 작성하는 사람의 상상력에 달렸다.


#### 사용자가 많다

사용자가 많기 때문에 웬만한 기성 제품들은 Home Asisstant에서 더 많은 기능을 사용할 수 있을 정도로 잘 되어 있다. 블루프린트 공유를 통해 내가 원하는 기기만 입력창에 넣으면 누가 이미 잘 만들어 놓은 자동화 스크립트를 추가할 수도 있으며, 문제 해결이나 아이디어를 얻기도 굉장히 좋다.


## 자동화 팁


### 조건+트리거와 실행내용을 분리하기

집에 오면 거실 불을 켜는 자동화 스크립트를 만든다면, 집에 오는 트리거 부분과 거실 불을 켜는 부분을 분리하는 게 좋다. 거실 불을 켜는 동작은 나중에 기기가 바뀔 수도 있고, 다른 기기도 추가해서 동작을 추가해야 할 수도 있고 "집에 오면"이라는 조건은 나중에 다른 조건이 추가 될 수도 있다.
프로그래머의 언어로 표현하자면, 리팩토링의 용이성과 중복코드 제거라고 할 수 있겠다.


### 음성명령은 최소화

"야야야야야야야!! 일로 와바! 큰일났어!" "왜? 뭔 일인데" "방 불 좀 꺼주고 가"
는 사람한테나 통하는 방법이다. 2021년인데도 음성인식은 바보 같을 때가 많고 컴퓨터는 음성 이외의 방법으로도 나를 인식할 방법이 무궁무진하다.
집에 들어오면 그냥 불이 켜지면 되는데 내가 굳이 "집에 왔으니 불을 켜 줘"라고 말을 해야 켜질 필요가 없다는 것에는 동의할 것이다. 잠을 자려고 침대에 누으면 불이 꺼지는 것이나 기타 다른 자동화들도 마찬가지다. 매번 반복해서 일어나는 것들은 온갖 센서를 이용해서 자동화를 넣으면 된다. 음성명령은 예외상황에만 쓰는 것이고 음성명령으로 모든 것을 조작하는 것은 초짜들만 하는 것이다 하는 생각을 가져보자 (음성명령이 나쁘다는 것은 아니다)

간단한 예시를 들자면, 나는 핸드폰을 활용한다.
위에서도 예시를 들었지만 밤 9시가 넘어서 집에서 폰을 충전기에 꽂는 행동은 나에겐 잠들기 전에만 하는 행동이기 때문에 이걸 트리거로 해서 집안 모든 불을 끄고 무드등만 켜고 서서히 꺼지도록 하는 스크립트를 실행했다.
반대로 오전 6시 이후 처음으로 핸드폰을 충전기에서 분리하는 행동은 잠에서 깨고 일어났다는 뜻이다. 어차피 화장실로 갈 것이니 거실 불을 켜도록 했다. (안방 불은 이미 해가 뜨면서 날 깨우기 위해 서서히 켜졌다)

더 활용을 하자면 잠자리에 든 것일 상태인데 밤에 폰을 집어들었으면 그건 물을 마시러 나갔거나 화장실에 간다는 뜻이니 다시 내려놓기 전까지는 거실 불을 켜도록 할 수도 있다.

다시 말하지만, 사용자의 상상력에 달렸다. 모션센서나 기타 여러가지 센서가 있으면 더 좋을 수도 있겠지만 웬만한 경우에는 기본으로 있는 것들만 가지고도 많은 것을 할 수 있다.


### 예상치 못한 결과에 대비하라

홈 오토메이션은 편리하지만, 그렇다고 형광등 스위치를 없애는 짓은 하지 말자. 예전에 자작하던 시절에는 스위치를 아예 없애고 살아봤는데, 폰이나 컴이 죽으면 불을 못 켠다. 물리적인 스위치를 아예 안 써도 될 정도로 자동화를 한다 해도 물리적인 스위치로 조작은 가능하게 해 두는 것이 좋다.

개인적으로 형광등은 Sonoff basic을 사용하고 있는데 이건 기존 스위치를 끄면 전원이 차단되어서 아예 형광등이 꺼진다. 원격으로 켜는 것은 불가능하다는 단점은 있지만, 전원이 들어왔을 때 어떻게 행동할지는 설정할 수 있기 때문에 나는 "무조건 켜기"로 설정했다. 이러면 아예 다 죽어도 스위치를 껐다 켜면 불은 들어온다.

요즘은 그냥 집안 스위치를 재활용하면서 스위치 뒤에 매립하는 제품도 잘 나와 있으니 새로 구성하려는 사람들은 참고하면 좋다. 나는 이미 이렇게 구성했기 때문에 추가로 구성할 때나 고려하겠지만.

### 혼자 사는 집과 둘 이상이 살거나 누군가가 자주 놀러오는 집의 차이는 매우매우매우 크다.

집에 들어오면 불을 켜고 나가면 끄고 하는 동작부터도 혼자 사는 집은 한 명만 파악하면 되지만 둘 이상이 살면 "모두가 나간다"와 "한 명도 없었는데 한 명 이상이 들어온다"로 바뀌게 된다. (이 부분은 Hass에서는 그룹 기능을 활용하면 된다)
누군가 놀러왔을 때 나 혼자 간식을 사러 나갔는데 불이 꺼져버리는 일을 방지하려면, 외부인이 들어왔을 때 켜는 가상의 스위치(대시보드에 추가 가능하다)를 만들어서 자동화 스크립트에서 이것을 조건에 추가하거나 하면 된다.


## 기타 잡설

안드로이드 버전 11까지는 전원버튼을 꾹 누르면 전원메뉴는 상단에 뜨고 아래에는 홈 오토메이션 관련된 메뉴들이 주르륵 뜨게 할 수 있었다. 하지만 12버전에 오면서 못 쓰게 되었다. [^1]

[^1]: https://www.androidpolice.com/2021/06/11/android-12s-relocated-smart-home-controls-have-people-rightfully-upset/

12에 오면서는 상단바를 내리면 메뉴가 뜨게 할 수 있고 잠금화면에서는 왼쪽 아래에 작은 버튼을 누르면 해당 화면이 뜨도록 변경되었는데, 상황에 따라 여는 방법이 다른 것도 불편하고 전원버튼이라는 물리적인 감각으로 찾을 수 있는 것을 꾹 누르면 나오는 것에 비해 상당한 조작을 요구한다. 물론 전원버튼은 핸드폰의 전원을 조작한다는 본연의 기능과는 거리가 멀었지만, 가슴에 손을 얹고 생각해봐라, 전원버튼을 꾹 눌러서 전원메뉴로 폰을 끈 적이 몇 번이나 되나.
더군다나 홈 오토메이션을 쓸 사람은 쓰게 놔두고 사용하지 않은 사람만 새 전원메뉴를 사용할 수 있게 분기를 나눴어도 됐다. 사람들은 분노하고 있고, 구글은 고치지 않을 것이다.

그래서 Aqara(샤오미 브랜드다)의 스마트 큐브라는 제품을 샀다. 그냥 정육면체로 이쁘게(포탈에 나오는 Aperture science가 생각날 정도) 생겼는데, 어느 면을 위로 향했는지, 시계방향으로 돌리는지, 흔드는지, 톡톡 쳤는지 등을 다양하게 인식할 수 있고 직비를 활용해서 배터리도 오래 가기 때문에 이젠 더이상 쓸 수 없다시피 한 안드로이드의 메뉴 대신 쓰려고 구매했다.
하지만 X, Y, Z축으로 회전해 90도 단위로 뒤집는 것은 인식을 잘 하지만 손에 들고 이리저리 돌렸다가 특정 면으로 내려놓는 것은 잘 인식을 못 하는 듯 하다. 아마 내가 사용하는 블루프린트의 문제일 가능성이 크긴 한데, 적어도 안드로이드의 망한 기기조작 메뉴보다는 편하다.

에어컨의 경우 삼성의 제품을 쓰면서 스마트띵스에 연결하고 구글홈에 그걸 불러와 사용하고 있었는데 구글의 문제인지 삼성의 문제인지 멍청하게도 이게 구글홈 앱에서는 크고 켜고만 할 수 있었다. 온도 조작은 음성으로 명령해야만 하고 그제서야 손으로 조작할 수 있는 슬라이드가 튀어나왔다. 당연하게도 현재 온도설정은 화면에 뜨질 않았다.
그런데 삼성 스마트띵스를 Hass에서 불러오니 온도 설정과 현재 방 온도, 볼륨설정, 운전옵션 등 다양한 옵션들이 전부 사용 가능했다. 어이가 없지만 구글 홈에 Hass를 연결해서 구글 홈에서는 구글-Hass-삼성을 거쳐 사용하게 되었는데 예전과 다르게 모든 옵션이 모두 화면에 뜨게 되었다.
아마도 삼성이 구글 홈보다 삼성의 자체 앱을 사용하도록 강제하기 위해서 구름 홈에 연동하면 사실상 사용이 불가능하도록 정보를 조금만 제공하도록 만든 것 같다. 소비자 입장에선 그저 불편하기만 할 뿐이다.

![Google Home with Samsung Smart things]({{ "imgs/2021-12-18/aircon-samsung.png" | absolute_url }}){:width="250px"}
![Google Home with Home Assistant]({{ "imgs/2021-12-18/aircon-hass.png" | absolute_url }}){:width="250px"}


구글 홈은 기능이 빈약하다는 걸 매번 느끼게 된다. 한 방 안에 둔 전등은 모두 묶어서 표현해서 하나하나 개별로 켜려면 굳이 3스텝 정도를 거쳐서 개별 전구로 들어간 다음 조작해야 하는데, 이게 미국 스타일의 큰 집에서 형광등을 여러 개 두는 경우에는 쓸모가 있겠지만, 한국은 집이 크지도 않고 방마다 형광등은 하나로 충분하기 때문에 의미가 없다.
안방에는 형광등과 무드등이 하나씩 존재하는데, 상식적으로 불을 켜라고 하면 형광등만 켜야 하지만 구글은 멍청하게 둘 다 켠다. 무드등은 형광등을 껐을 때만 의미가 있는데 구글은 그걸 전혀 모르기 때문에. 결국 실제로는 같은 방에 있지만 다른 방에 있는 것으로 설정을 하거나, 이름을 아예 다르게 지정해서 "안방 불"을 켜달라고 했을 때 "안방"이라는 공간에 있는 불을 켜는 게 아니라 "큰 방"에 속한 "안방 불"이라는 전구 하나를 켜도록 설정해야 하는 등 구글님의 입맛에 맞게 설정을 잘 해야 한다.
Hass에서는 그냥 형광등만 그룹지어서 그걸 켜고 끄도록 하면 되기 때문에 컴퓨터님의 입맛에 맞게 비직관적으로 설정할 필요가 전혀 없다.

루틴의 경우에도 구글이 너무 빈약하다. 위치정보를 준실시간으로 받아오지 못하기 때문에 인공지능을 통해서 "집에 가는 중이라고 판단하면" 집에 도착한 것으로 간주해 루틴을 실행시켜버린다.
반면 Hass의 경우에는 지오펜스를 설정해서 집으로 설정한 공간에 들어오는 순간 이벤트를 잡아서 별다른 인공지능 파워 없이 실제로 집 주변에 왔을 때만 집에 온 것으로 인식한다. 구글이 만든 안드로이드에서 제공하는 기능인데 구글 홈에서 활용을 안 하는 건지 뭔지 모르겠다.
심지어는 삼성 폰 같은 걸 쓰면 샘숭의 커스텀 때문에 위치정보를 며칠동안 업데이트 하지 못하는 경우도 생긴다. 덕분에 파트너는 집에 있는데도 불구하고 내가 나갔다고 모두가 나간 걸로 판단해서 불이 꺼져버리는 일도 있었다. Hass로 바꾼 이후에는 발생하지 않는 문제다.
그리고 지오펜스 관련 조건은 "집에 아무도 없었는데 누군가가 집에 왔을 때"와 "집에서 모두가 나갔을 때" 두 가지 경우만 존재한다. "이미 누가 있는 상황에서 다른 사람이 들어왔을 때" 같은 조건은 존재하지도 않고, 집에 들어온 게 누군지에 따라 분기를 가를 수도 없다.
집에 내가 자고 있어도 같이 사는 파트너가 집에 오면 거실 불은 켜야 하기 때문에 구글 홈의 루틴을 모두 삭제하고 Hass의 자동화 조건으로 모두 바꾸었다. 지오펜스 인식률을 포함해서 훨씬 만족스러워졌다.