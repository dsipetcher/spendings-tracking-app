// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Receipt _$ReceiptFromJson(Map<String, dynamic> json) {
  return _Receipt.fromJson(json);
}

/// @nodoc
mixin _$Receipt {
  String get id => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  MoneyFlowType get flowType => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double? get tax => throw _privateConstructorUsedError;
  double? get serviceFee => throw _privateConstructorUsedError;
  double? get discount => throw _privateConstructorUsedError;
  StoreInfo get store => throw _privateConstructorUsedError;
  List<LineItem> get items => throw _privateConstructorUsedError;
  String? get paymentMethod => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get autoCategorized => throw _privateConstructorUsedError;
  bool get requiresReview => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  String? get sourceLanguage => throw _privateConstructorUsedError;
  String? get translatedLanguage => throw _privateConstructorUsedError;

  /// Serializes this Receipt to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReceiptCopyWith<Receipt> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceiptCopyWith<$Res> {
  factory $ReceiptCopyWith(Receipt value, $Res Function(Receipt) then) =
      _$ReceiptCopyWithImpl<$Res, Receipt>;
  @useResult
  $Res call(
      {String id,
      String currency,
      DateTime createdAt,
      MoneyFlowType flowType,
      double total,
      double subtotal,
      double? tax,
      double? serviceFee,
      double? discount,
      StoreInfo store,
      List<LineItem> items,
      String? paymentMethod,
      String? notes,
      bool autoCategorized,
      bool requiresReview,
      double confidence,
      String? sourceLanguage,
      String? translatedLanguage});

  $StoreInfoCopyWith<$Res> get store;
}

