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

/// Cached Foursquare API response for reducing API calls.
abstract class CachedFoursquareResponse
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CachedFoursquareResponse._({
    this.id,
    required this.cacheKey,
    required this.responseData,
    required this.expiresAt,
    required this.createdAt,
  });

  factory CachedFoursquareResponse({
    int? id,
    required String cacheKey,
    required String responseData,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _CachedFoursquareResponseImpl;

  factory CachedFoursquareResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CachedFoursquareResponse(
      id: jsonSerialization['id'] as int?,
      cacheKey: jsonSerialization['cacheKey'] as String,
      responseData: jsonSerialization['responseData'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = CachedFoursquareResponseTable();

  static const db = CachedFoursquareResponseRepository._();

  @override
  int? id;

  /// Unique cache key generated from query parameters.
  String cacheKey;

  /// Raw response data as JSON string.
  String responseData;

  /// When the cache entry expires.
  DateTime expiresAt;

  /// When the cache entry was created.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CachedFoursquareResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CachedFoursquareResponse copyWith({
    int? id,
    String? cacheKey,
    String? responseData,
    DateTime? expiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CachedFoursquareResponse',
      if (id != null) 'id': id,
      'cacheKey': cacheKey,
      'responseData': responseData,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CachedFoursquareResponse',
      if (id != null) 'id': id,
      'cacheKey': cacheKey,
      'responseData': responseData,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static CachedFoursquareResponseInclude include() {
    return CachedFoursquareResponseInclude._();
  }

  static CachedFoursquareResponseIncludeList includeList({
    _i1.WhereExpressionBuilder<CachedFoursquareResponseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CachedFoursquareResponseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CachedFoursquareResponseTable>? orderByList,
    CachedFoursquareResponseInclude? include,
  }) {
    return CachedFoursquareResponseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CachedFoursquareResponse.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CachedFoursquareResponse.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CachedFoursquareResponseImpl extends CachedFoursquareResponse {
  _CachedFoursquareResponseImpl({
    int? id,
    required String cacheKey,
    required String responseData,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         cacheKey: cacheKey,
         responseData: responseData,
         expiresAt: expiresAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CachedFoursquareResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CachedFoursquareResponse copyWith({
    Object? id = _Undefined,
    String? cacheKey,
    String? responseData,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return CachedFoursquareResponse(
      id: id is int? ? id : this.id,
      cacheKey: cacheKey ?? this.cacheKey,
      responseData: responseData ?? this.responseData,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CachedFoursquareResponseUpdateTable
    extends _i1.UpdateTable<CachedFoursquareResponseTable> {
  CachedFoursquareResponseUpdateTable(super.table);

  _i1.ColumnValue<String, String> cacheKey(String value) => _i1.ColumnValue(
    table.cacheKey,
    value,
  );

  _i1.ColumnValue<String, String> responseData(String value) => _i1.ColumnValue(
    table.responseData,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class CachedFoursquareResponseTable extends _i1.Table<int?> {
  CachedFoursquareResponseTable({super.tableRelation})
    : super(tableName: 'cached_foursquare_responses') {
    updateTable = CachedFoursquareResponseUpdateTable(this);
    cacheKey = _i1.ColumnString(
      'cacheKey',
      this,
    );
    responseData = _i1.ColumnString(
      'responseData',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final CachedFoursquareResponseUpdateTable updateTable;

  /// Unique cache key generated from query parameters.
  late final _i1.ColumnString cacheKey;

  /// Raw response data as JSON string.
  late final _i1.ColumnString responseData;

  /// When the cache entry expires.
  late final _i1.ColumnDateTime expiresAt;

  /// When the cache entry was created.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    cacheKey,
    responseData,
    expiresAt,
    createdAt,
  ];
}

class CachedFoursquareResponseInclude extends _i1.IncludeObject {
  CachedFoursquareResponseInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CachedFoursquareResponse.t;
}

class CachedFoursquareResponseIncludeList extends _i1.IncludeList {
  CachedFoursquareResponseIncludeList._({
    _i1.WhereExpressionBuilder<CachedFoursquareResponseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CachedFoursquareResponse.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CachedFoursquareResponse.t;
}

class CachedFoursquareResponseRepository {
  const CachedFoursquareResponseRepository._();

  /// Returns a list of [CachedFoursquareResponse]s matching the given query parameters.
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
  Future<List<CachedFoursquareResponse>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CachedFoursquareResponseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CachedFoursquareResponseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CachedFoursquareResponseTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CachedFoursquareResponse>(
      where: where?.call(CachedFoursquareResponse.t),
      orderBy: orderBy?.call(CachedFoursquareResponse.t),
      orderByList: orderByList?.call(CachedFoursquareResponse.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CachedFoursquareResponse] matching the given query parameters.
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
  Future<CachedFoursquareResponse?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CachedFoursquareResponseTable>? where,
    int? offset,
    _i1.OrderByBuilder<CachedFoursquareResponseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CachedFoursquareResponseTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CachedFoursquareResponse>(
      where: where?.call(CachedFoursquareResponse.t),
      orderBy: orderBy?.call(CachedFoursquareResponse.t),
      orderByList: orderByList?.call(CachedFoursquareResponse.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CachedFoursquareResponse] by its [id] or null if no such row exists.
  Future<CachedFoursquareResponse?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CachedFoursquareResponse>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CachedFoursquareResponse]s in the list and returns the inserted rows.
  ///
  /// The returned [CachedFoursquareResponse]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CachedFoursquareResponse>> insert(
    _i1.Session session,
    List<CachedFoursquareResponse> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CachedFoursquareResponse>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CachedFoursquareResponse] and returns the inserted row.
  ///
  /// The returned [CachedFoursquareResponse] will have its `id` field set.
  Future<CachedFoursquareResponse> insertRow(
    _i1.Session session,
    CachedFoursquareResponse row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CachedFoursquareResponse>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CachedFoursquareResponse]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CachedFoursquareResponse>> update(
    _i1.Session session,
    List<CachedFoursquareResponse> rows, {
    _i1.ColumnSelections<CachedFoursquareResponseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CachedFoursquareResponse>(
      rows,
      columns: columns?.call(CachedFoursquareResponse.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CachedFoursquareResponse]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CachedFoursquareResponse> updateRow(
    _i1.Session session,
    CachedFoursquareResponse row, {
    _i1.ColumnSelections<CachedFoursquareResponseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CachedFoursquareResponse>(
      row,
      columns: columns?.call(CachedFoursquareResponse.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CachedFoursquareResponse] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CachedFoursquareResponse?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<CachedFoursquareResponseUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CachedFoursquareResponse>(
      id,
      columnValues: columnValues(CachedFoursquareResponse.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CachedFoursquareResponse]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CachedFoursquareResponse>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CachedFoursquareResponseUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<CachedFoursquareResponseTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CachedFoursquareResponseTable>? orderBy,
    _i1.OrderByListBuilder<CachedFoursquareResponseTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CachedFoursquareResponse>(
      columnValues: columnValues(CachedFoursquareResponse.t.updateTable),
      where: where(CachedFoursquareResponse.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CachedFoursquareResponse.t),
      orderByList: orderByList?.call(CachedFoursquareResponse.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CachedFoursquareResponse]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CachedFoursquareResponse>> delete(
    _i1.Session session,
    List<CachedFoursquareResponse> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CachedFoursquareResponse>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CachedFoursquareResponse].
  Future<CachedFoursquareResponse> deleteRow(
    _i1.Session session,
    CachedFoursquareResponse row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CachedFoursquareResponse>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CachedFoursquareResponse>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CachedFoursquareResponseTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CachedFoursquareResponse>(
      where: where(CachedFoursquareResponse.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CachedFoursquareResponseTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CachedFoursquareResponse>(
      where: where?.call(CachedFoursquareResponse.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
