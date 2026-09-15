# Merope Ads SDK

A modular and reusable advertising SDK for Flutter applications. This package allows you to easily integrate advertising from various providers (Internal, Google AdMob, Meta Ads) using a unified API.

## Installation

### Local Path
Add this to your `pubspec.yaml`:

```yaml
dependencies:
  merope_ads:
    path: ../path/to/merope_ads
```

### Git
Add this to your `pubspec.yaml`:

```yaml
dependencies:
  merope_ads:
    git:
      url: https://github.com/yourusername/merope_ads.git
      ref: main
```

## Usage

### 1. Initialize the SDK

In your `main.dart`:

```dart
import 'package:merope_ads/merope_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MeropeAds().initialize(
    InternalAdProvider(baseUrl: 'https://your-ads-backend.com'),
  );

  runApp(MyApp());
}
```

### 2. Display a Banner Ad

```dart
import 'package:merope_ads/merope_ads.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Center(child: Text('Content'))),
          MeropeBannerAd(
            adUnit: AdUnit(id: 'home_banner', type: AdType.banner),
          ),
        ],
      ),
    );
  }
}
```

## Creating Custom Providers

You can create your own providers by extending the `AdProvider` class:

```dart
class MyCustomProvider extends AdProvider {
  // Implement required methods
}
```