/// @nodoc
class _$ReceiptCopyWithImpl<$Res, $Val extends Receipt>
    implements $ReceiptCopyWith<$Res> {
  _$ReceiptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? currency = null,
    Object? createdAt = null,
    Object? flowType = null,
    Object? total = null,
    Object? subtotal = null,
    Object? tax = freezed,
    Object? serviceFee = freezed,
    Object? discount = freezed,
    Object? store = null,
    Object? items = null,
    Object? paymentMethod = freezed,
    Object? notes = freezed,
    Object? autoCategorized = null,
    Object? requiresReview = null,
    Object? confidence = null,
    Object? sourceLanguage = freezed,
    Object? translatedLanguage = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      flowType: null == flowType
          ? _value.flowType
          : flowType // ignore: cast_nullable_to_non_nullable
              as MoneyFlowType,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      tax: freezed == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double?,
      serviceFee: freezed == serviceFee
          ? _value.serviceFee
          : serviceFee // ignore: cast_nullable_to_non_nullable
              as double?,
      discount: freezed == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double?,
      store: null == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as StoreInfo,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<LineItem>,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      autoCategorized: null == autoCategorized
          ? _value.autoCategorized
          : autoCategorized // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresReview: null == requiresReview
          ? _value.requiresReview
          : requiresReview // ignore: cast_nullable_to_non_nullable
              as bool,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      sourceLanguage: freezed == sourceLanguage
          ? _value.sourceLanguage
          : sourceLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      translatedLanguage: freezed == translatedLanguage
          ? _value.translatedLanguage
          : translatedLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StoreInfoCopyWith<$Res> get store {
    return $StoreInfoCopyWith<$Res>(_value.store, (value) {
      return _then(_value.copyWith(store: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReceiptImplCopyWith<$Res> implements $ReceiptCopyWith<$Res> {
  factory _$$ReceiptImplCopyWith(
          _$ReceiptImpl value, $Res Function(_$ReceiptImpl) then) =
      __$$ReceiptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String currency,
      DateTime createdAt,
      MoneyFlowType flowType,
      double total,
      double subtotal,
      double? tax,
      double? serviceFee,
      double? discount,
      StoreInfo store,
      List<LineItem> items,
      String? paymentMethod,
      String? notes,
      bool autoCategorized,
      bool requiresReview,
      double confidence,
      String? sourceLanguage,
      String? translatedLanguage});

  @override
  $StoreInfoCopyWith<$Res> get store;
}

/// @nodoc
class __$$ReceiptImplCopyWithImpl<$Res>
    extends _$ReceiptCopyWithImpl<$Res, _$ReceiptImpl>
    implements _$$ReceiptImplCopyWith<$Res> {
  __$$ReceiptImplCopyWithImpl(
      _$ReceiptImpl _value, $Res Function(_$ReceiptImpl) _then)
      : super(_value, _then);

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? currency = null,
    Object? createdAt = null,
    Object? flowType = null,
    Object? total = null,
    Object? subtotal = null,
    Object? tax = freezed,
    Object? serviceFee = freezed,
    Object? discount = freezed,
    Object? store = null,
    Object? items = null,
    Object? paymentMethod = freezed,
    Object? notes = freezed,
    Object? autoCategorized = null,
    Object? requiresReview = null,
    Object? confidence = null,
    Object? sourceLanguage = freezed,
    Object? translatedLanguage = freezed,
  }) {
    return _then(_$ReceiptImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      flowType: null == flowType
          ? _value.flowType
          : flowType // ignore: cast_nullable_to_non_nullable
              as MoneyFlowType,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      tax: freezed == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double?,
      serviceFee: freezed == serviceFee
          ? _value.serviceFee
          : serviceFee // ignore: cast_nullable_to_non_nullable
              as double?,
      discount: freezed == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double?,
      store: null == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as StoreInfo,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<LineItem>,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      autoCategorized: null == autoCategorized
          ? _value.autoCategorized
          : autoCategorized // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresReview: null == requiresReview
          ? _value.requiresReview
          : requiresReview // ignore: cast_nullable_to_non_nullable
              as bool,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      sourceLanguage: freezed == sourceLanguage
          ? _value.sourceLanguage
          : sourceLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      translatedLanguage: freezed == translatedLanguage
          ? _value.translatedLanguage
          : translatedLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceiptImpl implements _Receipt {
  const _$ReceiptImpl(
      {required this.id,
      required this.currency,
      required this.createdAt,
      required this.flowType,
      required this.total,
      required this.subtotal,
      this.tax,
      this.serviceFee,
      this.discount,
      required this.store,
      required final List<LineItem> items,
      this.paymentMethod,
      this.notes,
      this.autoCategorized = true,
      this.requiresReview = false,
      this.confidence = 0.85,
      this.sourceLanguage,
      this.translatedLanguage})
      : _items = items;

  factory _$ReceiptImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceiptImplFromJson(json);

  @override
  final String id;
  @override
  final String currency;
  @override
  final DateTime createdAt;
  @override
  final MoneyFlowType flowType;
  @override
  final double total;
  @override
  final double subtotal;
  @override
  final double? tax;
  @override
  final double? serviceFee;
  @override
  final double? discount;
  @override
  final StoreInfo store;
  final List<LineItem> _items;
  @override
  List<LineItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? paymentMethod;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool autoCategorized;
  @override
  @JsonKey()
  final bool requiresReview;
  @override
  @JsonKey()
  final double confidence;
  @override
  final String? sourceLanguage;
  @override
  final String? translatedLanguage;

  @override
  String toString() {
    return 'Receipt(id: $id, currency: $currency, createdAt: $createdAt, flowType: $flowType, total: $total, subtotal: $subtotal, tax: $tax, serviceFee: $serviceFee, discount: $discount, store: $store, items: $items, paymentMethod: $paymentMethod, notes: $notes, autoCategorized: $autoCategorized, requiresReview: $requiresReview, confidence: $confidence, sourceLanguage: $sourceLanguage, translatedLanguage: $translatedLanguage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceiptImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.flowType, flowType) ||
                other.flowType == flowType) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.serviceFee, serviceFee) ||
                other.serviceFee == serviceFee) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.store, store) || other.store == store) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.autoCategorized, autoCategorized) ||
                other.autoCategorized == autoCategorized) &&
            (identical(other.requiresReview, requiresReview) ||
                other.requiresReview == requiresReview) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.sourceLanguage, sourceLanguage) ||
                other.sourceLanguage == sourceLanguage) &&
            (identical(other.translatedLanguage, translatedLanguage) ||
                other.translatedLanguage == translatedLanguage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      currency,
      createdAt,
      flowType,
      total,
      subtotal,
      tax,
      serviceFee,
      discount,
      store,
      const DeepCollectionEquality().hash(_items),
      paymentMethod,
      notes,
      autoCategorized,
      requiresReview,
      confidence,
      sourceLanguage,
      translatedLanguage);

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceiptImplCopyWith<_$ReceiptImpl> get copyWith =>
      __$$ReceiptImplCopyWithImpl<_$ReceiptImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceiptImplToJson(
      this,
    );
  }
}

