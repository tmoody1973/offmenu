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

/// Tracks regenerate attempts per tour per day for rate limiting.
abstract class NarrativeRegenerateLimit
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  NarrativeRegenerateLimit._({
    this.id,
    required this.tourId,
    required this.userId,
    required this.limitDate,
    required this.attemptCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NarrativeRegenerateLimit({
    int? id,
    required int tourId,
    required String userId,
    required DateTime limitDate,
    required int attemptCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _NarrativeRegenerateLimitImpl;

  factory NarrativeRegenerateLimit.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NarrativeRegenerateLimit(
      id: jsonSerialization['id'] as int?,
      tourId: jsonSerialization['tourId'] as int,
      userId: jsonSerialization['userId'] as String,
      limitDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['limitDate'],
      ),
      attemptCount: jsonSerialization['attemptCount'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = NarrativeRegenerateLimitTable();

  static const db = NarrativeRegenerateLimitRepository._();

  @override
  int? id;

  /// Reference to the tour result.
  int tourId;

  /// User ID for tracking (or 'anonymous').
  String userId;

  /// Date for the limit tracking (truncated to day).
  DateTime limitDate;

  /// Number of regenerate attempts on this date.
  int attemptCount;

  /// When the record was created.
  DateTime createdAt;

  /// When the record was last updated.
  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [NarrativeRegenerateLimit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NarrativeRegenerateLimit copyWith({
    int? id,
    int? tourId,
    String? userId,
    DateTime? limitDate,
    int? attemptCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NarrativeRegenerateLimit',
      if (id != null) 'id': id,
      'tourId': tourId,
      'userId': userId,
      'limitDate': limitDate.toJson(),
      'attemptCount': attemptCount,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NarrativeRegenerateLimit',
      if (id != null) 'id': id,
      'tourId': tourId,
      'userId': userId,
      'limitDate': limitDate.toJson(),
      'attemptCount': attemptCount,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static NarrativeRegenerateLimitInclude include() {
    return NarrativeRegenerateLimitInclude._();
  }

  static NarrativeRegenerateLimitIncludeList includeList({
    _i1.WhereExpressionBuilder<NarrativeRegenerateLimitTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NarrativeRegenerateLimitTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NarrativeRegenerateLimitTable>? orderByList,
    NarrativeRegenerateLimitInclude? include,
  }) {
    return NarrativeRegenerateLimitIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NarrativeRegenerateLimit.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(NarrativeRegenerateLimit.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NarrativeRegenerateLimitImpl extends NarrativeRegenerateLimit {
  _NarrativeRegenerateLimitImpl({
    int? id,
    required int tourId,
    required String userId,
    required DateTime limitDate,
    required int attemptCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         tourId: tourId,
         userId: userId,
         limitDate: limitDate,
         attemptCount: attemptCount,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NarrativeRegenerateLimit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NarrativeRegenerateLimit copyWith({
    Object? id = _Undefined,
    int? tourId,
    String? userId,
    DateTime? limitDate,
    int? attemptCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NarrativeRegenerateLimit(
      id: id is int? ? id : this.id,
      tourId: tourId ?? this.tourId,
      userId: userId ?? this.userId,
      limitDate: limitDate ?? this.limitDate,
      attemptCount: attemptCount ?? this.attemptCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NarrativeRegenerateLimitUpdateTable
    extends _i1.UpdateTable<NarrativeRegenerateLimitTable> {
  NarrativeRegenerateLimitUpdateTable(super.table);

  _i1.ColumnValue<int, int> tourId(int value) => _i1.ColumnValue(
    table.tourId,
    value,
  );

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> limitDate(DateTime value) =>
      _i1.ColumnValue(
        table.limitDate,
        value,
      );

  _i1.ColumnValue<int, int> attemptCount(int value) => _i1.ColumnValue(
    table.attemptCount,
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

class NarrativeRegenerateLimitTable extends _i1.Table<int?> {
  NarrativeRegenerateLimitTable({super.tableRelation})
    : super(tableName: 'narrative_regenerate_limits') {
    updateTable = NarrativeRegenerateLimitUpdateTable(this);
    tourId = _i1.ColumnInt(
      'tourId',
      this,
    );
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    limitDate = _i1.ColumnDateTime(
      'limitDate',
      this,
    );
    attemptCount = _i1.ColumnInt(
      'attemptCount',
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

  late final NarrativeRegenerateLimitUpdateTable updateTable;

  /// Reference to the tour result.
  late final _i1.ColumnInt tourId;

  /// User ID for tracking (or 'anonymous').
  late final _i1.ColumnString userId;

  /// Date for the limit tracking (truncated to day).
  late final _i1.ColumnDateTime limitDate;

  /// Number of regenerate attempts on this date.
  late final _i1.ColumnInt attemptCount;

  /// When the record was created.
  late final _i1.ColumnDateTime createdAt;

  /// When the record was last updated.
  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    tourId,
    userId,
    limitDate,
    attemptCount,
    createdAt,
    updatedAt,
  ];
}

class NarrativeRegenerateLimitInclude extends _i1.IncludeObject {
  NarrativeRegenerateLimitInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => NarrativeRegenerateLimit.t;
}

class NarrativeRegenerateLimitIncludeList extends _i1.IncludeList {
  NarrativeRegenerateLimitIncludeList._({
    _i1.WhereExpressionBuilder<NarrativeRegenerateLimitTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NarrativeRegenerateLimit.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => NarrativeRegenerateLimit.t;
}

class NarrativeRegenerateLimitRepository {
  const NarrativeRegenerateLimitRepository._();

  /// Returns a list of [NarrativeRegenerateLimit]s matching the given query parameters.
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
  Future<List<NarrativeRegenerateLimit>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NarrativeRegenerateLimitTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NarrativeRegenerateLimitTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NarrativeRegenerateLimitTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<NarrativeRegenerateLimit>(
      where: where?.call(NarrativeRegenerateLimit.t),
      orderBy: orderBy?.call(NarrativeRegenerateLimit.t),
      orderByList: orderByList?.call(NarrativeRegenerateLimit.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [NarrativeRegenerateLimit] matching the given query parameters.
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
  Future<NarrativeRegenerateLimit?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NarrativeRegenerateLimitTable>? where,
    int? offset,
    _i1.OrderByBuilder<NarrativeRegenerateLimitTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NarrativeRegenerateLimitTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<NarrativeRegenerateLimit>(
      where: where?.call(NarrativeRegenerateLimit.t),
      orderBy: orderBy?.call(NarrativeRegenerateLimit.t),
      orderByList: orderByList?.call(NarrativeRegenerateLimit.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [NarrativeRegenerateLimit] by its [id] or null if no such row exists.
  Future<NarrativeRegenerateLimit?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<NarrativeRegenerateLimit>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [NarrativeRegenerateLimit]s in the list and returns the inserted rows.
  ///
  /// The returned [NarrativeRegenerateLimit]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<NarrativeRegenerateLimit>> insert(
    _i1.Session session,
    List<NarrativeRegenerateLimit> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<NarrativeRegenerateLimit>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [NarrativeRegenerateLimit] and returns the inserted row.
  ///
  /// The returned [NarrativeRegenerateLimit] will have its `id` field set.
  Future<NarrativeRegenerateLimit> insertRow(
    _i1.Session session,
    NarrativeRegenerateLimit row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<NarrativeRegenerateLimit>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [NarrativeRegenerateLimit]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<NarrativeRegenerateLimit>> update(
    _i1.Session session,
    List<NarrativeRegenerateLimit> rows, {
    _i1.ColumnSelections<NarrativeRegenerateLimitTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<NarrativeRegenerateLimit>(
      rows,
      columns: columns?.call(NarrativeRegenerateLimit.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NarrativeRegenerateLimit]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NarrativeRegenerateLimit> updateRow(
    _i1.Session session,
    NarrativeRegenerateLimit row, {
    _i1.ColumnSelections<NarrativeRegenerateLimitTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<NarrativeRegenerateLimit>(
      row,
      columns: columns?.call(NarrativeRegenerateLimit.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NarrativeRegenerateLimit] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NarrativeRegenerateLimit?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<NarrativeRegenerateLimitUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<NarrativeRegenerateLimit>(
      id,
      columnValues: columnValues(NarrativeRegenerateLimit.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NarrativeRegenerateLimit]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<NarrativeRegenerateLimit>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<NarrativeRegenerateLimitUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<NarrativeRegenerateLimitTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NarrativeRegenerateLimitTable>? orderBy,
    _i1.OrderByListBuilder<NarrativeRegenerateLimitTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<NarrativeRegenerateLimit>(
      columnValues: columnValues(NarrativeRegenerateLimit.t.updateTable),
      where: where(NarrativeRegenerateLimit.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NarrativeRegenerateLimit.t),
      orderByList: orderByList?.call(NarrativeRegenerateLimit.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [NarrativeRegenerateLimit]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<NarrativeRegenerateLimit>> delete(
    _i1.Session session,
    List<NarrativeRegenerateLimit> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<NarrativeRegenerateLimit>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [NarrativeRegenerateLimit].
  Future<NarrativeRegenerateLimit> deleteRow(
    _i1.Session session,
    NarrativeRegenerateLimit row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NarrativeRegenerateLimit>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<NarrativeRegenerateLimit>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<NarrativeRegenerateLimitTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<NarrativeRegenerateLimit>(
      where: where(NarrativeRegenerateLimit.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NarrativeRegenerateLimitTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<NarrativeRegenerateLimit>(
      where: where?.call(NarrativeRegenerateLimit.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
