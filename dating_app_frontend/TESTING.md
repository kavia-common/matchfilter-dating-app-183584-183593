# Testing Guide

This project includes:
- Unit tests (e.g., repository logic)
- Widget tests (e.g., Filters UI rendering and interactions)
- Integration tests (end-to-end flows with `integration_test` harness)

Prerequisites:
- Flutter SDK installed
- Run `flutter pub get` at the project root

Run unit and widget tests:
- flutter test --no-pub

Run integration tests:
- flutter test integration_test --no-pub

CI-friendly:
- Use the `--no-pub` flag if `pub get` is already run in a previous step.
- Ensure any device/emulator is not required; these tests use the integration_test binding with `flutter test`.
