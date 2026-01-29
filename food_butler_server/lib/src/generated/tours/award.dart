/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../tours/award_type.dart' as _i2;

/// Culinary award record for James Beard and Michelin designations.
abstract class Award implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Award._({
    this.id,
    required this.restaurantFsqId,
    required this.awardType,
    required this.awardLevel,
    required this.year,
    required this.createdAt,
  });

  factory Award({
    int? id,
    required String restaurantFsqId,
    required _i2.AwardType awardType,
    required String awardLevel,
    required int year,
    required DateTime createdAt,
  }) = _AwardImpl;

  factory Award.fromJson(Map<String, dynamic> jsonSerialization) {
    return Award(
      id: jsonSerialization['id'] as int?,
      restaurantFsqId: jsonSerialization['restaurantFsqId'] as String,
      awardType: _i2.AwardType.fromJson(
        (jsonSerialization['awardType'] as String),
      ),
      awardLevel: jsonSerialization['awardLevel'] as String,
      year: jsonSerialization['year'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AwardTable();

  static const db = AwardRepository._();

  @override
  int? id;

  /// Reference to the restaurant's Foursquare ID.
  String restaurantFsqId;

  /// Type of award (James Beard or Michelin).
  _i2.AwardType awardType;

  /// Award level (winner, nominee, semifinalist, oneStar, twoStar, threeStar, bibGourmand).
  String awardLevel;

  /// Year the award was given.
  int year;

  /// When the record was created.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Award]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Award copyWith({
    int? id,
    String? restaurantFsqId,
    _i2.AwardType? awardType,
    String? awardLevel,
    int? year,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Award',
      if (id != null) 'id': id,
      'restaurantFsqId': restaurantFsqId,
      'awardType': awardType.toJson(),
      'awardLevel': awardLevel,
      'year': year,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Award',
      if (id != null) 'id': id,
      'restaurantFsqId': restaurantFsqId,
      'awardType': awardType.toJson(),
      'awardLevel': awardLevel,
      'year': year,
      'createdAt': createdAt.toJson(),
    };
  }

  static AwardInclude include() {
    return AwardInclude._();
  }

  static AwardIncludeList includeList({
    _i1.WhereExpressionBuilder<AwardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AwardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AwardTable>? orderByList,
    AwardInclude? include,
  }) {
    return AwardIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Award.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Award.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AwardImpl extends Award {
  _AwardImpl({
    int? id,
    required String restaurantFsqId,
    required _i2.AwardType awardType,
    required String awardLevel,
    required int year,
    required DateTime createdAt,
  }) : super._(
         id: id,
         restaurantFsqId: restaurantFsqId,
         awardType: awardType,
         awardLevel: awardLevel,
         year: year,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Award]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Award copyWith({
    Object? id = _Undefined,
    String? restaurantFsqId,
    _i2.AwardType? awardType,
    String? awardLevel,
    int? year,
    DateTime? createdAt,
  }) {
    return Award(
      id: id is int? ? id : this.id,
      restaurantFsqId: restaurantFsqId ?? this.restaurantFsqId,
      awardType: awardType ?? this.awardType,
      awardLevel: awardLevel ?? this.awardLevel,
      year: year ?? this.year,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AwardUpdateTable extends _i1.UpdateTable<AwardTable> {
  AwardUpdateTable(super.table);

  _i1.ColumnValue<String, String> restaurantFsqId(String value) =>
      _i1.ColumnValue(
        table.restaurantFsqId,
        value,
      );

  _i1.ColumnValue<_i2.AwardType, _i2.AwardType> awardType(
    _i2.AwardType value,
  ) => _i1.ColumnValue(
    table.awardType,
    value,
  );

  _i1.ColumnValue<String, String> awardLevel(String value) => _i1.ColumnValue(
    table.awardLevel,
    value,
  );

  _i1.ColumnValue<int, int> year(int value) => _i1.ColumnValue(
    table.year,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AwardTable extends _i1.Table<int?> {
  AwardTable({super.tableRelation}) : super(tableName: 'awards') {
    updateTable = AwardUpdateTable(this);
    restaurantFsqId = _i1.ColumnString(
      'restaurantFsqId',
      this,
    );
    awardType = _i1.ColumnEnum(
      'awardType',
      this,
      _i1.EnumSerialization.byName,
    );
    awardLevel = _i1.ColumnString(
      'awardLevel',
      this,
    );
    year = _i1.ColumnInt(
      'year',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AwardUpdateTable updateTable;

  /// Reference to the restaurant's Foursquare ID.
  late final _i1.ColumnString restaurantFsqId;

  /// Type of award (James Beard or Michelin).
  late final _i1.ColumnEnum<_i2.AwardType> awardType;

  /// Award level (winner, nominee, semifinalist, oneStar, twoStar, threeStar, bibGourmand).
  late final _i1.ColumnString awardLevel;

  /// Year the award was given.
  late final _i1.ColumnInt year;

  /// When the record was created.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    restaurantFsqId,
    awardType,
    awardLevel,
    year,
    createdAt,
  ];
}

class AwardInclude extends _i1.IncludeObject {
  AwardInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Award.t;
}

class AwardIncludeList extends _i1.IncludeList {
  AwardIncludeList._({
    _i1.WhereExpressionBuilder<AwardTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Award.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Award.t;
}

class AwardRepository {
  const AwardRepository._();

  /// Returns a list of [Award]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Award>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AwardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AwardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AwardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Award>(
      where: where?.call(Award.t),
      orderBy: orderBy?.call(Award.t),
      orderByList: orderByList?.call(Award.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Award] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Award?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AwardTable>? where,
    int? offset,
    _i1.OrderByBuilder<AwardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AwardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Award>(
      where: where?.call(Award.t),
      orderBy: orderBy?.call(Award.t),
      orderByList: orderByList?.call(Award.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Award] by its [id] or null if no such row exists.
  Future<Award?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Award>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Award]s in the list and returns the inserted rows.
  ///
  /// The returned [Award]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Award>> insert(
    _i1.Session session,
    List<Award> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Award>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Award] and returns the inserted row.
  ///
  /// The returned [Award] will have its `id` field set.
  Future<Award> insertRow(
    _i1.Session session,
    Award row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Award>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Award]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Award>> update(
    _i1.Session session,
    List<Award> rows, {
    _i1.ColumnSelections<AwardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Award>(
      rows,
      columns: columns?.call(Award.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Award]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Award> updateRow(
    _i1.Session session,
    Award row, {
    _i1.ColumnSelections<AwardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Award>(
      row,
      columns: columns?.call(Award.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Award] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Award?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AwardUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Award>(
      id,
      columnValues: columnValues(Award.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Award]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Award>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AwardUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AwardTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AwardTable>? orderBy,
    _i1.OrderByListBuilder<AwardTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Award>(
      columnValues: columnValues(Award.t.updateTable),
      where: where(Award.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Award.t),
      orderByList: orderByList?.call(Award.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Award]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Award>> delete(
    _i1.Session session,
    List<Award> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Award>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Award].
  Future<Award> deleteRow(
    _i1.Session session,
    Award row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Award>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Award>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AwardTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Award>(
      where: where(Award.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AwardTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Award>(
      where: where?.call(Award.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
