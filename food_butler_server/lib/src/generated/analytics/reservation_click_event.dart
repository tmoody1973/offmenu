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
import '../analytics/reservation_link_type.dart' as _i2;

/// Analytics event for tracking reservation link clicks.
abstract class ReservationClickEvent
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ReservationClickEvent._({
    this.id,
    required this.restaurantId,
    required this.linkType,
    this.userId,
    required this.launchSuccess,
    required this.timestamp,
    required this.createdAt,
  });

  factory ReservationClickEvent({
    int? id,
    required int restaurantId,
    required _i2.ReservationLinkType linkType,
    String? userId,
    required bool launchSuccess,
    required DateTime timestamp,
    required DateTime createdAt,
  }) = _ReservationClickEventImpl;

  factory ReservationClickEvent.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ReservationClickEvent(
      id: jsonSerialization['id'] as int?,
      restaurantId: jsonSerialization['restaurantId'] as int,
      linkType: _i2.ReservationLinkType.fromJson(
        (jsonSerialization['linkType'] as String),
      ),
      userId: jsonSerialization['userId'] as String?,
      launchSuccess: jsonSerialization['launchSuccess'] as bool,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = ReservationClickEventTable();

  static const db = ReservationClickEventRepository._();

  @override
  int? id;

  /// Restaurant ID (foreign key to restaurants table).
  int restaurantId;

  /// Type of link clicked.
  _i2.ReservationLinkType linkType;

  /// User ID if authenticated (nullable).
  String? userId;

  /// Whether the URL launch was successful.
  bool launchSuccess;

  /// When the click occurred.
  DateTime timestamp;

  /// When the record was created.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ReservationClickEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReservationClickEvent copyWith({
    int? id,
    int? restaurantId,
    _i2.ReservationLinkType? linkType,
    String? userId,
    bool? launchSuccess,
    DateTime? timestamp,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReservationClickEvent',
      if (id != null) 'id': id,
      'restaurantId': restaurantId,
      'linkType': linkType.toJson(),
      if (userId != null) 'userId': userId,
      'launchSuccess': launchSuccess,
      'timestamp': timestamp.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReservationClickEvent',
      if (id != null) 'id': id,
      'restaurantId': restaurantId,
      'linkType': linkType.toJson(),
      if (userId != null) 'userId': userId,
      'launchSuccess': launchSuccess,
      'timestamp': timestamp.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static ReservationClickEventInclude include() {
    return ReservationClickEventInclude._();
  }

  static ReservationClickEventIncludeList includeList({
    _i1.WhereExpressionBuilder<ReservationClickEventTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReservationClickEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReservationClickEventTable>? orderByList,
    ReservationClickEventInclude? include,
  }) {
    return ReservationClickEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReservationClickEvent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ReservationClickEvent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReservationClickEventImpl extends ReservationClickEvent {
  _ReservationClickEventImpl({
    int? id,
    required int restaurantId,
    required _i2.ReservationLinkType linkType,
    String? userId,
    required bool launchSuccess,
    required DateTime timestamp,
    required DateTime createdAt,
  }) : super._(
         id: id,
         restaurantId: restaurantId,
         linkType: linkType,
         userId: userId,
         launchSuccess: launchSuccess,
         timestamp: timestamp,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ReservationClickEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReservationClickEvent copyWith({
    Object? id = _Undefined,
    int? restaurantId,
    _i2.ReservationLinkType? linkType,
    Object? userId = _Undefined,
    bool? launchSuccess,
    DateTime? timestamp,
    DateTime? createdAt,
  }) {
    return ReservationClickEvent(
      id: id is int? ? id : this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      linkType: linkType ?? this.linkType,
      userId: userId is String? ? userId : this.userId,
      launchSuccess: launchSuccess ?? this.launchSuccess,
      timestamp: timestamp ?? this.timestamp,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ReservationClickEventUpdateTable
    extends _i1.UpdateTable<ReservationClickEventTable> {
  ReservationClickEventUpdateTable(super.table);

  _i1.ColumnValue<int, int> restaurantId(int value) => _i1.ColumnValue(
    table.restaurantId,
    value,
  );

  _i1.ColumnValue<_i2.ReservationLinkType, _i2.ReservationLinkType> linkType(
    _i2.ReservationLinkType value,
  ) => _i1.ColumnValue(
    table.linkType,
    value,
  );

  _i1.ColumnValue<String, String> userId(String? value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<bool, bool> launchSuccess(bool value) => _i1.ColumnValue(
    table.launchSuccess,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> timestamp(DateTime value) =>
      _i1.ColumnValue(
        table.timestamp,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class ReservationClickEventTable extends _i1.Table<int?> {
  ReservationClickEventTable({super.tableRelation})
    : super(tableName: 'reservation_click_events') {
    updateTable = ReservationClickEventUpdateTable(this);
    restaurantId = _i1.ColumnInt(
      'restaurantId',
      this,
    );
    linkType = _i1.ColumnEnum(
      'linkType',
      this,
      _i1.EnumSerialization.byName,
    );
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    launchSuccess = _i1.ColumnBool(
      'launchSuccess',
      this,
    );
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final ReservationClickEventUpdateTable updateTable;

  /// Restaurant ID (foreign key to restaurants table).
  late final _i1.ColumnInt restaurantId;

  /// Type of link clicked.
  late final _i1.ColumnEnum<_i2.ReservationLinkType> linkType;

  /// User ID if authenticated (nullable).
  late final _i1.ColumnString userId;

  /// Whether the URL launch was successful.
  late final _i1.ColumnBool launchSuccess;

  /// When the click occurred.
  late final _i1.ColumnDateTime timestamp;

  /// When the record was created.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    restaurantId,
    linkType,
    userId,
    launchSuccess,
    timestamp,
    createdAt,
  ];
}

class ReservationClickEventInclude extends _i1.IncludeObject {
  ReservationClickEventInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ReservationClickEvent.t;
}

class ReservationClickEventIncludeList extends _i1.IncludeList {
  ReservationClickEventIncludeList._({
    _i1.WhereExpressionBuilder<ReservationClickEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReservationClickEvent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ReservationClickEvent.t;
}

class ReservationClickEventRepository {
  const ReservationClickEventRepository._();

  /// Returns a list of [ReservationClickEvent]s matching the given query parameters.
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
  Future<List<ReservationClickEvent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReservationClickEventTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReservationClickEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReservationClickEventTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ReservationClickEvent>(
      where: where?.call(ReservationClickEvent.t),
      orderBy: orderBy?.call(ReservationClickEvent.t),
      orderByList: orderByList?.call(ReservationClickEvent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ReservationClickEvent] matching the given query parameters.
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
  Future<ReservationClickEvent?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReservationClickEventTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReservationClickEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReservationClickEventTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ReservationClickEvent>(
      where: where?.call(ReservationClickEvent.t),
      orderBy: orderBy?.call(ReservationClickEvent.t),
      orderByList: orderByList?.call(ReservationClickEvent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ReservationClickEvent] by its [id] or null if no such row exists.
  Future<ReservationClickEvent?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ReservationClickEvent>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ReservationClickEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [ReservationClickEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ReservationClickEvent>> insert(
    _i1.Session session,
    List<ReservationClickEvent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ReservationClickEvent>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ReservationClickEvent] and returns the inserted row.
  ///
  /// The returned [ReservationClickEvent] will have its `id` field set.
  Future<ReservationClickEvent> insertRow(
    _i1.Session session,
    ReservationClickEvent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReservationClickEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ReservationClickEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ReservationClickEvent>> update(
    _i1.Session session,
    List<ReservationClickEvent> rows, {
    _i1.ColumnSelections<ReservationClickEventTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ReservationClickEvent>(
      rows,
      columns: columns?.call(ReservationClickEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReservationClickEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReservationClickEvent> updateRow(
    _i1.Session session,
    ReservationClickEvent row, {
    _i1.ColumnSelections<ReservationClickEventTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReservationClickEvent>(
      row,
      columns: columns?.call(ReservationClickEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReservationClickEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReservationClickEvent?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ReservationClickEventUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ReservationClickEvent>(
      id,
      columnValues: columnValues(ReservationClickEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReservationClickEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ReservationClickEvent>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ReservationClickEventUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ReservationClickEventTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReservationClickEventTable>? orderBy,
    _i1.OrderByListBuilder<ReservationClickEventTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ReservationClickEvent>(
      columnValues: columnValues(ReservationClickEvent.t.updateTable),
      where: where(ReservationClickEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReservationClickEvent.t),
      orderByList: orderByList?.call(ReservationClickEvent.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ReservationClickEvent]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ReservationClickEvent>> delete(
    _i1.Session session,
    List<ReservationClickEvent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ReservationClickEvent>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ReservationClickEvent].
  Future<ReservationClickEvent> deleteRow(
    _i1.Session session,
    ReservationClickEvent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReservationClickEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ReservationClickEvent>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ReservationClickEventTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ReservationClickEvent>(
      where: where(ReservationClickEvent.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReservationClickEventTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ReservationClickEvent>(
      where: where?.call(ReservationClickEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
