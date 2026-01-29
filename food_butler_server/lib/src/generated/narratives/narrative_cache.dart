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

/// Cached LLM-generated narrative content for tours.
abstract class NarrativeCache
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  NarrativeCache._({
    this.id,
    required this.tourId,
    this.userId,
    required this.narrativeType,
    this.stopIndex,
    required this.content,
    required this.generatedAt,
    required this.expiresAt,
    required this.cacheHitCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NarrativeCache({
    int? id,
    required int tourId,
    String? userId,
    required String narrativeType,
    int? stopIndex,
    required String content,
    required DateTime generatedAt,
    required DateTime expiresAt,
    required int cacheHitCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _NarrativeCacheImpl;

  factory NarrativeCache.fromJson(Map<String, dynamic> jsonSerialization) {
    return NarrativeCache(
      id: jsonSerialization['id'] as int?,
      tourId: jsonSerialization['tourId'] as int,
      userId: jsonSerialization['userId'] as String?,
      narrativeType: jsonSerialization['narrativeType'] as String,
      stopIndex: jsonSerialization['stopIndex'] as int?,
      content: jsonSerialization['content'] as String,
      generatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      cacheHitCount: jsonSerialization['cacheHitCount'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = NarrativeCacheTable();

  static const db = NarrativeCacheRepository._();

  @override
  int? id;

  /// Reference to the tour result this narrative belongs to.
  int tourId;

  /// User ID for personalized narratives (null for anonymous users).
  String? userId;

  /// Type of narrative (intro, description, transition).
  String narrativeType;

  /// Stop index for description/transition narratives (null for intro).
  int? stopIndex;

  /// The generated narrative content.
  String content;

  /// When the narrative was generated.
  DateTime generatedAt;

  /// When the cache entry expires.
  DateTime expiresAt;

  /// Number of cache hits for monitoring.
  int cacheHitCount;

  /// When the record was created.
  DateTime createdAt;

  /// When the record was last updated.
  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [NarrativeCache]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NarrativeCache copyWith({
    int? id,
    int? tourId,
    String? userId,
    String? narrativeType,
    int? stopIndex,
    String? content,
    DateTime? generatedAt,
    DateTime? expiresAt,
    int? cacheHitCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NarrativeCache',
      if (id != null) 'id': id,
      'tourId': tourId,
      if (userId != null) 'userId': userId,
      'narrativeType': narrativeType,
      if (stopIndex != null) 'stopIndex': stopIndex,
      'content': content,
      'generatedAt': generatedAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      'cacheHitCount': cacheHitCount,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NarrativeCache',
      if (id != null) 'id': id,
      'tourId': tourId,
      if (userId != null) 'userId': userId,
      'narrativeType': narrativeType,
      if (stopIndex != null) 'stopIndex': stopIndex,
      'content': content,
      'generatedAt': generatedAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      'cacheHitCount': cacheHitCount,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static NarrativeCacheInclude include() {
    return NarrativeCacheInclude._();
  }

  static NarrativeCacheIncludeList includeList({
    _i1.WhereExpressionBuilder<NarrativeCacheTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NarrativeCacheTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NarrativeCacheTable>? orderByList,
    NarrativeCacheInclude? include,
  }) {
    return NarrativeCacheIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NarrativeCache.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(NarrativeCache.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NarrativeCacheImpl extends NarrativeCache {
  _NarrativeCacheImpl({
    int? id,
    required int tourId,
    String? userId,
    required String narrativeType,
    int? stopIndex,
    required String content,
    required DateTime generatedAt,
    required DateTime expiresAt,
    required int cacheHitCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         tourId: tourId,
         userId: userId,
         narrativeType: narrativeType,
         stopIndex: stopIndex,
         content: content,
         generatedAt: generatedAt,
         expiresAt: expiresAt,
         cacheHitCount: cacheHitCount,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NarrativeCache]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NarrativeCache copyWith({
    Object? id = _Undefined,
    int? tourId,
    Object? userId = _Undefined,
    String? narrativeType,
    Object? stopIndex = _Undefined,
    String? content,
    DateTime? generatedAt,
    DateTime? expiresAt,
    int? cacheHitCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NarrativeCache(
      id: id is int? ? id : this.id,
      tourId: tourId ?? this.tourId,
      userId: userId is String? ? userId : this.userId,
      narrativeType: narrativeType ?? this.narrativeType,
      stopIndex: stopIndex is int? ? stopIndex : this.stopIndex,
      content: content ?? this.content,
      generatedAt: generatedAt ?? this.generatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      cacheHitCount: cacheHitCount ?? this.cacheHitCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NarrativeCacheUpdateTable extends _i1.UpdateTable<NarrativeCacheTable> {
  NarrativeCacheUpdateTable(super.table);

  _i1.ColumnValue<int, int> tourId(int value) => _i1.ColumnValue(
    table.tourId,
    value,
  );

  _i1.ColumnValue<String, String> userId(String? value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> narrativeType(String value) =>
      _i1.ColumnValue(
        table.narrativeType,
        value,
      );

  _i1.ColumnValue<int, int> stopIndex(int? value) => _i1.ColumnValue(
    table.stopIndex,
    value,
  );

  _i1.ColumnValue<String, String> content(String value) => _i1.ColumnValue(
    table.content,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> generatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.generatedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );

  _i1.ColumnValue<int, int> cacheHitCount(int value) => _i1.ColumnValue(
    table.cacheHitCount,
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

class NarrativeCacheTable extends _i1.Table<int?> {
  NarrativeCacheTable({super.tableRelation})
    : super(tableName: 'narrative_caches') {
    updateTable = NarrativeCacheUpdateTable(this);
    tourId = _i1.ColumnInt(
      'tourId',
      this,
    );
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    narrativeType = _i1.ColumnString(
      'narrativeType',
      this,
    );
    stopIndex = _i1.ColumnInt(
      'stopIndex',
      this,
    );
    content = _i1.ColumnString(
      'content',
      this,
    );
    generatedAt = _i1.ColumnDateTime(
      'generatedAt',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    cacheHitCount = _i1.ColumnInt(
      'cacheHitCount',
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

  late final NarrativeCacheUpdateTable updateTable;

  /// Reference to the tour result this narrative belongs to.
  late final _i1.ColumnInt tourId;

  /// User ID for personalized narratives (null for anonymous users).
  late final _i1.ColumnString userId;

  /// Type of narrative (intro, description, transition).
  late final _i1.ColumnString narrativeType;

  /// Stop index for description/transition narratives (null for intro).
  late final _i1.ColumnInt stopIndex;

  /// The generated narrative content.
  late final _i1.ColumnString content;

  /// When the narrative was generated.
  late final _i1.ColumnDateTime generatedAt;

  /// When the cache entry expires.
  late final _i1.ColumnDateTime expiresAt;

  /// Number of cache hits for monitoring.
  late final _i1.ColumnInt cacheHitCount;

  /// When the record was created.
  late final _i1.ColumnDateTime createdAt;

  /// When the record was last updated.
  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    tourId,
    userId,
    narrativeType,
    stopIndex,
    content,
    generatedAt,
    expiresAt,
    cacheHitCount,
    createdAt,
    updatedAt,
  ];
}

class NarrativeCacheInclude extends _i1.IncludeObject {
  NarrativeCacheInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => NarrativeCache.t;
}

class NarrativeCacheIncludeList extends _i1.IncludeList {
  NarrativeCacheIncludeList._({
    _i1.WhereExpressionBuilder<NarrativeCacheTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NarrativeCache.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => NarrativeCache.t;
}

class NarrativeCacheRepository {
  const NarrativeCacheRepository._();

  /// Returns a list of [NarrativeCache]s matching the given query parameters.
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
  Future<List<NarrativeCache>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NarrativeCacheTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NarrativeCacheTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NarrativeCacheTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<NarrativeCache>(
      where: where?.call(NarrativeCache.t),
      orderBy: orderBy?.call(NarrativeCache.t),
      orderByList: orderByList?.call(NarrativeCache.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [NarrativeCache] matching the given query parameters.
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
  Future<NarrativeCache?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NarrativeCacheTable>? where,
    int? offset,
    _i1.OrderByBuilder<NarrativeCacheTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NarrativeCacheTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<NarrativeCache>(
      where: where?.call(NarrativeCache.t),
      orderBy: orderBy?.call(NarrativeCache.t),
      orderByList: orderByList?.call(NarrativeCache.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [NarrativeCache] by its [id] or null if no such row exists.
  Future<NarrativeCache?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<NarrativeCache>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [NarrativeCache]s in the list and returns the inserted rows.
  ///
  /// The returned [NarrativeCache]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<NarrativeCache>> insert(
    _i1.Session session,
    List<NarrativeCache> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<NarrativeCache>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [NarrativeCache] and returns the inserted row.
  ///
  /// The returned [NarrativeCache] will have its `id` field set.
  Future<NarrativeCache> insertRow(
    _i1.Session session,
    NarrativeCache row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<NarrativeCache>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [NarrativeCache]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<NarrativeCache>> update(
    _i1.Session session,
    List<NarrativeCache> rows, {
    _i1.ColumnSelections<NarrativeCacheTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<NarrativeCache>(
      rows,
      columns: columns?.call(NarrativeCache.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NarrativeCache]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NarrativeCache> updateRow(
    _i1.Session session,
    NarrativeCache row, {
    _i1.ColumnSelections<NarrativeCacheTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<NarrativeCache>(
      row,
      columns: columns?.call(NarrativeCache.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NarrativeCache] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NarrativeCache?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<NarrativeCacheUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<NarrativeCache>(
      id,
      columnValues: columnValues(NarrativeCache.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NarrativeCache]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<NarrativeCache>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<NarrativeCacheUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<NarrativeCacheTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NarrativeCacheTable>? orderBy,
    _i1.OrderByListBuilder<NarrativeCacheTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<NarrativeCache>(
      columnValues: columnValues(NarrativeCache.t.updateTable),
      where: where(NarrativeCache.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NarrativeCache.t),
      orderByList: orderByList?.call(NarrativeCache.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [NarrativeCache]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<NarrativeCache>> delete(
    _i1.Session session,
    List<NarrativeCache> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<NarrativeCache>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [NarrativeCache].
  Future<NarrativeCache> deleteRow(
    _i1.Session session,
    NarrativeCache row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NarrativeCache>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<NarrativeCache>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<NarrativeCacheTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<NarrativeCache>(
      where: where(NarrativeCache.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NarrativeCacheTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<NarrativeCache>(
      where: where?.call(NarrativeCache.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
