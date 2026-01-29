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

/// Audit log for award data imports.
abstract class AwardImportLog
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AwardImportLog._({
    this.id,
    required this.importType,
    required this.fileName,
    required this.recordsImported,
    required this.recordsMatched,
    required this.recordsPendingReview,
    required this.importedByUserId,
    required this.createdAt,
  });

  factory AwardImportLog({
    int? id,
    required _i2.AwardType importType,
    required String fileName,
    required int recordsImported,
    required int recordsMatched,
    required int recordsPendingReview,
    required int importedByUserId,
    required DateTime createdAt,
  }) = _AwardImportLogImpl;

  factory AwardImportLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return AwardImportLog(
      id: jsonSerialization['id'] as int?,
      importType: _i2.AwardType.fromJson(
        (jsonSerialization['importType'] as String),
      ),
      fileName: jsonSerialization['fileName'] as String,
      recordsImported: jsonSerialization['recordsImported'] as int,
      recordsMatched: jsonSerialization['recordsMatched'] as int,
      recordsPendingReview: jsonSerialization['recordsPendingReview'] as int,
      importedByUserId: jsonSerialization['importedByUserId'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AwardImportLogTable();

  static const db = AwardImportLogRepository._();

  @override
  int? id;

  /// Type of awards imported.
  _i2.AwardType importType;

  /// Name of the uploaded file.
  String fileName;

  /// Number of records imported.
  int recordsImported;

  /// Number of records successfully matched.
  int recordsMatched;

  /// Number of records pending manual review.
  int recordsPendingReview;

  /// User who performed the import.
  int importedByUserId;

  /// When the import was performed.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AwardImportLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AwardImportLog copyWith({
    int? id,
    _i2.AwardType? importType,
    String? fileName,
    int? recordsImported,
    int? recordsMatched,
    int? recordsPendingReview,
    int? importedByUserId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AwardImportLog',
      if (id != null) 'id': id,
      'importType': importType.toJson(),
      'fileName': fileName,
      'recordsImported': recordsImported,
      'recordsMatched': recordsMatched,
      'recordsPendingReview': recordsPendingReview,
      'importedByUserId': importedByUserId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AwardImportLog',
      if (id != null) 'id': id,
      'importType': importType.toJson(),
      'fileName': fileName,
      'recordsImported': recordsImported,
      'recordsMatched': recordsMatched,
      'recordsPendingReview': recordsPendingReview,
      'importedByUserId': importedByUserId,
      'createdAt': createdAt.toJson(),
    };
  }

  static AwardImportLogInclude include() {
    return AwardImportLogInclude._();
  }

  static AwardImportLogIncludeList includeList({
    _i1.WhereExpressionBuilder<AwardImportLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AwardImportLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AwardImportLogTable>? orderByList,
    AwardImportLogInclude? include,
  }) {
    return AwardImportLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AwardImportLog.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AwardImportLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AwardImportLogImpl extends AwardImportLog {
  _AwardImportLogImpl({
    int? id,
    required _i2.AwardType importType,
    required String fileName,
    required int recordsImported,
    required int recordsMatched,
    required int recordsPendingReview,
    required int importedByUserId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         importType: importType,
         fileName: fileName,
         recordsImported: recordsImported,
         recordsMatched: recordsMatched,
         recordsPendingReview: recordsPendingReview,
         importedByUserId: importedByUserId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AwardImportLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AwardImportLog copyWith({
    Object? id = _Undefined,
    _i2.AwardType? importType,
    String? fileName,
    int? recordsImported,
    int? recordsMatched,
    int? recordsPendingReview,
    int? importedByUserId,
    DateTime? createdAt,
  }) {
    return AwardImportLog(
      id: id is int? ? id : this.id,
      importType: importType ?? this.importType,
      fileName: fileName ?? this.fileName,
      recordsImported: recordsImported ?? this.recordsImported,
      recordsMatched: recordsMatched ?? this.recordsMatched,
      recordsPendingReview: recordsPendingReview ?? this.recordsPendingReview,
      importedByUserId: importedByUserId ?? this.importedByUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AwardImportLogUpdateTable extends _i1.UpdateTable<AwardImportLogTable> {
  AwardImportLogUpdateTable(super.table);

  _i1.ColumnValue<_i2.AwardType, _i2.AwardType> importType(
    _i2.AwardType value,
  ) => _i1.ColumnValue(
    table.importType,
    value,
  );

  _i1.ColumnValue<String, String> fileName(String value) => _i1.ColumnValue(
    table.fileName,
    value,
  );

  _i1.ColumnValue<int, int> recordsImported(int value) => _i1.ColumnValue(
    table.recordsImported,
    value,
  );

  _i1.ColumnValue<int, int> recordsMatched(int value) => _i1.ColumnValue(
    table.recordsMatched,
    value,
  );

  _i1.ColumnValue<int, int> recordsPendingReview(int value) => _i1.ColumnValue(
    table.recordsPendingReview,
    value,
  );

  _i1.ColumnValue<int, int> importedByUserId(int value) => _i1.ColumnValue(
    table.importedByUserId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AwardImportLogTable extends _i1.Table<int?> {
  AwardImportLogTable({super.tableRelation})
    : super(tableName: 'award_import_logs') {
    updateTable = AwardImportLogUpdateTable(this);
    importType = _i1.ColumnEnum(
      'importType',
      this,
      _i1.EnumSerialization.byName,
    );
    fileName = _i1.ColumnString(
      'fileName',
      this,
    );
    recordsImported = _i1.ColumnInt(
      'recordsImported',
      this,
    );
    recordsMatched = _i1.ColumnInt(
      'recordsMatched',
      this,
    );
    recordsPendingReview = _i1.ColumnInt(
      'recordsPendingReview',
      this,
    );
    importedByUserId = _i1.ColumnInt(
      'importedByUserId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AwardImportLogUpdateTable updateTable;

  /// Type of awards imported.
  late final _i1.ColumnEnum<_i2.AwardType> importType;

  /// Name of the uploaded file.
  late final _i1.ColumnString fileName;

  /// Number of records imported.
  late final _i1.ColumnInt recordsImported;

  /// Number of records successfully matched.
  late final _i1.ColumnInt recordsMatched;

  /// Number of records pending manual review.
  late final _i1.ColumnInt recordsPendingReview;

  /// User who performed the import.
  late final _i1.ColumnInt importedByUserId;

  /// When the import was performed.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    importType,
    fileName,
    recordsImported,
    recordsMatched,
    recordsPendingReview,
    importedByUserId,
    createdAt,
  ];
}

class AwardImportLogInclude extends _i1.IncludeObject {
  AwardImportLogInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AwardImportLog.t;
}

class AwardImportLogIncludeList extends _i1.IncludeList {
  AwardImportLogIncludeList._({
    _i1.WhereExpressionBuilder<AwardImportLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AwardImportLog.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AwardImportLog.t;
}

class AwardImportLogRepository {
  const AwardImportLogRepository._();

  /// Returns a list of [AwardImportLog]s matching the given query parameters.
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
  Future<List<AwardImportLog>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AwardImportLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AwardImportLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AwardImportLogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AwardImportLog>(
      where: where?.call(AwardImportLog.t),
      orderBy: orderBy?.call(AwardImportLog.t),
      orderByList: orderByList?.call(AwardImportLog.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AwardImportLog] matching the given query parameters.
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
  Future<AwardImportLog?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AwardImportLogTable>? where,
    int? offset,
    _i1.OrderByBuilder<AwardImportLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AwardImportLogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AwardImportLog>(
      where: where?.call(AwardImportLog.t),
      orderBy: orderBy?.call(AwardImportLog.t),
      orderByList: orderByList?.call(AwardImportLog.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AwardImportLog] by its [id] or null if no such row exists.
  Future<AwardImportLog?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AwardImportLog>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AwardImportLog]s in the list and returns the inserted rows.
  ///
  /// The returned [AwardImportLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AwardImportLog>> insert(
    _i1.Session session,
    List<AwardImportLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AwardImportLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AwardImportLog] and returns the inserted row.
  ///
  /// The returned [AwardImportLog] will have its `id` field set.
  Future<AwardImportLog> insertRow(
    _i1.Session session,
    AwardImportLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AwardImportLog>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AwardImportLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AwardImportLog>> update(
    _i1.Session session,
    List<AwardImportLog> rows, {
    _i1.ColumnSelections<AwardImportLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AwardImportLog>(
      rows,
      columns: columns?.call(AwardImportLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AwardImportLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AwardImportLog> updateRow(
    _i1.Session session,
    AwardImportLog row, {
    _i1.ColumnSelections<AwardImportLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AwardImportLog>(
      row,
      columns: columns?.call(AwardImportLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AwardImportLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AwardImportLog?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AwardImportLogUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AwardImportLog>(
      id,
      columnValues: columnValues(AwardImportLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AwardImportLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AwardImportLog>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AwardImportLogUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AwardImportLogTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AwardImportLogTable>? orderBy,
    _i1.OrderByListBuilder<AwardImportLogTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AwardImportLog>(
      columnValues: columnValues(AwardImportLog.t.updateTable),
      where: where(AwardImportLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AwardImportLog.t),
      orderByList: orderByList?.call(AwardImportLog.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AwardImportLog]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AwardImportLog>> delete(
    _i1.Session session,
    List<AwardImportLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AwardImportLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AwardImportLog].
  Future<AwardImportLog> deleteRow(
    _i1.Session session,
    AwardImportLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AwardImportLog>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AwardImportLog>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AwardImportLogTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AwardImportLog>(
      where: where(AwardImportLog.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AwardImportLogTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AwardImportLog>(
      where: where?.call(AwardImportLog.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
