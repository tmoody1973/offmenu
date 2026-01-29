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
import '../tours/budget_tier.dart' as _i3;
import 'package:food_butler_server/src/generated/protocol.dart' as _i4;

/// Input parameters for tour generation request.
abstract class TourRequest
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TourRequest._({
    this.id,
    required this.startLatitude,
    required this.startLongitude,
    this.startAddress,
    required this.numStops,
    required this.transportMode,
    this.cuisinePreferences,
    required this.awardOnly,
    required this.startTime,
    this.endTime,
    required this.budgetTier,
    this.specificDish,
    required this.createdAt,
  });

  factory TourRequest({
    int? id,
    required double startLatitude,
    required double startLongitude,
    String? startAddress,
    required int numStops,
    required _i2.TransportMode transportMode,
    List<String>? cuisinePreferences,
    required bool awardOnly,
    required DateTime startTime,
    DateTime? endTime,
    required _i3.BudgetTier budgetTier,
    String? specificDish,
    required DateTime createdAt,
  }) = _TourRequestImpl;

  factory TourRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return TourRequest(
      id: jsonSerialization['id'] as int?,
      startLatitude: (jsonSerialization['startLatitude'] as num).toDouble(),
      startLongitude: (jsonSerialization['startLongitude'] as num).toDouble(),
      startAddress: jsonSerialization['startAddress'] as String?,
      numStops: jsonSerialization['numStops'] as int,
      transportMode: _i2.TransportMode.fromJson(
        (jsonSerialization['transportMode'] as String),
      ),
      cuisinePreferences: jsonSerialization['cuisinePreferences'] == null
          ? null
          : _i4.Protocol().deserialize<List<String>>(
              jsonSerialization['cuisinePreferences'],
            ),
      awardOnly: jsonSerialization['awardOnly'] as bool,
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      endTime: jsonSerialization['endTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      budgetTier: _i3.BudgetTier.fromJson(
        (jsonSerialization['budgetTier'] as String),
      ),
      specificDish: jsonSerialization['specificDish'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = TourRequestTable();

  static const db = TourRequestRepository._();

  @override
  int? id;

  /// Starting point latitude.
  double startLatitude;

  /// Starting point longitude.
  double startLongitude;

  /// Optional starting address string for display.
  String? startAddress;

  /// Number of stops (3-6 inclusive).
  int numStops;

  /// Transport mode for navigation.
  _i2.TransportMode transportMode;

  /// Optional cuisine type preferences.
  List<String>? cuisinePreferences;

  /// Filter for award-winning restaurants only.
  bool awardOnly;

  /// Tour start time.
  DateTime startTime;

  /// Optional preferred end time.
  DateTime? endTime;

  /// Budget tier preference.
  _i3.BudgetTier budgetTier;

  /// Optional specific dish to search for (e.g., "tonkotsu ramen", "tacos al pastor").
  String? specificDish;

  /// When the request was created.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TourRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TourRequest copyWith({
    int? id,
    double? startLatitude,
    double? startLongitude,
    String? startAddress,
    int? numStops,
    _i2.TransportMode? transportMode,
    List<String>? cuisinePreferences,
    bool? awardOnly,
    DateTime? startTime,
    DateTime? endTime,
    _i3.BudgetTier? budgetTier,
    String? specificDish,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TourRequest',
      if (id != null) 'id': id,
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      if (startAddress != null) 'startAddress': startAddress,
      'numStops': numStops,
      'transportMode': transportMode.toJson(),
      if (cuisinePreferences != null)
        'cuisinePreferences': cuisinePreferences?.toJson(),
      'awardOnly': awardOnly,
      'startTime': startTime.toJson(),
      if (endTime != null) 'endTime': endTime?.toJson(),
      'budgetTier': budgetTier.toJson(),
      if (specificDish != null) 'specificDish': specificDish,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TourRequest',
      if (id != null) 'id': id,
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      if (startAddress != null) 'startAddress': startAddress,
      'numStops': numStops,
      'transportMode': transportMode.toJson(),
      if (cuisinePreferences != null)
        'cuisinePreferences': cuisinePreferences?.toJson(),
      'awardOnly': awardOnly,
      'startTime': startTime.toJson(),
      if (endTime != null) 'endTime': endTime?.toJson(),
      'budgetTier': budgetTier.toJson(),
      if (specificDish != null) 'specificDish': specificDish,
      'createdAt': createdAt.toJson(),
    };
  }

  static TourRequestInclude include() {
    return TourRequestInclude._();
  }

  static TourRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<TourRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TourRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TourRequestTable>? orderByList,
    TourRequestInclude? include,
  }) {
    return TourRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TourRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TourRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TourRequestImpl extends TourRequest {
  _TourRequestImpl({
    int? id,
    required double startLatitude,
    required double startLongitude,
    String? startAddress,
    required int numStops,
    required _i2.TransportMode transportMode,
    List<String>? cuisinePreferences,
    required bool awardOnly,
    required DateTime startTime,
    DateTime? endTime,
    required _i3.BudgetTier budgetTier,
    String? specificDish,
    required DateTime createdAt,
  }) : super._(
         id: id,
         startLatitude: startLatitude,
         startLongitude: startLongitude,
         startAddress: startAddress,
         numStops: numStops,
         transportMode: transportMode,
         cuisinePreferences: cuisinePreferences,
         awardOnly: awardOnly,
         startTime: startTime,
         endTime: endTime,
         budgetTier: budgetTier,
         specificDish: specificDish,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TourRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TourRequest copyWith({
    Object? id = _Undefined,
    double? startLatitude,
    double? startLongitude,
    Object? startAddress = _Undefined,
    int? numStops,
    _i2.TransportMode? transportMode,
    Object? cuisinePreferences = _Undefined,
    bool? awardOnly,
    DateTime? startTime,
    Object? endTime = _Undefined,
    _i3.BudgetTier? budgetTier,
    Object? specificDish = _Undefined,
    DateTime? createdAt,
  }) {
    return TourRequest(
      id: id is int? ? id : this.id,
      startLatitude: startLatitude ?? this.startLatitude,
      startLongitude: startLongitude ?? this.startLongitude,
      startAddress: startAddress is String? ? startAddress : this.startAddress,
      numStops: numStops ?? this.numStops,
      transportMode: transportMode ?? this.transportMode,
      cuisinePreferences: cuisinePreferences is List<String>?
          ? cuisinePreferences
          : this.cuisinePreferences?.map((e0) => e0).toList(),
      awardOnly: awardOnly ?? this.awardOnly,
      startTime: startTime ?? this.startTime,
      endTime: endTime is DateTime? ? endTime : this.endTime,
      budgetTier: budgetTier ?? this.budgetTier,
      specificDish: specificDish is String? ? specificDish : this.specificDish,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TourRequestUpdateTable extends _i1.UpdateTable<TourRequestTable> {
  TourRequestUpdateTable(super.table);

  _i1.ColumnValue<double, double> startLatitude(double value) =>
      _i1.ColumnValue(
        table.startLatitude,
        value,
      );

  _i1.ColumnValue<double, double> startLongitude(double value) =>
      _i1.ColumnValue(
        table.startLongitude,
        value,
      );

  _i1.ColumnValue<String, String> startAddress(String? value) =>
      _i1.ColumnValue(
        table.startAddress,
        value,
      );

  _i1.ColumnValue<int, int> numStops(int value) => _i1.ColumnValue(
    table.numStops,
    value,
  );

  _i1.ColumnValue<_i2.TransportMode, _i2.TransportMode> transportMode(
    _i2.TransportMode value,
  ) => _i1.ColumnValue(
    table.transportMode,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> cuisinePreferences(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.cuisinePreferences,
    value,
  );

  _i1.ColumnValue<bool, bool> awardOnly(bool value) => _i1.ColumnValue(
    table.awardOnly,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startTime(DateTime value) =>
      _i1.ColumnValue(
        table.startTime,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endTime(DateTime? value) =>
      _i1.ColumnValue(
        table.endTime,
        value,
      );

  _i1.ColumnValue<_i3.BudgetTier, _i3.BudgetTier> budgetTier(
    _i3.BudgetTier value,
  ) => _i1.ColumnValue(
    table.budgetTier,
    value,
  );

  _i1.ColumnValue<String, String> specificDish(String? value) =>
      _i1.ColumnValue(
        table.specificDish,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class TourRequestTable extends _i1.Table<int?> {
  TourRequestTable({super.tableRelation}) : super(tableName: 'tour_requests') {
    updateTable = TourRequestUpdateTable(this);
    startLatitude = _i1.ColumnDouble(
      'startLatitude',
      this,
    );
    startLongitude = _i1.ColumnDouble(
      'startLongitude',
      this,
    );
    startAddress = _i1.ColumnString(
      'startAddress',
      this,
    );
    numStops = _i1.ColumnInt(
      'numStops',
      this,
    );
    transportMode = _i1.ColumnEnum(
      'transportMode',
      this,
      _i1.EnumSerialization.byName,
    );
    cuisinePreferences = _i1.ColumnSerializable<List<String>>(
      'cuisinePreferences',
      this,
    );
    awardOnly = _i1.ColumnBool(
      'awardOnly',
      this,
    );
    startTime = _i1.ColumnDateTime(
      'startTime',
      this,
    );
    endTime = _i1.ColumnDateTime(
      'endTime',
      this,
    );
    budgetTier = _i1.ColumnEnum(
      'budgetTier',
      this,
      _i1.EnumSerialization.byName,
    );
    specificDish = _i1.ColumnString(
      'specificDish',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final TourRequestUpdateTable updateTable;

  /// Starting point latitude.
  late final _i1.ColumnDouble startLatitude;

  /// Starting point longitude.
  late final _i1.ColumnDouble startLongitude;

  /// Optional starting address string for display.
  late final _i1.ColumnString startAddress;

  /// Number of stops (3-6 inclusive).
  late final _i1.ColumnInt numStops;

  /// Transport mode for navigation.
  late final _i1.ColumnEnum<_i2.TransportMode> transportMode;

  /// Optional cuisine type preferences.
  late final _i1.ColumnSerializable<List<String>> cuisinePreferences;

  /// Filter for award-winning restaurants only.
  late final _i1.ColumnBool awardOnly;

  /// Tour start time.
  late final _i1.ColumnDateTime startTime;

  /// Optional preferred end time.
  late final _i1.ColumnDateTime endTime;

  /// Budget tier preference.
  late final _i1.ColumnEnum<_i3.BudgetTier> budgetTier;

  /// Optional specific dish to search for (e.g., "tonkotsu ramen", "tacos al pastor").
  late final _i1.ColumnString specificDish;

  /// When the request was created.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    startLatitude,
    startLongitude,
    startAddress,
    numStops,
    transportMode,
    cuisinePreferences,
    awardOnly,
    startTime,
    endTime,
    budgetTier,
    specificDish,
    createdAt,
  ];
}

class TourRequestInclude extends _i1.IncludeObject {
  TourRequestInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TourRequest.t;
}

class TourRequestIncludeList extends _i1.IncludeList {
  TourRequestIncludeList._({
    _i1.WhereExpressionBuilder<TourRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TourRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TourRequest.t;
}

class TourRequestRepository {
  const TourRequestRepository._();

  /// Returns a list of [TourRequest]s matching the given query parameters.
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
  Future<List<TourRequest>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TourRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TourRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TourRequestTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<TourRequest>(
      where: where?.call(TourRequest.t),
      orderBy: orderBy?.call(TourRequest.t),
      orderByList: orderByList?.call(TourRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TourRequest] matching the given query parameters.
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
  Future<TourRequest?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TourRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<TourRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TourRequestTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TourRequest>(
      where: where?.call(TourRequest.t),
      orderBy: orderBy?.call(TourRequest.t),
      orderByList: orderByList?.call(TourRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TourRequest] by its [id] or null if no such row exists.
  Future<TourRequest?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<TourRequest>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TourRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [TourRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TourRequest>> insert(
    _i1.Session session,
    List<TourRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TourRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TourRequest] and returns the inserted row.
  ///
  /// The returned [TourRequest] will have its `id` field set.
  Future<TourRequest> insertRow(
    _i1.Session session,
    TourRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TourRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TourRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TourRequest>> update(
    _i1.Session session,
    List<TourRequest> rows, {
    _i1.ColumnSelections<TourRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TourRequest>(
      rows,
      columns: columns?.call(TourRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TourRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TourRequest> updateRow(
    _i1.Session session,
    TourRequest row, {
    _i1.ColumnSelections<TourRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TourRequest>(
      row,
      columns: columns?.call(TourRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TourRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TourRequest?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TourRequestUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TourRequest>(
      id,
      columnValues: columnValues(TourRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TourRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TourRequest>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TourRequestUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TourRequestTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TourRequestTable>? orderBy,
    _i1.OrderByListBuilder<TourRequestTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TourRequest>(
      columnValues: columnValues(TourRequest.t.updateTable),
      where: where(TourRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TourRequest.t),
      orderByList: orderByList?.call(TourRequest.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TourRequest]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TourRequest>> delete(
    _i1.Session session,
    List<TourRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TourRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TourRequest].
  Future<TourRequest> deleteRow(
    _i1.Session session,
    TourRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TourRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TourRequest>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TourRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TourRequest>(
      where: where(TourRequest.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TourRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TourRequest>(
      where: where?.call(TourRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
