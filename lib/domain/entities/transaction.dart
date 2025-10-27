/// Transaction 도메인 엔티티
class Transaction {
  final String id;
  final String type; // EXPENSE, INCOME, TRANSFER
  final String date; // ISO string
  final String amount; // BigInt를 string으로 변환
  final String? categoryId;
  final String? tagId;
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
    this.merchant,
    this.memo,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.tag,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      type: json['type'] as String,
      date: json['date'] as String,
      amount: json['amount'] as String,
      categoryId: json['category_id'] as String?,
      tagId: json['tag_id'] as String?,
      merchant: json['merchant'] as String?,
      memo: json['memo'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      tag: json['tag'] != null ? Tag.fromJson(json['tag']) : null,
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

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.type,
    required this.isDefault,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String? ?? '#9CA3AF',
      type: json['type'] as String,
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'type': type,
      'is_default': isDefault,
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

