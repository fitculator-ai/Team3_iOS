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
정상적으로 완료됐다면 생성된 Fitculator.xcworkspace 실행 후 개발
<br><br>


## Git규칙

### **⛱️ Branch Strategy**

- main: 출시가능한 버전
- develop: 기능의 개발과 테스트를 포함하는 브랜치
- feature: 개발을 진행하는 브랜치

### **🎋 Feature Branch Conventions**

용도와 기능 이름으로 브랜치 이름을 작성한다. 용도는 대문자로 시작하고, 용도와 기능을 슬래시`/`로 구분한다.

- 기능 브랜치: Feature/<기능이름>
- 리팩토링 브랜치: Refactor/<기능이름>
- 테스트 브랜치: Test/<기능이름>
- 리드미 업데이트: README/<수정내용>

### **📝 Commit Message Conventions**

대문자로 시작하고 머릿말과 메시지의 구분은 콜론공백(`:` )으로 한다.

- Feat: 기능관련 commit
- Fix: 버그 수정
- Refactor: 코드 리팩토링
- Style: 로직 변경이 없는 commit (eg. 라인 여백 삭제, 코멘트 추가 혹은 삭제)
- Docs: README와 같은 문서 수정
- Test: 테스트 코드
- Design: 디자인 변경
