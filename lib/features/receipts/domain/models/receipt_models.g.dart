// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReceiptImpl _$$ReceiptImplFromJson(Map<String, dynamic> json) =>
    _$ReceiptImpl(
      id: json['id'] as String,
      currency: json['currency'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      flowType: $enumDecode(_$MoneyFlowTypeEnumMap, json['flowType']),
      total: (json['total'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      serviceFee: (json['serviceFee'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      store: StoreInfo.fromJson(json['store'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((e) => LineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMethod: json['paymentMethod'] as String?,
      notes: json['notes'] as String?,
      autoCategorized: json['autoCategorized'] as bool? ?? true,
      requiresReview: json['requiresReview'] as bool? ?? false,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.85,
      sourceLanguage: json['sourceLanguage'] as String?,
      translatedLanguage: json['translatedLanguage'] as String?,
      sourceImagePath: json['sourceImagePath'] as String?,
      rawText: json['rawText'] as String?,
    );

Map<String, dynamic> _$$ReceiptImplToJson(_$ReceiptImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'currency': instance.currency,
      'createdAt': instance.createdAt.toIso8601String(),
      'flowType': _$MoneyFlowTypeEnumMap[instance.flowType]!,
      'total': instance.total,
      'subtotal': instance.subtotal,
      'tax': instance.tax,
      'serviceFee': instance.serviceFee,
      'discount': instance.discount,
      'store': instance.store.toJson(),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'paymentMethod': instance.paymentMethod,
      'notes': instance.notes,
      'autoCategorized': instance.autoCategorized,
      'requiresReview': instance.requiresReview,
      'confidence': instance.confidence,
      'sourceLanguage': instance.sourceLanguage,
      'translatedLanguage': instance.translatedLanguage,
      'sourceImagePath': instance.sourceImagePath,
      'rawText': instance.rawText,
    };

const _$MoneyFlowTypeEnumMap = {
  MoneyFlowType.expense: 'expense',
  MoneyFlowType.income: 'income',
};

_$LineItemImpl _$$LineItemImplFromJson(Map<String, dynamic> json) =>
    _$LineItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      translatedName: json['translatedName'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
      category:
          $enumDecodeNullable(_$SpendingCategoryEnumMap, json['category']) ??
              SpendingCategory.other,
      editable: json['editable'] as bool? ?? true,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.9,
    );

Map<String, dynamic> _$$LineItemImplToJson(_$LineItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'translatedName': instance.translatedName,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'category': _$SpendingCategoryEnumMap[instance.category]!,
      'editable': instance.editable,
      'confidence': instance.confidence,
    };

const _$SpendingCategoryEnumMap = {
  SpendingCategory.groceries: 'groceries',
  SpendingCategory.dining: 'dining',
  SpendingCategory.transport: 'transport',
  SpendingCategory.utilities: 'utilities',
  SpendingCategory.household: 'household',
  SpendingCategory.entertainment: 'entertainment',
  SpendingCategory.services: 'services',
  SpendingCategory.health: 'health',
  SpendingCategory.salary: 'salary',
  SpendingCategory.other: 'other',
};

_$StoreInfoImpl _$$StoreInfoImplFromJson(Map<String, dynamic> json) =>
    _$StoreInfoImpl(
      name: json['name'] as String,
      branch: json['branch'] as String?,
      address: json['address'] as String?,
      location: json['location'] == null
          ? null
          : GeoPoint.fromJson(json['location'] as Map<String, dynamic>),
      defaultCategory: $enumDecodeNullable(
          _$SpendingCategoryEnumMap, json['defaultCategory']),
      city: json['city'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$$StoreInfoImplToJson(_$StoreInfoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'branch': instance.branch,
      'address': instance.address,
      'location': instance.location,
      'defaultCategory': _$SpendingCategoryEnumMap[instance.defaultCategory],
      'city': instance.city,
      'country': instance.country,
    };

_$GeoPointImpl _$$GeoPointImplFromJson(Map<String, dynamic> json) =>
    _$GeoPointImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$$GeoPointImplToJson(_$GeoPointImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_$ReceiptDraftImpl _$$ReceiptDraftImplFromJson(Map<String, dynamic> json) =>
    _$ReceiptDraftImpl(
      store: json['store'] == null
          ? null
          : StoreInfo.fromJson(json['store'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => LineItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currency: json['currency'] as String? ?? 'USD',
      flowType: $enumDecodeNullable(_$MoneyFlowTypeEnumMap, json['flowType']) ??
          MoneyFlowType.expense,
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      serviceFee: (json['serviceFee'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      paymentMethod: json['paymentMethod'] as String?,
      sourceLanguage: json['sourceLanguage'] as String?,
      translatedLanguage: json['translatedLanguage'] as String?,
      requiresReview: json['requiresReview'] as bool? ?? false,
      sourceImagePath: json['sourceImagePath'] as String?,
      rawText: json['rawText'] as String?,
    );

Map<String, dynamic> _$$ReceiptDraftImplToJson(_$ReceiptDraftImpl instance) =>
    <String, dynamic>{
      'store': instance.store?.toJson(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'currency': instance.currency,
      'flowType': _$MoneyFlowTypeEnumMap[instance.flowType]!,
      'subtotal': instance.subtotal,
      'tax': instance.tax,
      'serviceFee': instance.serviceFee,
      'total': instance.total,
      'paymentMethod': instance.paymentMethod,
      'sourceLanguage': instance.sourceLanguage,
      'translatedLanguage': instance.translatedLanguage,
      'requiresReview': instance.requiresReview,
      'sourceImagePath': instance.sourceImagePath,
      'rawText': instance.rawText,
    };