abstract class _Receipt implements Receipt {
  const factory _Receipt(
      {required final String id,
      required final String currency,
      required final DateTime createdAt,
      required final MoneyFlowType flowType,
      required final double total,
      required final double subtotal,
      final double? tax,
      final double? serviceFee,
      final double? discount,
      required final StoreInfo store,
      required final List<LineItem> items,
      final String? paymentMethod,
      final String? notes,
      final bool autoCategorized,
      final bool requiresReview,
      final double confidence,
      final String? sourceLanguage,
      final String? translatedLanguage}) = _$ReceiptImpl;

  factory _Receipt.fromJson(Map<String, dynamic> json) = _$ReceiptImpl.fromJson;

  @override
  String get id;
  @override
  String get currency;
  @override
  DateTime get createdAt;
  @override
  MoneyFlowType get flowType;
  @override
  double get total;
  @override
  double get subtotal;
  @override
  double? get tax;
  @override
  double? get serviceFee;
  @override
  double? get discount;
  @override
  StoreInfo get store;
  @override
  List<LineItem> get items;
  @override
  String? get paymentMethod;
  @override
  String? get notes;
  @override
  bool get autoCategorized;
  @override
  bool get requiresReview;
  @override
  double get confidence;
  @override
  String? get sourceLanguage;
  @override
  String? get translatedLanguage;

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceiptImplCopyWith<_$ReceiptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LineItem _$LineItemFromJson(Map<String, dynamic> json) {
  return _LineItem.fromJson(json);
}

/// @nodoc
mixin _$LineItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get translatedName => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  SpendingCategory get category => throw _privateConstructorUsedError;
  bool get editable => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;

  /// Serializes this LineItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LineItemCopyWith<LineItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LineItemCopyWith<$Res> {
  factory $LineItemCopyWith(LineItem value, $Res Function(LineItem) then) =
      _$LineItemCopyWithImpl<$Res, LineItem>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? translatedName,
      double quantity,
      double unitPrice,
      SpendingCategory category,
      bool editable,
      double confidence});
}

/// @nodoc
class _$LineItemCopyWithImpl<$Res, $Val extends LineItem>
    implements $LineItemCopyWith<$Res> {
  _$LineItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? translatedName = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? category = null,
    Object? editable = null,
    Object? confidence = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      translatedName: freezed == translatedName
          ? _value.translatedName
          : translatedName // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as SpendingCategory,
      editable: null == editable
          ? _value.editable
          : editable // ignore: cast_nullable_to_non_nullable
              as bool,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LineItemImplCopyWith<$Res>
    implements $LineItemCopyWith<$Res> {
  factory _$$LineItemImplCopyWith(
          _$LineItemImpl value, $Res Function(_$LineItemImpl) then) =
      __$$LineItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? translatedName,
      double quantity,
      double unitPrice,
      SpendingCategory category,
      bool editable,
      double confidence});
}

/// @nodoc
class __$$LineItemImplCopyWithImpl<$Res>
    extends _$LineItemCopyWithImpl<$Res, _$LineItemImpl>
    implements _$$LineItemImplCopyWith<$Res> {
  __$$LineItemImplCopyWithImpl(
      _$LineItemImpl _value, $Res Function(_$LineItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of LineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? translatedName = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? category = null,
    Object? editable = null,
    Object? confidence = null,
  }) {
    return _then(_$LineItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      translatedName: freezed == translatedName
          ? _value.translatedName
          : translatedName // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as SpendingCategory,
      editable: null == editable
          ? _value.editable
          : editable // ignore: cast_nullable_to_non_nullable
              as bool,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LineItemImpl implements _LineItem {
  const _$LineItemImpl(
      {required this.id,
      required this.name,
      this.translatedName,
      this.quantity = 1,
      this.unitPrice = 0,
      this.category = SpendingCategory.other,
      this.editable = true,
      this.confidence = 0.9});

  factory _$LineItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$LineItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? translatedName;
  @override
  @JsonKey()
  final double quantity;
  @override
  @JsonKey()
  final double unitPrice;
  @override
  @JsonKey()
  final SpendingCategory category;
  @override
  @JsonKey()
  final bool editable;
  @override
  @JsonKey()
  final double confidence;

  @override
  String toString() {
    return 'LineItem(id: $id, name: $name, translatedName: $translatedName, quantity: $quantity, unitPrice: $unitPrice, category: $category, editable: $editable, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LineItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.translatedName, translatedName) ||
                other.translatedName == translatedName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.editable, editable) ||
                other.editable == editable) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, translatedName,
      quantity, unitPrice, category, editable, confidence);

  /// Create a copy of LineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LineItemImplCopyWith<_$LineItemImpl> get copyWith =>
      __$$LineItemImplCopyWithImpl<_$LineItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LineItemImplToJson(
      this,
    );
  }
}

