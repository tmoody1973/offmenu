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

/// A photo attached to a journal entry, stored in Cloudflare R2.
abstract class JournalPhoto
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  JournalPhoto._({
    this.id,
    required this.journalEntryId,
    required this.originalUrl,
    required this.thumbnailUrl,
    required this.displayOrder,
    required this.uploadedAt,
  });

  factory JournalPhoto({
    int? id,
    required int journalEntryId,
    required String originalUrl,
    required String thumbnailUrl,
    required int displayOrder,
    required DateTime uploadedAt,
  }) = _JournalPhotoImpl;

  factory JournalPhoto.fromJson(Map<String, dynamic> jsonSerialization) {
    return JournalPhoto(
      id: jsonSerialization['id'] as int?,
      journalEntryId: jsonSerialization['journalEntryId'] as int,
      originalUrl: jsonSerialization['originalUrl'] as String,
      thumbnailUrl: jsonSerialization['thumbnailUrl'] as String,
      displayOrder: jsonSerialization['displayOrder'] as int,
      uploadedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['uploadedAt'],
      ),
    );
  }

  static final t = JournalPhotoTable();

  static const db = JournalPhotoRepository._();

  @override
  int? id;

  /// The journal entry this photo belongs to.
  int journalEntryId;

  /// URL for the full-size image in R2.
  String originalUrl;

  /// URL for the 200x200 thumbnail in R2.
  String thumbnailUrl;

  /// Display order for the photo (0-2).
  int displayOrder;

  /// When the photo was uploaded.
  DateTime uploadedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [JournalPhoto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  JournalPhoto copyWith({
    int? id,
    int? journalEntryId,
    String? originalUrl,
    String? thumbnailUrl,
    int? displayOrder,
    DateTime? uploadedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JournalPhoto',
      if (id != null) 'id': id,
      'journalEntryId': journalEntryId,
      'originalUrl': originalUrl,
      'thumbnailUrl': thumbnailUrl,
      'displayOrder': displayOrder,
      'uploadedAt': uploadedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JournalPhoto',
      if (id != null) 'id': id,
      'journalEntryId': journalEntryId,
      'originalUrl': originalUrl,
      'thumbnailUrl': thumbnailUrl,
      'displayOrder': displayOrder,
      'uploadedAt': uploadedAt.toJson(),
    };
  }

  static JournalPhotoInclude include() {
    return JournalPhotoInclude._();
  }

  static JournalPhotoIncludeList includeList({
    _i1.WhereExpressionBuilder<JournalPhotoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<JournalPhotoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<JournalPhotoTable>? orderByList,
    JournalPhotoInclude? include,
  }) {
    return JournalPhotoIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(JournalPhoto.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(JournalPhoto.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JournalPhotoImpl extends JournalPhoto {
  _JournalPhotoImpl({
    int? id,
    required int journalEntryId,
    required String originalUrl,
    required String thumbnailUrl,
    required int displayOrder,
    required DateTime uploadedAt,
  }) : super._(
         id: id,
         journalEntryId: journalEntryId,
         originalUrl: originalUrl,
         thumbnailUrl: thumbnailUrl,
         displayOrder: displayOrder,
         uploadedAt: uploadedAt,
       );

  /// Returns a shallow copy of this [JournalPhoto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  JournalPhoto copyWith({
    Object? id = _Undefined,
    int? journalEntryId,
    String? originalUrl,
    String? thumbnailUrl,
    int? displayOrder,
    DateTime? uploadedAt,
  }) {
    return JournalPhoto(
      id: id is int? ? id : this.id,
      journalEntryId: journalEntryId ?? this.journalEntryId,
      originalUrl: originalUrl ?? this.originalUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      displayOrder: displayOrder ?? this.displayOrder,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}

class JournalPhotoUpdateTable extends _i1.UpdateTable<JournalPhotoTable> {
  JournalPhotoUpdateTable(super.table);

  _i1.ColumnValue<int, int> journalEntryId(int value) => _i1.ColumnValue(
    table.journalEntryId,
    value,
  );

  _i1.ColumnValue<String, String> originalUrl(String value) => _i1.ColumnValue(
    table.originalUrl,
    value,
  );

  _i1.ColumnValue<String, String> thumbnailUrl(String value) => _i1.ColumnValue(
    table.thumbnailUrl,
    value,
  );

  _i1.ColumnValue<int, int> displayOrder(int value) => _i1.ColumnValue(
    table.displayOrder,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> uploadedAt(DateTime value) =>
      _i1.ColumnValue(
        table.uploadedAt,
        value,
      );
}

class JournalPhotoTable extends _i1.Table<int?> {
  JournalPhotoTable({super.tableRelation})
    : super(tableName: 'journal_photos') {
    updateTable = JournalPhotoUpdateTable(this);
    journalEntryId = _i1.ColumnInt(
      'journalEntryId',
      this,
    );
    originalUrl = _i1.ColumnString(
      'originalUrl',
      this,
    );
    thumbnailUrl = _i1.ColumnString(
      'thumbnailUrl',
      this,
    );
    displayOrder = _i1.ColumnInt(
      'displayOrder',
      this,
    );
    uploadedAt = _i1.ColumnDateTime(
      'uploadedAt',
      this,
    );
  }

  late final JournalPhotoUpdateTable updateTable;

  /// The journal entry this photo belongs to.
  late final _i1.ColumnInt journalEntryId;

  /// URL for the full-size image in R2.
  late final _i1.ColumnString originalUrl;

  /// URL for the 200x200 thumbnail in R2.
  late final _i1.ColumnString thumbnailUrl;

  /// Display order for the photo (0-2).
  late final _i1.ColumnInt displayOrder;

  /// When the photo was uploaded.
  late final _i1.ColumnDateTime uploadedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    journalEntryId,
    originalUrl,
    thumbnailUrl,
    displayOrder,
    uploadedAt,
  ];
}

class JournalPhotoInclude extends _i1.IncludeObject {
  JournalPhotoInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => JournalPhoto.t;
}

class JournalPhotoIncludeList extends _i1.IncludeList {
  JournalPhotoIncludeList._({
    _i1.WhereExpressionBuilder<JournalPhotoTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(JournalPhoto.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => JournalPhoto.t;
}

class JournalPhotoRepository {
  const JournalPhotoRepository._();

  /// Returns a list of [JournalPhoto]s matching the given query parameters.
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
  Future<List<JournalPhoto>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<JournalPhotoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<JournalPhotoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<JournalPhotoTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<JournalPhoto>(
      where: where?.call(JournalPhoto.t),
      orderBy: orderBy?.call(JournalPhoto.t),
      orderByList: orderByList?.call(JournalPhoto.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [JournalPhoto] matching the given query parameters.
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
  Future<JournalPhoto?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<JournalPhotoTable>? where,
    int? offset,
    _i1.OrderByBuilder<JournalPhotoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<JournalPhotoTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<JournalPhoto>(
      where: where?.call(JournalPhoto.t),
      orderBy: orderBy?.call(JournalPhoto.t),
      orderByList: orderByList?.call(JournalPhoto.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [JournalPhoto] by its [id] or null if no such row exists.
  Future<JournalPhoto?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<JournalPhoto>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [JournalPhoto]s in the list and returns the inserted rows.
  ///
  /// The returned [JournalPhoto]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<JournalPhoto>> insert(
    _i1.Session session,
    List<JournalPhoto> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<JournalPhoto>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [JournalPhoto] and returns the inserted row.
  ///
  /// The returned [JournalPhoto] will have its `id` field set.
  Future<JournalPhoto> insertRow(
    _i1.Session session,
    JournalPhoto row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<JournalPhoto>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [JournalPhoto]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<JournalPhoto>> update(
    _i1.Session session,
    List<JournalPhoto> rows, {
    _i1.ColumnSelections<JournalPhotoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<JournalPhoto>(
      rows,
      columns: columns?.call(JournalPhoto.t),
      transaction: transaction,
    );
  }

  /// Updates a single [JournalPhoto]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<JournalPhoto> updateRow(
    _i1.Session session,
    JournalPhoto row, {
    _i1.ColumnSelections<JournalPhotoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<JournalPhoto>(
      row,
      columns: columns?.call(JournalPhoto.t),
      transaction: transaction,
    );
  }

  /// Updates a single [JournalPhoto] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<JournalPhoto?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<JournalPhotoUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<JournalPhoto>(
      id,
      columnValues: columnValues(JournalPhoto.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [JournalPhoto]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<JournalPhoto>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<JournalPhotoUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<JournalPhotoTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<JournalPhotoTable>? orderBy,
    _i1.OrderByListBuilder<JournalPhotoTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<JournalPhoto>(
      columnValues: columnValues(JournalPhoto.t.updateTable),
      where: where(JournalPhoto.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(JournalPhoto.t),
      orderByList: orderByList?.call(JournalPhoto.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [JournalPhoto]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<JournalPhoto>> delete(
    _i1.Session session,
    List<JournalPhoto> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<JournalPhoto>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [JournalPhoto].
  Future<JournalPhoto> deleteRow(
    _i1.Session session,
    JournalPhoto row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<JournalPhoto>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<JournalPhoto>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<JournalPhotoTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<JournalPhoto>(
      where: where(JournalPhoto.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<JournalPhotoTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<JournalPhoto>(
      where: where?.call(JournalPhoto.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
