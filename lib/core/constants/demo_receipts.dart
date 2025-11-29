import 'package:uuid/uuid.dart';

import '../../features/receipts/domain/models/receipt_models.dart';

class DemoReceipts {
  static final Uuid _uuid = const Uuid();

  static List<Receipt> get initialPool => [
        _groceries,
        _salary,
        _restaurant,
      ];

  static final Receipt _groceries = Receipt(
    id: _uuid.v4(),
    currency: 'USD',
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    flowType: MoneyFlowType.expense,
    total: 82.45,
    subtotal: 72.45,
    tax: 5.4,
    serviceFee: 1.5,
    store: StoreInfo(
      name: 'GreenMart Superstore',
      address: '221 Baker Street, London',
      city: 'London',
      country: 'UK',
      defaultCategory: SpendingCategory.groceries,
      location: const GeoPoint(latitude: 51.5237, longitude: -0.1585),
    ),
    items: [
      LineItem(
        id: _uuid.v4(),
        name: 'Organic Apples',
        translatedName: 'Органические яблоки',
        quantity: 1,
        unitPrice: 6.5,
        category: SpendingCategory.groceries,
      ),
      LineItem(
        id: _uuid.v4(),
        name: 'Sourdough Bread',
        quantity: 1,
        unitPrice: 4.25,
        category: SpendingCategory.groceries,
      ),
      LineItem(
        id: _uuid.v4(),
        name: 'Arabica Coffee Beans',
        quantity: 1,
        unitPrice: 14,
        category: SpendingCategory.groceries,
      ),
      LineItem(
        id: _uuid.v4(),
        name: 'Eco Dishwasher Tabs',
        quantity: 1,
        unitPrice: 9.8,
        category: SpendingCategory.household,
      ),
      LineItem(
        id: _uuid.v4(),
        name: 'Baby Spinach',
        quantity: 2,
        unitPrice: 3.9,
        category: SpendingCategory.groceries,
      ),
    ],
    paymentMethod: 'Visa • 4021',
    notes: 'Auto-extracted from receipt photo',
    confidence: 0.82,
  );

  static final Receipt _restaurant = Receipt(
    id: _uuid.v4(),
    currency: 'EUR',
    createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    flowType: MoneyFlowType.expense,
    total: 46.8,
    subtotal: 39.0,
    tax: 7.8,
    store: StoreInfo(
      name: 'La Piazza',
      address: 'Via Torino 21, Milan',
      city: 'Milan',
      country: 'Italy',
      defaultCategory: SpendingCategory.dining,
    ),
    items: [
      LineItem(
        id: _uuid.v4(),
        name: 'Margherita Pizza',
        quantity: 1,
        unitPrice: 12,
        category: SpendingCategory.dining,
      ),
      LineItem(
        id: _uuid.v4(),
        name: 'Tiramisu',
        quantity: 2,
        unitPrice: 6.5,
        category: SpendingCategory.dining,
      ),
      LineItem(
        id: _uuid.v4(),
        name: 'Espresso',
        quantity: 2,
        unitPrice: 3,
        category: SpendingCategory.dining,
      ),
    ],
    paymentMethod: 'Mastercard • 9932',
    notes: 'Translated from Italian via on-device MT',
    confidence: 0.77,
    requiresReview: true,
  );

  static final Receipt _salary = Receipt(
    id: _uuid.v4(),
    currency: 'USD',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    flowType: MoneyFlowType.income,
    total: 5200,
    subtotal: 5200,
    store: const StoreInfo(
      name: 'Acme Corp Payroll',
      address: '100 Mission St, San Francisco',
      city: 'San Francisco',
      country: 'USA',
      defaultCategory: SpendingCategory.salary,
    ),
    items: [
      LineItem(
        id: _uuid.v4(),
        name: 'Net salary',
        quantity: 1,
        unitPrice: 5200,
        category: SpendingCategory.salary,
      ),
    ],
    paymentMethod: 'Wire transfer',
    notes: 'Imported via CSV statement',
    confidence: 0.99,
  );
}
