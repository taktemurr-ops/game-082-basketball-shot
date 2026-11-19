# Basketball Shot — Game 082

Original offline Flutter/Dart mobile basketball shooting challenge for Android and iOS.

## Gameplay implemented
- Illustrated basketball court, hoop and aiming controls
- Adjustable shot aim/power with deterministic shot evaluation and wind variation
- Ten-shot rounds, perfect-shot bonus, streak bonus, shooting accuracy and replay
- Eight rules-engine unit tests
- GitHub Actions Flutter analyze/test/Android debug APK definition

## Local development
```sh
flutter create --platforms=android,ios .
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

## Delivery status
**Prototype source delivered — not a final A-to-Z game release.**
Passing CI, APK/iOS device validation, production assets, persistent progress, advertising and in-app purchases, signing and store acceptance are not established. See `docs/RELEASE_CHECKLIST.md`.
