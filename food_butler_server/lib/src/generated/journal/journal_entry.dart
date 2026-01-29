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

/// A food journal entry capturing a user's restaurant visit experience.
abstract class JournalEntry
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  JournalEntry._({
    this.id,
    required this.userId,
    required this.restaurantId,
    this.tourId,
    this.tourStopId,
    required this.rating,
    this.notes,
    required this.visitedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JournalEntry({
    int? id,
    required String userId,
    required int restaurantId,
    int? tourId,
    int? tourStopId,
    required int rating,
    String? notes,
    required DateTime visitedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _JournalEntryImpl;

  factory JournalEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return JournalEntry(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      restaurantId: jsonSerialization['restaurantId'] as int,
      tourId: jsonSerialization['tourId'] as int?,
      tourStopId: jsonSerialization['tourStopId'] as int?,
      rating: jsonSerialization['rating'] as int,
      notes: jsonSerialization['notes'] as String?,
      visitedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['visitedAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = JournalEntryTable();

  static const db = JournalEntryRepository._();

  @override
  int? id;

  /// The user who created this entry.
  String userId;

  /// The restaurant associated with this entry.
  int restaurantId;

  /// The tour this entry is associated with (optional).
  int? tourId;

  /// The specific tour stop this entry is associated with (optional).
  int? tourStopId;

  /// Rating from 1-5 stars.
  int rating;

  /// Free-text notes about the visit.
  String? notes;

  /// When the visit occurred (stored as UTC).
  DateTime visitedAt;

  /// When the entry was created.
  DateTime createdAt;

  /// When the entry was last updated.
  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [JournalEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  JournalEntry copyWith({
    int? id,
    String? userId,
    int? restaurantId,
    int? tourId,
    int? tourStopId,
    int? rating,
    String? notes,
    DateTime? visitedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JournalEntry',
      if (id != null) 'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      if (tourId != null) 'tourId': tourId,
      if (tourStopId != null) 'tourStopId': tourStopId,
      'rating': rating,
      if (notes != null) 'notes': notes,
      'visitedAt': visitedAt.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JournalEntry',
      if (id != null) 'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      if (tourId != null) 'tourId': tourId,
      if (tourStopId != null) 'tourStopId': tourStopId,
      'rating': rating,
      if (notes != null) 'notes': notes,
      'visitedAt': visitedAt.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static JournalEntryInclude include() {
    return JournalEntryInclude._();
  }

  static JournalEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<JournalEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<JournalEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<JournalEntryTable>? orderByList,
    JournalEntryInclude? include,
  }) {
    return JournalEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(JournalEntry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(JournalEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JournalEntryImpl extends JournalEntry {
  _JournalEntryImpl({
    int? id,
    required String userId,
    required int restaurantId,
    int? tourId,
    int? tourStopId,
    required int rating,
    String? notes,
    required DateTime visitedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         restaurantId: restaurantId,
         tourId: tourId,
         tourStopId: tourStopId,
         rating: rating,
         notes: notes,
         visitedAt: visitedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [JournalEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  JournalEntry copyWith({
    Object? id = _Undefined,
    String? userId,
    int? restaurantId,
    Object? tourId = _Undefined,
    Object? tourStopId = _Undefined,
    int? rating,
    Object? notes = _Undefined,
    DateTime? visitedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      tourId: tourId is int? ? tourId : this.tourId,
      tourStopId: tourStopId is int? ? tourStopId : this.tourStopId,
      rating: rating ?? this.rating,
      notes: notes is String? ? notes : this.notes,
      visitedAt: visitedAt ?? this.visitedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class JournalEntryUpdateTable extends _i1.UpdateTable<JournalEntryTable> {
  JournalEntryUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> restaurantId(int value) => _i1.ColumnValue(
    table.restaurantId,
    value,
  );

  _i1.ColumnValue<int, int> tourId(int? value) => _i1.ColumnValue(
    table.tourId,
    value,
  );

  _i1.ColumnValue<int, int> tourStopId(int? value) => _i1.ColumnValue(
    table.tourStopId,
    value,
  );

  _i1.ColumnValue<int, int> rating(int value) => _i1.ColumnValue(
    table.rating,
    value,
  );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> visitedAt(DateTime value) =>
      _i1.ColumnValue(
        table.visitedAt,
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

class JournalEntryTable extends _i1.Table<int?> {
  JournalEntryTable({super.tableRelation})
    : super(tableName: 'journal_entries') {
    updateTable = JournalEntryUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    restaurantId = _i1.ColumnInt(
      'restaurantId',
      this,
    );
    tourId = _i1.ColumnInt(
      'tourId',
      this,
    );
    tourStopId = _i1.ColumnInt(
      'tourStopId',
      this,
    );
    rating = _i1.ColumnInt(
      'rating',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
      this,
    );
    visitedAt = _i1.ColumnDateTime(
      'visitedAt',
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

  late final JournalEntryUpdateTable updateTable;

  /// The user who created this entry.
  late final _i1.ColumnString userId;

  /// The restaurant associated with this entry.
  late final _i1.ColumnInt restaurantId;

  /// The tour this entry is associated with (optional).
  late final _i1.ColumnInt tourId;

  /// The specific tour stop this entry is associated with (optional).
  late final _i1.ColumnInt tourStopId;

  /// Rating from 1-5 stars.
  late final _i1.ColumnInt rating;

  /// Free-text notes about the visit.
  late final _i1.ColumnString notes;

  /// When the visit occurred (stored as UTC).
  late final _i1.ColumnDateTime visitedAt;

  /// When the entry was created.
  late final _i1.ColumnDateTime createdAt;

  /// When the entry was last updated.
  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    restaurantId,
    tourId,
    tourStopId,
    rating,
    notes,
    visitedAt,
    createdAt,
    updatedAt,
  ];
}

class JournalEntryInclude extends _i1.IncludeObject {
  JournalEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => JournalEntry.t;
}

class JournalEntryIncludeList extends _i1.IncludeList {
  JournalEntryIncludeList._({
    _i1.WhereExpressionBuilder<JournalEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(JournalEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => JournalEntry.t;
}

class JournalEntryRepository {
  const JournalEntryRepository._();

  /// Returns a list of [JournalEntry]s matching the given query parameters.
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
  Future<List<JournalEntry>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<JournalEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<JournalEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<JournalEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<JournalEntry>(
      where: where?.call(JournalEntry.t),
      orderBy: orderBy?.call(JournalEntry.t),
      orderByList: orderByList?.call(JournalEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [JournalEntry] matching the given query parameters.
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
  Future<JournalEntry?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<JournalEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<JournalEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<JournalEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<JournalEntry>(
      where: where?.call(JournalEntry.t),
      orderBy: orderBy?.call(JournalEntry.t),
      orderByList: orderByList?.call(JournalEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [JournalEntry] by its [id] or null if no such row exists.
  Future<JournalEntry?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<JournalEntry>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [JournalEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [JournalEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<JournalEntry>> insert(
    _i1.Session session,
    List<JournalEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<JournalEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [JournalEntry] and returns the inserted row.
  ///
  /// The returned [JournalEntry] will have its `id` field set.
  Future<JournalEntry> insertRow(
    _i1.Session session,
    JournalEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<JournalEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [JournalEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<JournalEntry>> update(
    _i1.Session session,
    List<JournalEntry> rows, {
    _i1.ColumnSelections<JournalEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<JournalEntry>(
      rows,
      columns: columns?.call(JournalEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [JournalEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<JournalEntry> updateRow(
    _i1.Session session,
    JournalEntry row, {
    _i1.ColumnSelections<JournalEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<JournalEntry>(
      row,
      columns: columns?.call(JournalEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [JournalEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<JournalEntry?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<JournalEntryUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<JournalEntry>(
      id,
      columnValues: columnValues(JournalEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [JournalEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<JournalEntry>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<JournalEntryUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<JournalEntryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<JournalEntryTable>? orderBy,
    _i1.OrderByListBuilder<JournalEntryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<JournalEntry>(
      columnValues: columnValues(JournalEntry.t.updateTable),
      where: where(JournalEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(JournalEntry.t),
      orderByList: orderByList?.call(JournalEntry.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [JournalEntry]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<JournalEntry>> delete(
    _i1.Session session,
    List<JournalEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<JournalEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [JournalEntry].
  Future<JournalEntry> deleteRow(
    _i1.Session session,
    JournalEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<JournalEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<JournalEntry>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<JournalEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<JournalEntry>(
      where: where(JournalEntry.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<JournalEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<JournalEntry>(
      where: where?.call(JournalEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
