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

/// Cached "Three for Tonight" picks for a user.
/// Generated once per day based on user location and preferences.
abstract class TonightPicksCache
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TonightPicksCache._({
    this.id,
    required this.userId,
    required this.cacheDate,
    required this.city,
    this.state,
    required this.mealContext,
    required this.picksJson,
    required this.createdAt,
  });

  factory TonightPicksCache({
    int? id,
    required String userId,
    required String cacheDate,
    required String city,
    String? state,
    required String mealContext,
    required String picksJson,
    required DateTime createdAt,
  }) = _TonightPicksCacheImpl;

  factory TonightPicksCache.fromJson(Map<String, dynamic> jsonSerialization) {
    return TonightPicksCache(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      cacheDate: jsonSerialization['cacheDate'] as String,
      city: jsonSerialization['city'] as String,
      state: jsonSerialization['state'] as String?,
      mealContext: jsonSerialization['mealContext'] as String,
      picksJson: jsonSerialization['picksJson'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = TonightPicksCacheTable();

  static const db = TonightPicksCacheRepository._();

  @override
  int? id;

  /// User ID this cache is for.
  String userId;

  /// Date this cache is for (YYYY-MM-DD format).
  String cacheDate;

  /// City the picks are for.
  String city;

  /// State/region of the city.
  String? state;

  /// Meal context (breakfast, lunch, dinner, etc).
  String mealContext;

  /// JSON-encoded list of TonightPick objects.
  String picksJson;

  /// When this cache was created.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TonightPicksCache]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TonightPicksCache copyWith({
    int? id,
    String? userId,
    String? cacheDate,
    String? city,
    String? state,
    String? mealContext,
    String? picksJson,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TonightPicksCache',
      if (id != null) 'id': id,
      'userId': userId,
      'cacheDate': cacheDate,
      'city': city,
      if (state != null) 'state': state,
      'mealContext': mealContext,
      'picksJson': picksJson,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TonightPicksCache',
      if (id != null) 'id': id,
      'userId': userId,
      'cacheDate': cacheDate,
      'city': city,
      if (state != null) 'state': state,
      'mealContext': mealContext,
      'picksJson': picksJson,
      'createdAt': createdAt.toJson(),
    };
  }

  static TonightPicksCacheInclude include() {
    return TonightPicksCacheInclude._();
  }

  static TonightPicksCacheIncludeList includeList({
    _i1.WhereExpressionBuilder<TonightPicksCacheTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TonightPicksCacheTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TonightPicksCacheTable>? orderByList,
    TonightPicksCacheInclude? include,
  }) {
    return TonightPicksCacheIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TonightPicksCache.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TonightPicksCache.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TonightPicksCacheImpl extends TonightPicksCache {
  _TonightPicksCacheImpl({
    int? id,
    required String userId,
    required String cacheDate,
    required String city,
    String? state,
    required String mealContext,
    required String picksJson,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         cacheDate: cacheDate,
         city: city,
         state: state,
         mealContext: mealContext,
         picksJson: picksJson,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TonightPicksCache]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TonightPicksCache copyWith({
    Object? id = _Undefined,
    String? userId,
    String? cacheDate,
    String? city,
    Object? state = _Undefined,
    String? mealContext,
    String? picksJson,
    DateTime? createdAt,
  }) {
    return TonightPicksCache(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      cacheDate: cacheDate ?? this.cacheDate,
      city: city ?? this.city,
      state: state is String? ? state : this.state,
      mealContext: mealContext ?? this.mealContext,
      picksJson: picksJson ?? this.picksJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TonightPicksCacheUpdateTable
    extends _i1.UpdateTable<TonightPicksCacheTable> {
  TonightPicksCacheUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> cacheDate(String value) => _i1.ColumnValue(
    table.cacheDate,
    value,
  );

  _i1.ColumnValue<String, String> city(String value) => _i1.ColumnValue(
    table.city,
    value,
  );

  _i1.ColumnValue<String, String> state(String? value) => _i1.ColumnValue(
    table.state,
    value,
  );

  _i1.ColumnValue<String, String> mealContext(String value) => _i1.ColumnValue(
    table.mealContext,
    value,
  );

  _i1.ColumnValue<String, String> picksJson(String value) => _i1.ColumnValue(
    table.picksJson,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class TonightPicksCacheTable extends _i1.Table<int?> {
  TonightPicksCacheTable({super.tableRelation})
    : super(tableName: 'tonight_picks_cache') {
    updateTable = TonightPicksCacheUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    cacheDate = _i1.ColumnString(
      'cacheDate',
      this,
    );
    city = _i1.ColumnString(
      'city',
      this,
    );
    state = _i1.ColumnString(
      'state',
      this,
    );
    mealContext = _i1.ColumnString(
      'mealContext',
      this,
    );
    picksJson = _i1.ColumnString(
      'picksJson',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final TonightPicksCacheUpdateTable updateTable;

  /// User ID this cache is for.
  late final _i1.ColumnString userId;

  /// Date this cache is for (YYYY-MM-DD format).
  late final _i1.ColumnString cacheDate;

  /// City the picks are for.
  late final _i1.ColumnString city;

  /// State/region of the city.
  late final _i1.ColumnString state;

  /// Meal context (breakfast, lunch, dinner, etc).
  late final _i1.ColumnString mealContext;

  /// JSON-encoded list of TonightPick objects.
  late final _i1.ColumnString picksJson;

  /// When this cache was created.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    cacheDate,
    city,
    state,
    mealContext,
    picksJson,
    createdAt,
  ];
}

class TonightPicksCacheInclude extends _i1.IncludeObject {
  TonightPicksCacheInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TonightPicksCache.t;
}

class TonightPicksCacheIncludeList extends _i1.IncludeList {
  TonightPicksCacheIncludeList._({
    _i1.WhereExpressionBuilder<TonightPicksCacheTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TonightPicksCache.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TonightPicksCache.t;
}

class TonightPicksCacheRepository {
  const TonightPicksCacheRepository._();

  /// Returns a list of [TonightPicksCache]s matching the given query parameters.
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
  Future<List<TonightPicksCache>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TonightPicksCacheTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TonightPicksCacheTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TonightPicksCacheTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<TonightPicksCache>(
      where: where?.call(TonightPicksCache.t),
      orderBy: orderBy?.call(TonightPicksCache.t),
      orderByList: orderByList?.call(TonightPicksCache.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TonightPicksCache] matching the given query parameters.
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
  Future<TonightPicksCache?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TonightPicksCacheTable>? where,
    int? offset,
    _i1.OrderByBuilder<TonightPicksCacheTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TonightPicksCacheTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TonightPicksCache>(
      where: where?.call(TonightPicksCache.t),
      orderBy: orderBy?.call(TonightPicksCache.t),
      orderByList: orderByList?.call(TonightPicksCache.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TonightPicksCache] by its [id] or null if no such row exists.
  Future<TonightPicksCache?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<TonightPicksCache>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TonightPicksCache]s in the list and returns the inserted rows.
  ///
  /// The returned [TonightPicksCache]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TonightPicksCache>> insert(
    _i1.Session session,
    List<TonightPicksCache> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TonightPicksCache>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TonightPicksCache] and returns the inserted row.
  ///
  /// The returned [TonightPicksCache] will have its `id` field set.
  Future<TonightPicksCache> insertRow(
    _i1.Session session,
    TonightPicksCache row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TonightPicksCache>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TonightPicksCache]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TonightPicksCache>> update(
    _i1.Session session,
    List<TonightPicksCache> rows, {
    _i1.ColumnSelections<TonightPicksCacheTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TonightPicksCache>(
      rows,
      columns: columns?.call(TonightPicksCache.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TonightPicksCache]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TonightPicksCache> updateRow(
    _i1.Session session,
    TonightPicksCache row, {
    _i1.ColumnSelections<TonightPicksCacheTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TonightPicksCache>(
      row,
      columns: columns?.call(TonightPicksCache.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TonightPicksCache] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TonightPicksCache?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TonightPicksCacheUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TonightPicksCache>(
      id,
      columnValues: columnValues(TonightPicksCache.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TonightPicksCache]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TonightPicksCache>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TonightPicksCacheUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<TonightPicksCacheTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TonightPicksCacheTable>? orderBy,
    _i1.OrderByListBuilder<TonightPicksCacheTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TonightPicksCache>(
      columnValues: columnValues(TonightPicksCache.t.updateTable),
      where: where(TonightPicksCache.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TonightPicksCache.t),
      orderByList: orderByList?.call(TonightPicksCache.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TonightPicksCache]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TonightPicksCache>> delete(
    _i1.Session session,
    List<TonightPicksCache> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TonightPicksCache>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TonightPicksCache].
  Future<TonightPicksCache> deleteRow(
    _i1.Session session,
    TonightPicksCache row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TonightPicksCache>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TonightPicksCache>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TonightPicksCacheTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TonightPicksCache>(
      where: where(TonightPicksCache.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TonightPicksCacheTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TonightPicksCache>(
      where: where?.call(TonightPicksCache.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
