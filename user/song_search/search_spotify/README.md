# search_spotify

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### node.js와 연결해야 하는 이유

+ Flutter Web에서의 보안 문제 (CORS)
Flutter Web에서는 API 요청이 CORS(Cross-Origin Resource Sharing) 정책에 의해 차단될 수 있습니다. 즉, 브라우저가 다른 도메인으로의 요청을 차단할 수 있습니다. Spotify API가 CORS 요청을 허용하지 않으면, 요청이 차단될 수 있습니다.

-> 프록시 서버 사용: CORS 문제를 우회하려면 중간에 프록시 서버를 두고, 이 서버가 Spotify API를 대신 호출하도록 할 수 있습니다. 예를 들어, Node.js나 Django 같은 서버를 구축하여 Flutter Web 애플리케이션이 해당 서버에 요청을 보내고, 서버가 Spotify API에 요청을 전달하는 방식입니다

+ OAuth를 사용하여 Spotify API와 상호작용할 때, Node.js 서버가 중간에서 OAuth 인증을 처리하면 클라이언트 측에서 민감한 인증 정보를 다룰 필요가 없습니다. OAuth 인증 과정에서 필요한 클라이언트 ID, 클라이언트 비밀번호, 리프레시 토큰 등을 서버에서 안전하게 관리할 수 있습니다.

+ Node.js 서버에서 API 요청을 처리함으로써 요청을 집합적으로 관리하고 최적화할 수 있습니다. 예를 들어, 캐싱을 사용하거나 동일한 데이터에 대한 요청을 묶어서 보내는 방식으로 최적화할 수 있습니다.

+ Spotify API에 접근하려면 액세스 토큰이 필요합니다. 이 토큰은 민감한 정보이기 때문에 클라이언트 애플리케이션(예: Flutter 앱)에 직접 노출되는 것은 보안상 위험합니다.

# 설정
pubspec.yaml

```
dependencies:
  flutter:
    sdk: flutter

  http: ^1.2.2

  cupertino_icons: ^1.0.8
```

$ flutter pub get


macos/Runner/DebugProfile.entitlements

```
<key>com.apple.security.network.client</key>
	<true/>
```

$ node index.js

 