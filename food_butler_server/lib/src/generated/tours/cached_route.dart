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
import '../tours/transport_mode.dart' as _i2;

/// Cached Mapbox route for reducing API calls.
abstract class CachedRoute
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CachedRoute._({
    this.id,
    required this.waypointsHash,
    required this.transportMode,
    required this.polyline,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.legsJson,
    required this.expiresAt,
    required this.createdAt,
  });

  factory CachedRoute({
    int? id,
    required String waypointsHash,
    required _i2.TransportMode transportMode,
    required String polyline,
    required int distanceMeters,
    required int durationSeconds,
    required String legsJson,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _CachedRouteImpl;

  factory CachedRoute.fromJson(Map<String, dynamic> jsonSerialization) {
    return CachedRoute(
      id: jsonSerialization['id'] as int?,
      waypointsHash: jsonSerialization['waypointsHash'] as String,
      transportMode: _i2.TransportMode.fromJson(
        (jsonSerialization['transportMode'] as String),
      ),
      polyline: jsonSerialization['polyline'] as String,
      distanceMeters: jsonSerialization['distanceMeters'] as int,
      durationSeconds: jsonSerialization['durationSeconds'] as int,
      legsJson: jsonSerialization['legsJson'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = CachedRouteTable();

  static const db = CachedRouteRepository._();

  @override
  int? id;

  /// Hash of sorted waypoints for cache lookup.
  String waypointsHash;

  /// Transport mode for this cached route.
  _i2.TransportMode transportMode;

  /// Encoded polyline string.
  String polyline;

  /// Total distance in meters.
  int distanceMeters;

  /// Total duration in seconds.
  int durationSeconds;

  /// Per-leg data as JSON string.
  String legsJson;

  /// When the cache entry expires.
  DateTime expiresAt;

  /// When the cache entry was created.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CachedRoute]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CachedRoute copyWith({
    int? id,
    String? waypointsHash,
    _i2.TransportMode? transportMode,
    String? polyline,
    int? distanceMeters,
    int? durationSeconds,
    String? legsJson,
    DateTime? expiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CachedRoute',
      if (id != null) 'id': id,
      'waypointsHash': waypointsHash,
      'transportMode': transportMode.toJson(),
      'polyline': polyline,
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'legsJson': legsJson,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CachedRoute',
      if (id != null) 'id': id,
      'waypointsHash': waypointsHash,
      'transportMode': transportMode.toJson(),
      'polyline': polyline,
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'legsJson': legsJson,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static CachedRouteInclude include() {
    return CachedRouteInclude._();
  }

  static CachedRouteIncludeList includeList({
    _i1.WhereExpressionBuilder<CachedRouteTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CachedRouteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CachedRouteTable>? orderByList,
    CachedRouteInclude? include,
  }) {
    return CachedRouteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CachedRoute.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CachedRoute.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CachedRouteImpl extends CachedRoute {
  _CachedRouteImpl({
    int? id,
    required String waypointsHash,
    required _i2.TransportMode transportMode,
    required String polyline,
    required int distanceMeters,
    required int durationSeconds,
    required String legsJson,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         waypointsHash: waypointsHash,
         transportMode: transportMode,
         polyline: polyline,
         distanceMeters: distanceMeters,
         durationSeconds: durationSeconds,
         legsJson: legsJson,
         expiresAt: expiresAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CachedRoute]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CachedRoute copyWith({
    Object? id = _Undefined,
    String? waypointsHash,
    _i2.TransportMode? transportMode,
    String? polyline,
    int? distanceMeters,
    int? durationSeconds,
    String? legsJson,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return CachedRoute(
      id: id is int? ? id : this.id,
      waypointsHash: waypointsHash ?? this.waypointsHash,
      transportMode: transportMode ?? this.transportMode,
      polyline: polyline ?? this.polyline,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      legsJson: legsJson ?? this.legsJson,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CachedRouteUpdateTable extends _i1.UpdateTable<CachedRouteTable> {
  CachedRouteUpdateTable(super.table);

  _i1.ColumnValue<String, String> waypointsHash(String value) =>
      _i1.ColumnValue(
        table.waypointsHash,
        value,
      );

  _i1.ColumnValue<_i2.TransportMode, _i2.TransportMode> transportMode(
    _i2.TransportMode value,
  ) => _i1.ColumnValue(
    table.transportMode,
    value,
  );

  _i1.ColumnValue<String, String> polyline(String value) => _i1.ColumnValue(
    table.polyline,
    value,
  );

  _i1.ColumnValue<int, int> distanceMeters(int value) => _i1.ColumnValue(
    table.distanceMeters,
    value,
  );

  _i1.ColumnValue<int, int> durationSeconds(int value) => _i1.ColumnValue(
    table.durationSeconds,
    value,
  );

  _i1.ColumnValue<String, String> legsJson(String value) => _i1.ColumnValue(
    table.legsJson,
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

class CachedRouteTable extends _i1.Table<int?> {
  CachedRouteTable({super.tableRelation}) : super(tableName: 'cached_routes') {
    updateTable = CachedRouteUpdateTable(this);
    waypointsHash = _i1.ColumnString(
      'waypointsHash',
      this,
    );
    transportMode = _i1.ColumnEnum(
      'transportMode',
      this,
      _i1.EnumSerialization.byName,
    );
    polyline = _i1.ColumnString(
      'polyline',
      this,
    );
    distanceMeters = _i1.ColumnInt(
      'distanceMeters',
      this,
    );
    durationSeconds = _i1.ColumnInt(
      'durationSeconds',
      this,
    );
    legsJson = _i1.ColumnString(
      'legsJson',
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

  late final CachedRouteUpdateTable updateTable;

  /// Hash of sorted waypoints for cache lookup.
  late final _i1.ColumnString waypointsHash;

  /// Transport mode for this cached route.
  late final _i1.ColumnEnum<_i2.TransportMode> transportMode;

  /// Encoded polyline string.
  late final _i1.ColumnString polyline;

  /// Total distance in meters.
  late final _i1.ColumnInt distanceMeters;

  /// Total duration in seconds.
  late final _i1.ColumnInt durationSeconds;

  /// Per-leg data as JSON string.
  late final _i1.ColumnString legsJson;

  /// When the cache entry expires.
  late final _i1.ColumnDateTime expiresAt;

  /// When the cache entry was created.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    waypointsHash,
    transportMode,
    polyline,
    distanceMeters,
    durationSeconds,
    legsJson,
    expiresAt,
    createdAt,
  ];
}

class CachedRouteInclude extends _i1.IncludeObject {
  CachedRouteInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CachedRoute.t;
}

class CachedRouteIncludeList extends _i1.IncludeList {
  CachedRouteIncludeList._({
    _i1.WhereExpressionBuilder<CachedRouteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CachedRoute.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CachedRoute.t;
}

class CachedRouteRepository {
  const CachedRouteRepository._();

  /// Returns a list of [CachedRoute]s matching the given query parameters.
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
  Future<List<CachedRoute>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CachedRouteTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CachedRouteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CachedRouteTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CachedRoute>(
      where: where?.call(CachedRoute.t),
      orderBy: orderBy?.call(CachedRoute.t),
      orderByList: orderByList?.call(CachedRoute.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CachedRoute] matching the given query parameters.
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
  Future<CachedRoute?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CachedRouteTable>? where,
    int? offset,
    _i1.OrderByBuilder<CachedRouteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CachedRouteTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CachedRoute>(
      where: where?.call(CachedRoute.t),
      orderBy: orderBy?.call(CachedRoute.t),
      orderByList: orderByList?.call(CachedRoute.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CachedRoute] by its [id] or null if no such row exists.
  Future<CachedRoute?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CachedRoute>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CachedRoute]s in the list and returns the inserted rows.
  ///
  /// The returned [CachedRoute]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CachedRoute>> insert(
    _i1.Session session,
    List<CachedRoute> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CachedRoute>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CachedRoute] and returns the inserted row.
  ///
  /// The returned [CachedRoute] will have its `id` field set.
  Future<CachedRoute> insertRow(
    _i1.Session session,
    CachedRoute row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CachedRoute>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CachedRoute]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CachedRoute>> update(
    _i1.Session session,
    List<CachedRoute> rows, {
    _i1.ColumnSelections<CachedRouteTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CachedRoute>(
      rows,
      columns: columns?.call(CachedRoute.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CachedRoute]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CachedRoute> updateRow(
    _i1.Session session,
    CachedRoute row, {
    _i1.ColumnSelections<CachedRouteTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CachedRoute>(
      row,
      columns: columns?.call(CachedRoute.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CachedRoute] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CachedRoute?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<CachedRouteUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CachedRoute>(
      id,
      columnValues: columnValues(CachedRoute.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CachedRoute]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CachedRoute>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CachedRouteUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CachedRouteTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CachedRouteTable>? orderBy,
    _i1.OrderByListBuilder<CachedRouteTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CachedRoute>(
      columnValues: columnValues(CachedRoute.t.updateTable),
      where: where(CachedRoute.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CachedRoute.t),
      orderByList: orderByList?.call(CachedRoute.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CachedRoute]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CachedRoute>> delete(
    _i1.Session session,
    List<CachedRoute> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CachedRoute>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CachedRoute].
  Future<CachedRoute> deleteRow(
    _i1.Session session,
    CachedRoute row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CachedRoute>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CachedRoute>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CachedRouteTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CachedRoute>(
      where: where(CachedRoute.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CachedRouteTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CachedRoute>(
      where: where?.call(CachedRoute.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
