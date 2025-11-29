# Spendings Tracking MVP

A Flutter-based receipt tracking MVP that demonstrates how a mobile client can:

- Capture receipts from the camera or gallery and run OCR/translation pipelines.
- Autocomplete store metadata, totals, product line items, and categories with manual override.
- Display a dashboard with income vs. expenses, weekly charts, and category highlights.
- Offer a searchable history, transaction details, and inline editing.

> **Note:** OCR + translation are mocked via `assets/demo/sample_receipt.json`, but the service layer is structured so Google ML Kit / cloud APIs can be plugged in later.

## Project Structure

- `lib/core` – app theme, constants, utilities.
- `lib/features/dashboard` – analytics view with charts (`fl_chart`).
- `lib/features/receipts` – models (`freezed`), Riverpod controller, list/detail UIs.
- `lib/features/capture` – capture flow UI + state machine.
- `lib/services/capture` – OCR/translation/category orchestrator with a mock engine.
- `assets/demo` – sample receipt payload used for demo scans.

## Running the app

```powershell
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run -d <device_id>
```

Ensure Android/iOS toolchains are installed (`flutter doctor`). On Windows, Developer Mode must be enabled for plugin symlinks.

## Key Packages

- `flutter_riverpod` – state management.
- `freezed` / `json_serializable` – immutable models and serialization.
- `go_router` (optional) – simple navigation placeholders.
- `fl_chart`, `intl`, `uuid`, `google_mlkit_*`, `image_picker`, `camera`.

## Next Steps

1. Replace `MockReceiptOcrEngine` with actual Google ML Kit OCR/translation or cloud APIs.
2. Persist receipts locally (e.g., `floor`/`isar`) and sync with a backend.
3. Implement real-time model retraining from manual edits.
4. Add authentication plus cloud storage for receipt images.
