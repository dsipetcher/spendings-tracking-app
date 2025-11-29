# Spendings Tracking MVP

A Flutter-based receipt tracking MVP that demonstrates how a mobile client can:

- Capture receipts from the camera or gallery, run Google ML Kit OCR + translation, and attach
  the source image (optional to save space).
- Autocomplete store metadata, totals, product line items, and categories with manual override.
- Persist the ledger locally via Hive and keep every receipt editable offline.
- Display a dashboard with income vs. expenses, weekly charts, and category highlights.
- Offer a searchable history, transaction details, original-image viewer, and inline editing.

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

### Environment variables

To enable cloud translation fallback (used when ML Kit lacks a language), provide a
[DeepL](https://www.deepl.com/pro-api) API key via Dart define:

```powershell
flutter run --dart-define=DEEPL_API_KEY=your_deepl_key
```

If the key is omitted, the app still works but will skip translation for unsupported languages.

## Feature Highlights

- **Capture → OCR → Translate**: Uses `google_mlkit_text_recognition`, `google_mlkit_language_id`,
  and `google_mlkit_translation` to extract structured text, detect languages, translate line items,
  and auto-categorize them.
- **Local persistence**: Receipts + metadata are stored in a Hive box, so the dashboard and history
  survive restarts without a backend.
- **Manual control**: Users can edit merchants, notes, categories, totals, or disable original image
  storage in Settings to save disk space.
- **Multi-currency view**: Each receipt, history row, and dashboard widget shows the original amount,
  a base currency (USD/EUR selectable) and the user’s personal currency using cached forex rates.
- **Original image audit**: Every saved operation can link back to the captured photo, viewable from
  the receipt detail screen if the feature is enabled.

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
