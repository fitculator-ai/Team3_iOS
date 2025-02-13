# Team4_iOS
## Tuist 프로젝트 설정 방법

### 1️⃣ 프로젝트 클론
```
git clone https://github.com/fitculator-ai/Team4_iOS.git
cd Team4_iOS
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
정상적으로 완료됐다면 생성된 fitculator.xcworkspace 실행 후 개발