abstract class _LineItem implements LineItem {
  const factory _LineItem(
      {required final String id,
      required final String name,
      final String? translatedName,
      final double quantity,
      final double unitPrice,
      final SpendingCategory category,
      final bool editable,
      final double confidence}) = _$LineItemImpl;

  factory _LineItem.fromJson(Map<String, dynamic> json) =
      _$LineItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get translatedName;
  @override
  double get quantity;
  @override
  double get unitPrice;
  @override
  SpendingCategory get category;
  @override
  bool get editable;
  @override
  double get confidence;

  /// Create a copy of LineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LineItemImplCopyWith<_$LineItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoreInfo _$StoreInfoFromJson(Map<String, dynamic> json) {
  return _StoreInfo.fromJson(json);
}

/// @nodoc
mixin _$StoreInfo {
  String get name => throw _privateConstructorUsedError;
  String? get branch => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  GeoPoint? get location => throw _privateConstructorUsedError;
  SpendingCategory? get defaultCategory => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;

  /// Serializes this StoreInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreInfoCopyWith<StoreInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreInfoCopyWith<$Res> {
  factory $StoreInfoCopyWith(StoreInfo value, $Res Function(StoreInfo) then) =
      _$StoreInfoCopyWithImpl<$Res, StoreInfo>;
  @useResult
  $Res call(
      {String name,
      String? branch,
      String? address,
      GeoPoint? location,
      SpendingCategory? defaultCategory,
      String? city,
      String? country});

  $GeoPointCopyWith<$Res>? get location;
}

/// @nodoc
class _$StoreInfoCopyWithImpl<$Res, $Val extends StoreInfo>
    implements $StoreInfoCopyWith<$Res> {
  _$StoreInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? branch = freezed,
    Object? address = freezed,
    Object? location = freezed,
    Object? defaultCategory = freezed,
    Object? city = freezed,
    Object? country = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      branch: freezed == branch
          ? _value.branch
          : branch // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as GeoPoint?,
      defaultCategory: freezed == defaultCategory
          ? _value.defaultCategory
          : defaultCategory // ignore: cast_nullable_to_non_nullable
              as SpendingCategory?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of StoreInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoPointCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $GeoPointCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StoreInfoImplCopyWith<$Res>
    implements $StoreInfoCopyWith<$Res> {
  factory _$$StoreInfoImplCopyWith(
          _$StoreInfoImpl value, $Res Function(_$StoreInfoImpl) then) =
      __$$StoreInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String? branch,
      String? address,
      GeoPoint? location,
      SpendingCategory? defaultCategory,
      String? city,
      String? country});

  @override
  $GeoPointCopyWith<$Res>? get location;
}

