# SomeVehicle

### 기능 소개
- 디바이스의 현재 위치를 표시
- 특정 위치를 지정된 이미지의 Annotation(핀)으로 표시
- Annotation을 탭하면 가까이 이동 후 car list 표시
  - 차종별 묶음 표현
- 즐겨찾는 존 저장 가능
  - 셀을 클릭 시 이동 후 car list 표시
  - 앱 종료 후에도 즐겨찾기 유지

### 준비
- [json-server](https://github.com/typicode/json-server)를 이용하여 rest API를 구현합니다.
  - Terminal에서 `npm install -g json-server`를 입력하여 json-server 설치 후,
  - 프로젝트의 경로에서 `json-server --watch db.json`를 입력하여 실행합니다.
  - `control(^) + c`로 종료할 수 있습니다.
  - 이 과정을 진행하지 않을 경우 앱이 정상적으로 동작하지 않습니다.
  
### Simulator의 좌표설정 방법
- 강남역의 좌표
  - latitude: 37.4979126
  - longitude: 127.0276946

![image](https://user-images.githubusercontent.com/69476598/172532123-45a93b93-2e79-4dc5-8216-ba299bb33f10.png)
