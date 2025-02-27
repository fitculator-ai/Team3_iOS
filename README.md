# Team3_iOS
## Tuist 프로젝트 설정 방법

### 1️⃣ 프로젝트 클론
```
git clone https://github.com/fitculator-ai/Team3_iOS.git
cd Team3_iOS
```
### 2️⃣ Tuist 설치 (최초 1회만 실행)<br/>
둘 중 하나만 선택 brew를 사용한다면 아래 실행
```
curl -Ls https://install.tuist.io | bash
brew install tuist
```
### 3️⃣ 의존성 패키지 설치
```
tuist install
```
### 4️⃣ Xcode 프로젝트 생성
```
tuist generate
```
정상적으로 완료됐다면 생성된 **Fitculator.xcworkspace** 실행 후 개발
<br><br>

## 🛠️ 기술스택
- Swift: 5
- Xcode: 15.4, 16.0
- iOS: 17.4
- Alamofire, Combine
- 아키텍처 : MVVM

## 🗂️ 담당 업무
<table>
  <tr>
    <th><a href="https://github.com/ksiomng">김송</a></th>
    <th><a href="https://github.com/kyhlsd">김영훈</a></th>
    <th><a href="https://github.com/the-hye">석지혜</a></th>
    <th><a href="https://github.com/Jeongheeji">정희지</a></th>
  </tr>
  <tr>
    <td><img src="https://avatars.githubusercontent.com/u/19872750?v=4" width="180"></td>
    <td><img src="https://avatars.githubusercontent.com/u/113406379?v=4" width="180"></td>
    <td><img src="https://avatars.githubusercontent.com/u/66719957?v=4" width="180"></td>
    <td><img src="https://avatars.githubusercontent.com/u/51356820?v=4" width="180"></td>
  </tr>
  <tr>
    <td>• 운동추가 View <br> • Localization</td>
    <td>• Tuist 세팅 <br> • 홈 View <br> • 다크모드/라이트모드</td>
    <td>• 나의 운동 리스트, 디테일 View <br> • Alamofire API 연동</td>
    <td>• 마이페이지, 설정 View</td>
  </tr>
</table>
