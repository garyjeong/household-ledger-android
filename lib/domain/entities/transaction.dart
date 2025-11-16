/// Transaction 도메인 엔티티
class Transaction {
  final String id;
  final String type; // EXPENSE, INCOME, TRANSFER
  final String date; // ISO string
  final String amount; // BigInt를 string으로 변환
  final String? categoryId;
  final String? tagId;
  final String? recurringRuleId;
  final String? merchant;
  final String? memo;
  final String createdAt;
  final String updatedAt;
  
  // Relations
  final Category? category;
  final Tag? tag;

  Transaction({
    required this.id,
    required this.type,
    required this.date,
    required this.amount,
    this.categoryId,
    this.tagId,
    this.recurringRuleId,
    this.merchant,
    this.memo,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.tag,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: (json['id'] is int) ? json['id'].toString() : (json['id'] as String),
      type: json['type'] as String,
      date: json['date'] as String,
      amount: (json['amount'] is int) ? json['amount'].toString() : (json['amount'] as String),
      categoryId: json['category_id']?.toString(),
      tagId: json['tag_id']?.toString(),
      recurringRuleId: json['recurring_rule_id']?.toString(),
      merchant: json['merchant'] as String?,
      memo: json['memo'] as String?,
      createdAt: json['created_at'] is DateTime 
          ? (json['created_at'] as DateTime).toIso8601String()
          : (json['created_at'] as String),
      updatedAt: json['updated_at'] is DateTime
          ? (json['updated_at'] as DateTime).toIso8601String()
          : (json['updated_at'] as String),
      category: json['category'] != null ? Category.fromJson(json['category'] as Map<String, dynamic>) : null,
      tag: json['tag'] != null ? Tag.fromJson(json['tag'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'date': date,
      'amount': amount,
      'category_id': categoryId,
      'tag_id': tagId,
      'recurring_rule_id': recurringRuleId,
      'merchant': merchant,
      'memo': memo,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'category': category?.toJson(),
      'tag': tag?.toJson(),
    };
  }
}

/// Category 도메인 엔티티
class Category {
  final String id;
  final String name;
  final String color;
  final String type; // EXPENSE, INCOME, TRANSFER
  final bool isDefault;
  final int? budgetAmount;

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.type,
    required this.isDefault,
    this.budgetAmount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: (json['id'] is int) ? json['id'].toString() : (json['id'] as String),
      name: json['name'] as String,
      color: json['color'] as String? ?? '#9CA3AF',
      type: json['type'] as String,
      isDefault: json['is_default'] as bool? ?? false,
      budgetAmount: json['budget_amount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'type': type,
      'is_default': isDefault,
      'budget_amount': budgetAmount,
    };
  }
}

/// Tag 도메인 엔티티
class Tag {
  final String id;
  final String name;

  Tag({
    required this.id,
    required this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