/// @nodoc
class __$$StoreInfoImplCopyWithImpl<$Res>
    extends _$StoreInfoCopyWithImpl<$Res, _$StoreInfoImpl>
    implements _$$StoreInfoImplCopyWith<$Res> {
  __$$StoreInfoImplCopyWithImpl(
      _$StoreInfoImpl _value, $Res Function(_$StoreInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? branch = freezed,
    Object? address = freezed,
    Object? location = freezed,
    Object? defaultCategory = freezed,
    Object? city = freezed,
    Object? country = freezed,
  }) {
    return _then(_$StoreInfoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      branch: freezed == branch
          ? _value.branch
          : branch // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as GeoPoint?,
      defaultCategory: freezed == defaultCategory
          ? _value.defaultCategory
          : defaultCategory // ignore: cast_nullable_to_non_nullable
              as SpendingCategory?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreInfoImpl implements _StoreInfo {
  const _$StoreInfoImpl(
      {required this.name,
      this.branch,
      this.address,
      this.location,
      this.defaultCategory,
      this.city,
      this.country});

  factory _$StoreInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreInfoImplFromJson(json);

  @override
  final String name;
  @override
  final String? branch;
  @override
  final String? address;
  @override
  final GeoPoint? location;
  @override
  final SpendingCategory? defaultCategory;
  @override
  final String? city;
  @override
  final String? country;

  @override
  String toString() {
    return 'StoreInfo(name: $name, branch: $branch, address: $address, location: $location, defaultCategory: $defaultCategory, city: $city, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreInfoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.branch, branch) || other.branch == branch) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.defaultCategory, defaultCategory) ||
                other.defaultCategory == defaultCategory) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, branch, address, location,
      defaultCategory, city, country);

  /// Create a copy of StoreInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreInfoImplCopyWith<_$StoreInfoImpl> get copyWith =>
      __$$StoreInfoImplCopyWithImpl<_$StoreInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreInfoImplToJson(
      this,
    );
  }
}

abstract class _StoreInfo implements StoreInfo {
  const factory _StoreInfo(
      {required final String name,
      final String? branch,
      final String? address,
      final GeoPoint? location,
      final SpendingCategory? defaultCategory,
      final String? city,
      final String? country}) = _$StoreInfoImpl;

  factory _StoreInfo.fromJson(Map<String, dynamic> json) =
      _$StoreInfoImpl.fromJson;

  @override
  String get name;
  @override
  String? get branch;
  @override
  String? get address;
  @override
  GeoPoint? get location;
  @override
  SpendingCategory? get defaultCategory;
  @override
  String? get city;
  @override
  String? get country;

  /// Create a copy of StoreInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreInfoImplCopyWith<_$StoreInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GeoPoint _$GeoPointFromJson(Map<String, dynamic> json) {
  return _GeoPoint.fromJson(json);
}

/// @nodoc
mixin _$GeoPoint {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  /// Serializes this GeoPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeoPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeoPointCopyWith<GeoPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeoPointCopyWith<$Res> {
  factory $GeoPointCopyWith(GeoPoint value, $Res Function(GeoPoint) then) =
      _$GeoPointCopyWithImpl<$Res, GeoPoint>;
  @useResult
  $Res call({double latitude, double longitude});
}

/// @nodoc
class _$GeoPointCopyWithImpl<$Res, $Val extends GeoPoint>
    implements $GeoPointCopyWith<$Res> {
  _$GeoPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeoPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GeoPointImplCopyWith<$Res>
    implements $GeoPointCopyWith<$Res> {
  factory _$$GeoPointImplCopyWith(
          _$GeoPointImpl value, $Res Function(_$GeoPointImpl) then) =
      __$$GeoPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double latitude, double longitude});
}

