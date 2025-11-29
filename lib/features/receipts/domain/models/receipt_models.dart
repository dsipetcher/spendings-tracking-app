import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_models.freezed.dart';
part 'receipt_models.g.dart';

enum MoneyFlowType { expense, income }

@JsonEnum(alwaysCreate: true)
enum SpendingCategory {
  groceries,
  dining,
  transport,
  utilities,
  household,
  entertainment,
  services,
  health,
  salary,
  other,
}

@freezed
class Receipt with _$Receipt {
  @JsonSerializable(explicitToJson: true)
  const factory Receipt({
    required String id,
    required String currency,
    required DateTime createdAt,
    required MoneyFlowType flowType,
    required double total,
    required double subtotal,
    double? tax,
    double? serviceFee,
    double? discount,
    required StoreInfo store,
    required List<LineItem> items,
    String? paymentMethod,
    String? notes,
    @Default(true) bool autoCategorized,
    @Default(false) bool requiresReview,
    @Default(0.85) double confidence,
    String? sourceLanguage,
    String? translatedLanguage,
    String? sourceImagePath,
    String? rawText,
  }) = _Receipt;

  factory Receipt.fromJson(Map<String, dynamic> json) =>
      _$ReceiptFromJson(json);
}

@freezed
class LineItem with _$LineItem {
  const factory LineItem({
    required String id,
    required String name,
    String? translatedName,
    @Default(1) double quantity,
    @Default(0) double unitPrice,
    @Default(SpendingCategory.other) SpendingCategory category,
    @Default(true) bool editable,
    @Default(0.9) double confidence,
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);
}

@freezed
class StoreInfo with _$StoreInfo {
  const factory StoreInfo({
    required String name,
    String? branch,
    String? address,
    GeoPoint? location,
    SpendingCategory? defaultCategory,
    String? city,
    String? country,
  }) = _StoreInfo;

  factory StoreInfo.fromJson(Map<String, dynamic> json) =>
      _$StoreInfoFromJson(json);
}

@freezed
class GeoPoint with _$GeoPoint {
  const factory GeoPoint({
    required double latitude,
    required double longitude,
  }) = _GeoPoint;

  factory GeoPoint.fromJson(Map<String, dynamic> json) =>
      _$GeoPointFromJson(json);
}

@freezed
class ReceiptDraft with _$ReceiptDraft {
  @JsonSerializable(explicitToJson: true)
  const factory ReceiptDraft({
    StoreInfo? store,
    DateTime? createdAt,
    @Default([]) List<LineItem> items,
    @Default('USD') String currency,
    @Default(MoneyFlowType.expense) MoneyFlowType flowType,
    double? subtotal,
    double? tax,
    double? serviceFee,
    double? total,
    String? paymentMethod,
    String? sourceLanguage,
    String? translatedLanguage,
    @Default(false) bool requiresReview,
    String? sourceImagePath,
    String? rawText,
  }) = _ReceiptDraft;

  factory ReceiptDraft.fromJson(Map<String, dynamic> json) =>
      _$ReceiptDraftFromJson(json);
}

extension ReceiptDraftX on ReceiptDraft {
  Receipt finalize({
    required String id,
    bool autoCategorized = true,
    bool requiresReviewOverride = false,
  }) {
    final computedSubtotal = subtotal ??
        items.fold<double>(
            0, (value, item) => value + (item.unitPrice * item.quantity));
    final computedTotal =
        total ?? (computedSubtotal + (tax ?? 0) + (serviceFee ?? 0));
    return Receipt(
      id: id,
      currency: currency,
      createdAt: createdAt ?? DateTime.now(),
      flowType: flowType,
      total: computedTotal,
      subtotal: computedSubtotal,
      tax: tax,
      serviceFee: serviceFee,
      store: store ?? const StoreInfo(name: 'Unknown merchant'),
      items: items,
      paymentMethod: paymentMethod,
      autoCategorized: autoCategorized,
      requiresReview: requiresReviewOverride || requiresReview,
      confidence: items.isEmpty ? 0.5 : 0.85,
      sourceLanguage: sourceLanguage,
      translatedLanguage: translatedLanguage,
      sourceImagePath: sourceImagePath,
      rawText: rawText,
      notes: null,
      discount: null,
    );
  }
}
