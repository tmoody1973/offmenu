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
import '../tours/james_beard_distinction.dart' as _i2;

/// James Beard Foundation award record.
abstract class JamesBeardAward
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  JamesBeardAward._({
    this.id,
    required this.name,
    required this.city,
    required this.category,
    required this.distinctionLevel,
    required this.awardYear,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JamesBeardAward({
    int? id,
    required String name,
    required String city,
    required String category,
    required _i2.JamesBeardDistinction distinctionLevel,
    required int awardYear,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _JamesBeardAwardImpl;

  factory JamesBeardAward.fromJson(Map<String, dynamic> jsonSerialization) {
    return JamesBeardAward(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      city: jsonSerialization['city'] as String,
      category: jsonSerialization['category'] as String,
      distinctionLevel: _i2.JamesBeardDistinction.fromJson(
        (jsonSerialization['distinctionLevel'] as String),
      ),
      awardYear: jsonSerialization['awardYear'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = JamesBeardAwardTable();

  static const db = JamesBeardAwardRepository._();

  @override
  int? id;

  /// Name of the chef or restaurant.
  String name;

  /// City where the chef/restaurant is located.
  String city;

  /// Award category (e.g., "Best Chef: Great Lakes", "Outstanding Restaurant").
  String category;

  /// Distinction level of the award.
  _i2.JamesBeardDistinction distinctionLevel;

  /// Year the award was given.
  int awardYear;

  /// When the record was created.
  DateTime createdAt;

  /// When the record was last updated.
  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [JamesBeardAward]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  JamesBeardAward copyWith({
    int? id,
    String? name,
    String? city,
    String? category,
    _i2.JamesBeardDistinction? distinctionLevel,
    int? awardYear,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JamesBeardAward',
      if (id != null) 'id': id,
      'name': name,
      'city': city,
      'category': category,
      'distinctionLevel': distinctionLevel.toJson(),
      'awardYear': awardYear,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JamesBeardAward',
      if (id != null) 'id': id,
      'name': name,
      'city': city,
      'category': category,
      'distinctionLevel': distinctionLevel.toJson(),
      'awardYear': awardYear,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static JamesBeardAwardInclude include() {
    return JamesBeardAwardInclude._();
  }

  static JamesBeardAwardIncludeList includeList({
    _i1.WhereExpressionBuilder<JamesBeardAwardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<JamesBeardAwardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<JamesBeardAwardTable>? orderByList,
    JamesBeardAwardInclude? include,
  }) {
    return JamesBeardAwardIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(JamesBeardAward.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(JamesBeardAward.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JamesBeardAwardImpl extends JamesBeardAward {
  _JamesBeardAwardImpl({
    int? id,
    required String name,
    required String city,
    required String category,
    required _i2.JamesBeardDistinction distinctionLevel,
    required int awardYear,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         name: name,
         city: city,
         category: category,
         distinctionLevel: distinctionLevel,
         awardYear: awardYear,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [JamesBeardAward]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  JamesBeardAward copyWith({
    Object? id = _Undefined,
    String? name,
    String? city,
    String? category,
    _i2.JamesBeardDistinction? distinctionLevel,
    int? awardYear,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JamesBeardAward(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      category: category ?? this.category,
      distinctionLevel: distinctionLevel ?? this.distinctionLevel,
      awardYear: awardYear ?? this.awardYear,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class JamesBeardAwardUpdateTable extends _i1.UpdateTable<JamesBeardAwardTable> {
  JamesBeardAwardUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> city(String value) => _i1.ColumnValue(
    table.city,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<_i2.JamesBeardDistinction, _i2.JamesBeardDistinction>
  distinctionLevel(_i2.JamesBeardDistinction value) => _i1.ColumnValue(
    table.distinctionLevel,
    value,
  );

  _i1.ColumnValue<int, int> awardYear(int value) => _i1.ColumnValue(
    table.awardYear,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class JamesBeardAwardTable extends _i1.Table<int?> {
  JamesBeardAwardTable({super.tableRelation})
    : super(tableName: 'james_beard_awards') {
    updateTable = JamesBeardAwardUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    city = _i1.ColumnString(
      'city',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    distinctionLevel = _i1.ColumnEnum(
      'distinctionLevel',
      this,
      _i1.EnumSerialization.byName,
    );
    awardYear = _i1.ColumnInt(
      'awardYear',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final JamesBeardAwardUpdateTable updateTable;

  /// Name of the chef or restaurant.
  late final _i1.ColumnString name;

  /// City where the chef/restaurant is located.
  late final _i1.ColumnString city;

  /// Award category (e.g., "Best Chef: Great Lakes", "Outstanding Restaurant").
  late final _i1.ColumnString category;

  /// Distinction level of the award.
  late final _i1.ColumnEnum<_i2.JamesBeardDistinction> distinctionLevel;

  /// Year the award was given.
  late final _i1.ColumnInt awardYear;

  /// When the record was created.
  late final _i1.ColumnDateTime createdAt;

  /// When the record was last updated.
  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    city,
    category,
    distinctionLevel,
    awardYear,
    createdAt,
    updatedAt,
  ];
}

class JamesBeardAwardInclude extends _i1.IncludeObject {
  JamesBeardAwardInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => JamesBeardAward.t;
}

class JamesBeardAwardIncludeList extends _i1.IncludeList {
  JamesBeardAwardIncludeList._({
    _i1.WhereExpressionBuilder<JamesBeardAwardTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(JamesBeardAward.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => JamesBeardAward.t;
}

class JamesBeardAwardRepository {
  const JamesBeardAwardRepository._();

  /// Returns a list of [JamesBeardAward]s matching the given query parameters.
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
  Future<List<JamesBeardAward>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<JamesBeardAwardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<JamesBeardAwardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<JamesBeardAwardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<JamesBeardAward>(
      where: where?.call(JamesBeardAward.t),
      orderBy: orderBy?.call(JamesBeardAward.t),
      orderByList: orderByList?.call(JamesBeardAward.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [JamesBeardAward] matching the given query parameters.
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
  Future<JamesBeardAward?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<JamesBeardAwardTable>? where,
    int? offset,
    _i1.OrderByBuilder<JamesBeardAwardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<JamesBeardAwardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<JamesBeardAward>(
      where: where?.call(JamesBeardAward.t),
      orderBy: orderBy?.call(JamesBeardAward.t),
      orderByList: orderByList?.call(JamesBeardAward.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [JamesBeardAward] by its [id] or null if no such row exists.
  Future<JamesBeardAward?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<JamesBeardAward>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [JamesBeardAward]s in the list and returns the inserted rows.
  ///
  /// The returned [JamesBeardAward]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<JamesBeardAward>> insert(
    _i1.Session session,
    List<JamesBeardAward> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<JamesBeardAward>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [JamesBeardAward] and returns the inserted row.
  ///
  /// The returned [JamesBeardAward] will have its `id` field set.
  Future<JamesBeardAward> insertRow(
    _i1.Session session,
    JamesBeardAward row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<JamesBeardAward>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [JamesBeardAward]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<JamesBeardAward>> update(
    _i1.Session session,
    List<JamesBeardAward> rows, {
    _i1.ColumnSelections<JamesBeardAwardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<JamesBeardAward>(
      rows,
      columns: columns?.call(JamesBeardAward.t),
      transaction: transaction,
    );
  }

  /// Updates a single [JamesBeardAward]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<JamesBeardAward> updateRow(
    _i1.Session session,
    JamesBeardAward row, {
    _i1.ColumnSelections<JamesBeardAwardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<JamesBeardAward>(
      row,
      columns: columns?.call(JamesBeardAward.t),
      transaction: transaction,
    );
  }

  /// Updates a single [JamesBeardAward] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<JamesBeardAward?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<JamesBeardAwardUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<JamesBeardAward>(
      id,
      columnValues: columnValues(JamesBeardAward.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [JamesBeardAward]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<JamesBeardAward>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<JamesBeardAwardUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<JamesBeardAwardTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<JamesBeardAwardTable>? orderBy,
    _i1.OrderByListBuilder<JamesBeardAwardTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<JamesBeardAward>(
      columnValues: columnValues(JamesBeardAward.t.updateTable),
      where: where(JamesBeardAward.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(JamesBeardAward.t),
      orderByList: orderByList?.call(JamesBeardAward.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [JamesBeardAward]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<JamesBeardAward>> delete(
    _i1.Session session,
    List<JamesBeardAward> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<JamesBeardAward>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [JamesBeardAward].
  Future<JamesBeardAward> deleteRow(
    _i1.Session session,
    JamesBeardAward row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<JamesBeardAward>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<JamesBeardAward>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<JamesBeardAwardTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<JamesBeardAward>(
      where: where(JamesBeardAward.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<JamesBeardAwardTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<JamesBeardAward>(
      where: where?.call(JamesBeardAward.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