/// @nodoc
class __$$GeoPointImplCopyWithImpl<$Res>
    extends _$GeoPointCopyWithImpl<$Res, _$GeoPointImpl>
    implements _$$GeoPointImplCopyWith<$Res> {
  __$$GeoPointImplCopyWithImpl(
      _$GeoPointImpl _value, $Res Function(_$GeoPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of GeoPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$GeoPointImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GeoPointImpl implements _GeoPoint {
  const _$GeoPointImpl({required this.latitude, required this.longitude});

  factory _$GeoPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeoPointImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;

  @override
  String toString() {
    return 'GeoPoint(latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeoPointImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude);

  /// Create a copy of GeoPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeoPointImplCopyWith<_$GeoPointImpl> get copyWith =>
      __$$GeoPointImplCopyWithImpl<_$GeoPointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeoPointImplToJson(
      this,
    );
  }
}

abstract class _GeoPoint implements GeoPoint {
  const factory _GeoPoint(
      {required final double latitude,
      required final double longitude}) = _$GeoPointImpl;

  factory _GeoPoint.fromJson(Map<String, dynamic> json) =
      _$GeoPointImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;

  /// Create a copy of GeoPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeoPointImplCopyWith<_$GeoPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReceiptDraft _$ReceiptDraftFromJson(Map<String, dynamic> json) {
  return _ReceiptDraft.fromJson(json);
}

/// @nodoc
mixin _$ReceiptDraft {
  StoreInfo? get store => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  List<LineItem> get items => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  MoneyFlowType get flowType => throw _privateConstructorUsedError;
  double? get subtotal => throw _privateConstructorUsedError;
  double? get tax => throw _privateConstructorUsedError;
  double? get serviceFee => throw _privateConstructorUsedError;
  double? get total => throw _privateConstructorUsedError;
  String? get paymentMethod => throw _privateConstructorUsedError;
  String? get sourceLanguage => throw _privateConstructorUsedError;
  String? get translatedLanguage => throw _privateConstructorUsedError;
  bool get requiresReview => throw _privateConstructorUsedError;

  /// Serializes this ReceiptDraft to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReceiptDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReceiptDraftCopyWith<ReceiptDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceiptDraftCopyWith<$Res> {
  factory $ReceiptDraftCopyWith(
          ReceiptDraft value, $Res Function(ReceiptDraft) then) =
      _$ReceiptDraftCopyWithImpl<$Res, ReceiptDraft>;
  @useResult
  $Res call(
      {StoreInfo? store,
      DateTime? createdAt,
      List<LineItem> items,
      String currency,
      MoneyFlowType flowType,
      double? subtotal,
      double? tax,
      double? serviceFee,
      double? total,
      String? paymentMethod,
      String? sourceLanguage,
      String? translatedLanguage,
      bool requiresReview});

  $StoreInfoCopyWith<$Res>? get store;
}

/// @nodoc
class _$ReceiptDraftCopyWithImpl<$Res, $Val extends ReceiptDraft>
    implements $ReceiptDraftCopyWith<$Res> {
  _$ReceiptDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReceiptDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? store = freezed,
    Object? createdAt = freezed,
    Object? items = null,
    Object? currency = null,
    Object? flowType = null,
    Object? subtotal = freezed,
    Object? tax = freezed,
    Object? serviceFee = freezed,
    Object? total = freezed,
    Object? paymentMethod = freezed,
    Object? sourceLanguage = freezed,
    Object? translatedLanguage = freezed,
    Object? requiresReview = null,
  }) {
    return _then(_value.copyWith(
      store: freezed == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as StoreInfo?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<LineItem>,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      flowType: null == flowType
          ? _value.flowType
          : flowType // ignore: cast_nullable_to_non_nullable
              as MoneyFlowType,
      subtotal: freezed == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double?,
      tax: freezed == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double?,
      serviceFee: freezed == serviceFee
          ? _value.serviceFee
          : serviceFee // ignore: cast_nullable_to_non_nullable
              as double?,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceLanguage: freezed == sourceLanguage
          ? _value.sourceLanguage
          : sourceLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      translatedLanguage: freezed == translatedLanguage
          ? _value.translatedLanguage
          : translatedLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresReview: null == requiresReview
          ? _value.requiresReview
          : requiresReview // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of ReceiptDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StoreInfoCopyWith<$Res>? get store {
    if (_value.store == null) {
      return null;
    }

    return $StoreInfoCopyWith<$Res>(_value.store!, (value) {
      return _then(_value.copyWith(store: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReceiptDraftImplCopyWith<$Res>
    implements $ReceiptDraftCopyWith<$Res> {
  factory _$$ReceiptDraftImplCopyWith(
          _$ReceiptDraftImpl value, $Res Function(_$ReceiptDraftImpl) then) =
      __$$ReceiptDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {StoreInfo? store,
      DateTime? createdAt,
      List<LineItem> items,
      String currency,
      MoneyFlowType flowType,
      double? subtotal,
      double? tax,
      double? serviceFee,
      double? total,
      String? paymentMethod,
      String? sourceLanguage,
      String? translatedLanguage,
      bool requiresReview});

  @override
  $StoreInfoCopyWith<$Res>? get store;
}

/// @nodoc
class __$$ReceiptDraftImplCopyWithImpl<$Res>
    extends _$ReceiptDraftCopyWithImpl<$Res, _$ReceiptDraftImpl>
    implements _$$ReceiptDraftImplCopyWith<$Res> {
  __$$ReceiptDraftImplCopyWithImpl(
      _$ReceiptDraftImpl _value, $Res Function(_$ReceiptDraftImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReceiptDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? store = freezed,
    Object? createdAt = freezed,
    Object? items = null,
    Object? currency = null,
    Object? flowType = null,
    Object? subtotal = freezed,
    Object? tax = freezed,
    Object? serviceFee = freezed,
    Object? total = freezed,
    Object? paymentMethod = freezed,
    Object? sourceLanguage = freezed,
    Object? translatedLanguage = freezed,
    Object? requiresReview = null,
  }) {
    return _then(_$ReceiptDraftImpl(
      store: freezed == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as StoreInfo?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<LineItem>,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      flowType: null == flowType
          ? _value.flowType
          : flowType // ignore: cast_nullable_to_non_nullable
              as MoneyFlowType,
      subtotal: freezed == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double?,
      tax: freezed == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double?,
      serviceFee: freezed == serviceFee
          ? _value.serviceFee
          : serviceFee // ignore: cast_nullable_to_non_nullable
              as double?,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceLanguage: freezed == sourceLanguage
          ? _value.sourceLanguage
          : sourceLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      translatedLanguage: freezed == translatedLanguage
          ? _value.translatedLanguage
          : translatedLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresReview: null == requiresReview
          ? _value.requiresReview
          : requiresReview // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceiptDraftImpl implements _ReceiptDraft {
  const _$ReceiptDraftImpl(
      {this.store,
      this.createdAt,
      final List<LineItem> items = const [],
      this.currency = 'USD',
      this.flowType = MoneyFlowType.expense,
      this.subtotal,
      this.tax,
      this.serviceFee,
      this.total,
      this.paymentMethod,
      this.sourceLanguage,
      this.translatedLanguage,
      this.requiresReview = false})
      : _items = items;

  factory _$ReceiptDraftImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceiptDraftImplFromJson(json);

  @override
  final StoreInfo? store;
  @override
  final DateTime? createdAt;
  final List<LineItem> _items;
  @override
  @JsonKey()
  List<LineItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey()
  final MoneyFlowType flowType;
  @override
  final double? subtotal;
  @override
  final double? tax;
  @override
  final double? serviceFee;
  @override
  final double? total;
  @override
  final String? paymentMethod;
  @override
  final String? sourceLanguage;
  @override
  final String? translatedLanguage;
  @override
  @JsonKey()
  final bool requiresReview;

  @override
  String toString() {
    return 'ReceiptDraft(store: $store, createdAt: $createdAt, items: $items, currency: $currency, flowType: $flowType, subtotal: $subtotal, tax: $tax, serviceFee: $serviceFee, total: $total, paymentMethod: $paymentMethod, sourceLanguage: $sourceLanguage, translatedLanguage: $translatedLanguage, requiresReview: $requiresReview)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceiptDraftImpl &&
            (identical(other.store, store) || other.store == store) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.flowType, flowType) ||
                other.flowType == flowType) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.serviceFee, serviceFee) ||
                other.serviceFee == serviceFee) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.sourceLanguage, sourceLanguage) ||
                other.sourceLanguage == sourceLanguage) &&
            (identical(other.translatedLanguage, translatedLanguage) ||
                other.translatedLanguage == translatedLanguage) &&
            (identical(other.requiresReview, requiresReview) ||
                other.requiresReview == requiresReview));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      store,
      createdAt,
      const DeepCollectionEquality().hash(_items),
      currency,
      flowType,
      subtotal,
      tax,
      serviceFee,
      total,
      paymentMethod,
      sourceLanguage,
      translatedLanguage,
      requiresReview);

  /// Create a copy of ReceiptDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceiptDraftImplCopyWith<_$ReceiptDraftImpl> get copyWith =>
      __$$ReceiptDraftImplCopyWithImpl<_$ReceiptDraftImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceiptDraftImplToJson(
      this,
    );
  }
}

abstract class _ReceiptDraft implements ReceiptDraft {
  const factory _ReceiptDraft(
      {final StoreInfo? store,
      final DateTime? createdAt,
      final List<LineItem> items,
      final String currency,
      final MoneyFlowType flowType,
      final double? subtotal,
      final double? tax,
      final double? serviceFee,
      final double? total,
      final String? paymentMethod,
      final String? sourceLanguage,
      final String? translatedLanguage,
      final bool requiresReview}) = _$ReceiptDraftImpl;

  factory _ReceiptDraft.fromJson(Map<String, dynamic> json) =
      _$ReceiptDraftImpl.fromJson;

  @override
  StoreInfo? get store;
  @override
  DateTime? get createdAt;
  @override
  List<LineItem> get items;
  @override
  String get currency;
  @override
  MoneyFlowType get flowType;
  @override
  double? get subtotal;
  @override
  double? get tax;
  @override
  double? get serviceFee;
  @override
  double? get total;
  @override
  String? get paymentMethod;
  @override
  String? get sourceLanguage;
  @override
  String? get translatedLanguage;
  @override
  bool get requiresReview;

  /// Create a copy of ReceiptDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceiptDraftImplCopyWith<_$ReceiptDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
