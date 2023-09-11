# Moa-app project

비사이드 15기 13팀

## 버전
```sh
flutter channel stable
flutter upgrade
```
## 설치

```sh
flutter pub get
flutter run
```
## 코드 푸시
https://docs.shorebird.dev/

### 설치
```sh
curl --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/shorebirdtech/install/main/install.sh -sSf | bash
```
### 앱 빌드
```sh
shorebird release android
shorebird release ios-alpha
```
### 앱 시작
```sh
shorebird preview
```
### 앱 패치
```sh
shorebird patch android
shorebird patch ios-alpha
```

## freezed 모델 빌드

```sh
dart run build_runner build --delete-conflicting-outputs
```
## riverpod
riverpod 코드 수정시에는 상시 `build_runner` 가 실행되게 `watch` 상태로 두세요
```sh
dart run build_runner watch
```
## 커밋 컨벤션
<img width="762" alt="commit" src="https://github.com/bsideproject/Moa-app/assets/73378472/9c177b86-9fa4-46c8-85a9-a605fa922c61">

## 개발 컨벤션
```sh
https://www.notion.so/bside/FE-Flutter-ce45e42f0602443abde7163a1a06780e?pvs=4
```
