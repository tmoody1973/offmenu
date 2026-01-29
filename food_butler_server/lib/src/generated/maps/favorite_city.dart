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

/// A user's favorite city for restaurant maps.
/// Users can have their home city + up to 10 additional cities (11 total).
abstract class FavoriteCity
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  FavoriteCity._({
    this.id,
    required this.userId,
    required this.cityName,
    this.stateOrRegion,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.isHomeCity,
    required this.displayOrder,
    required this.createdAt,
  });

  factory FavoriteCity({
    int? id,
    required String userId,
    required String cityName,
    String? stateOrRegion,
    required String country,
    required double latitude,
    required double longitude,
    required bool isHomeCity,
    required int displayOrder,
    required DateTime createdAt,
  }) = _FavoriteCityImpl;

  factory FavoriteCity.fromJson(Map<String, dynamic> jsonSerialization) {
    return FavoriteCity(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      cityName: jsonSerialization['cityName'] as String,
      stateOrRegion: jsonSerialization['stateOrRegion'] as String?,
      country: jsonSerialization['country'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      isHomeCity: jsonSerialization['isHomeCity'] as bool,
      displayOrder: jsonSerialization['displayOrder'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = FavoriteCityTable();

  static const db = FavoriteCityRepository._();

  @override
  int? id;

  /// The user ID who saved this city.
  String userId;

  /// City name (e.g., "Austin", "Chicago", "Tokyo").
  String cityName;

  /// State/region (e.g., "TX", "IL", "Tokyo").
  String? stateOrRegion;

  /// Country (e.g., "USA", "Japan").
  String country;

  /// Latitude of city center.
  double latitude;

  /// Longitude of city center.
  double longitude;

  /// Whether this is the user's home city.
  bool isHomeCity;

  /// Display order (0 = home city, 1-10 = favorites).
  int displayOrder;

  /// When this city was added.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [FavoriteCity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FavoriteCity copyWith({
    int? id,
    String? userId,
    String? cityName,
    String? stateOrRegion,
    String? country,
    double? latitude,
    double? longitude,
    bool? isHomeCity,
    int? displayOrder,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FavoriteCity',
      if (id != null) 'id': id,
      'userId': userId,
      'cityName': cityName,
      if (stateOrRegion != null) 'stateOrRegion': stateOrRegion,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'isHomeCity': isHomeCity,
      'displayOrder': displayOrder,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FavoriteCity',
      if (id != null) 'id': id,
      'userId': userId,
      'cityName': cityName,
      if (stateOrRegion != null) 'stateOrRegion': stateOrRegion,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'isHomeCity': isHomeCity,
      'displayOrder': displayOrder,
      'createdAt': createdAt.toJson(),
    };
  }

  static FavoriteCityInclude include() {
    return FavoriteCityInclude._();
  }

  static FavoriteCityIncludeList includeList({
    _i1.WhereExpressionBuilder<FavoriteCityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FavoriteCityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FavoriteCityTable>? orderByList,
    FavoriteCityInclude? include,
  }) {
    return FavoriteCityIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FavoriteCity.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FavoriteCity.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FavoriteCityImpl extends FavoriteCity {
  _FavoriteCityImpl({
    int? id,
    required String userId,
    required String cityName,
    String? stateOrRegion,
    required String country,
    required double latitude,
    required double longitude,
    required bool isHomeCity,
    required int displayOrder,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         cityName: cityName,
         stateOrRegion: stateOrRegion,
         country: country,
         latitude: latitude,
         longitude: longitude,
         isHomeCity: isHomeCity,
         displayOrder: displayOrder,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [FavoriteCity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FavoriteCity copyWith({
    Object? id = _Undefined,
    String? userId,
    String? cityName,
    Object? stateOrRegion = _Undefined,
    String? country,
    double? latitude,
    double? longitude,
    bool? isHomeCity,
    int? displayOrder,
    DateTime? createdAt,
  }) {
    return FavoriteCity(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      cityName: cityName ?? this.cityName,
      stateOrRegion: stateOrRegion is String?
          ? stateOrRegion
          : this.stateOrRegion,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isHomeCity: isHomeCity ?? this.isHomeCity,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class FavoriteCityUpdateTable extends _i1.UpdateTable<FavoriteCityTable> {
  FavoriteCityUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> cityName(String value) => _i1.ColumnValue(
    table.cityName,
    value,
  );

  _i1.ColumnValue<String, String> stateOrRegion(String? value) =>
      _i1.ColumnValue(
        table.stateOrRegion,
        value,
      );

  _i1.ColumnValue<String, String> country(String value) => _i1.ColumnValue(
    table.country,
    value,
  );

  _i1.ColumnValue<double, double> latitude(double value) => _i1.ColumnValue(
    table.latitude,
    value,
  );

  _i1.ColumnValue<double, double> longitude(double value) => _i1.ColumnValue(
    table.longitude,
    value,
  );

  _i1.ColumnValue<bool, bool> isHomeCity(bool value) => _i1.ColumnValue(
    table.isHomeCity,
    value,
  );

  _i1.ColumnValue<int, int> displayOrder(int value) => _i1.ColumnValue(
    table.displayOrder,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class FavoriteCityTable extends _i1.Table<int?> {
  FavoriteCityTable({super.tableRelation})
    : super(tableName: 'favorite_cities') {
    updateTable = FavoriteCityUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    cityName = _i1.ColumnString(
      'cityName',
      this,
    );
    stateOrRegion = _i1.ColumnString(
      'stateOrRegion',
      this,
    );
    country = _i1.ColumnString(
      'country',
      this,
    );
    latitude = _i1.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _i1.ColumnDouble(
      'longitude',
      this,
    );
    isHomeCity = _i1.ColumnBool(
      'isHomeCity',
      this,
    );
    displayOrder = _i1.ColumnInt(
      'displayOrder',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final FavoriteCityUpdateTable updateTable;

  /// The user ID who saved this city.
  late final _i1.ColumnString userId;

  /// City name (e.g., "Austin", "Chicago", "Tokyo").
  late final _i1.ColumnString cityName;

  /// State/region (e.g., "TX", "IL", "Tokyo").
  late final _i1.ColumnString stateOrRegion;

  /// Country (e.g., "USA", "Japan").
  late final _i1.ColumnString country;

  /// Latitude of city center.
  late final _i1.ColumnDouble latitude;

  /// Longitude of city center.
  late final _i1.ColumnDouble longitude;

  /// Whether this is the user's home city.
  late final _i1.ColumnBool isHomeCity;

  /// Display order (0 = home city, 1-10 = favorites).
  late final _i1.ColumnInt displayOrder;

  /// When this city was added.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    cityName,
    stateOrRegion,
    country,
    latitude,
    longitude,
    isHomeCity,
    displayOrder,
    createdAt,
  ];
}

class FavoriteCityInclude extends _i1.IncludeObject {
  FavoriteCityInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => FavoriteCity.t;
}

class FavoriteCityIncludeList extends _i1.IncludeList {
  FavoriteCityIncludeList._({
    _i1.WhereExpressionBuilder<FavoriteCityTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FavoriteCity.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => FavoriteCity.t;
}

class FavoriteCityRepository {
  const FavoriteCityRepository._();

  /// Returns a list of [FavoriteCity]s matching the given query parameters.
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
  Future<List<FavoriteCity>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FavoriteCityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FavoriteCityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FavoriteCityTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<FavoriteCity>(
      where: where?.call(FavoriteCity.t),
      orderBy: orderBy?.call(FavoriteCity.t),
      orderByList: orderByList?.call(FavoriteCity.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [FavoriteCity] matching the given query parameters.
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
  Future<FavoriteCity?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FavoriteCityTable>? where,
    int? offset,
    _i1.OrderByBuilder<FavoriteCityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FavoriteCityTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<FavoriteCity>(
      where: where?.call(FavoriteCity.t),
      orderBy: orderBy?.call(FavoriteCity.t),
      orderByList: orderByList?.call(FavoriteCity.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [FavoriteCity] by its [id] or null if no such row exists.
  Future<FavoriteCity?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<FavoriteCity>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [FavoriteCity]s in the list and returns the inserted rows.
  ///
  /// The returned [FavoriteCity]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<FavoriteCity>> insert(
    _i1.Session session,
    List<FavoriteCity> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<FavoriteCity>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [FavoriteCity] and returns the inserted row.
  ///
  /// The returned [FavoriteCity] will have its `id` field set.
  Future<FavoriteCity> insertRow(
    _i1.Session session,
    FavoriteCity row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FavoriteCity>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FavoriteCity]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FavoriteCity>> update(
    _i1.Session session,
    List<FavoriteCity> rows, {
    _i1.ColumnSelections<FavoriteCityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FavoriteCity>(
      rows,
      columns: columns?.call(FavoriteCity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FavoriteCity]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FavoriteCity> updateRow(
    _i1.Session session,
    FavoriteCity row, {
    _i1.ColumnSelections<FavoriteCityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FavoriteCity>(
      row,
      columns: columns?.call(FavoriteCity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FavoriteCity] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FavoriteCity?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<FavoriteCityUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FavoriteCity>(
      id,
      columnValues: columnValues(FavoriteCity.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FavoriteCity]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<FavoriteCity>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<FavoriteCityUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<FavoriteCityTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FavoriteCityTable>? orderBy,
    _i1.OrderByListBuilder<FavoriteCityTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<FavoriteCity>(
      columnValues: columnValues(FavoriteCity.t.updateTable),
      where: where(FavoriteCity.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FavoriteCity.t),
      orderByList: orderByList?.call(FavoriteCity.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [FavoriteCity]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FavoriteCity>> delete(
    _i1.Session session,
    List<FavoriteCity> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FavoriteCity>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FavoriteCity].
  Future<FavoriteCity> deleteRow(
    _i1.Session session,
    FavoriteCity row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FavoriteCity>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FavoriteCity>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FavoriteCityTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FavoriteCity>(
      where: where(FavoriteCity.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FavoriteCityTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FavoriteCity>(
      where: where?.call(FavoriteCity.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
