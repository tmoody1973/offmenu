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
import 'package:food_butler_server/src/generated/protocol.dart' as _i2;

/// Restaurant data from Foursquare Places API.
abstract class Restaurant
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Restaurant._({
    this.id,
    required this.fsqId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.priceTier,
    this.rating,
    required this.cuisineTypes,
    this.description,
    this.hours,
    this.dishData,
    this.opentableId,
    this.opentableSlug,
    this.phone,
    this.websiteUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Restaurant({
    int? id,
    required String fsqId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required int priceTier,
    double? rating,
    required List<String> cuisineTypes,
    String? description,
    String? hours,
    String? dishData,
    String? opentableId,
    String? opentableSlug,
    String? phone,
    String? websiteUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RestaurantImpl;

  factory Restaurant.fromJson(Map<String, dynamic> jsonSerialization) {
    return Restaurant(
      id: jsonSerialization['id'] as int?,
      fsqId: jsonSerialization['fsqId'] as String,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      priceTier: jsonSerialization['priceTier'] as int,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      cuisineTypes: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['cuisineTypes'],
      ),
      description: jsonSerialization['description'] as String?,
      hours: jsonSerialization['hours'] as String?,
      dishData: jsonSerialization['dishData'] as String?,
      opentableId: jsonSerialization['opentableId'] as String?,
      opentableSlug: jsonSerialization['opentableSlug'] as String?,
      phone: jsonSerialization['phone'] as String?,
      websiteUrl: jsonSerialization['websiteUrl'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = RestaurantTable();

  static const db = RestaurantRepository._();

  @override
  int? id;

  /// Foursquare unique identifier.
  String fsqId;

  /// Restaurant name.
  String name;

  /// Full address string.
  String address;

  /// Latitude coordinate.
  double latitude;

  /// Longitude coordinate.
  double longitude;

  /// Price tier (1-4, where 1 is cheapest).
  int priceTier;

  /// Rating from 0-10 scale.
  double? rating;

  /// List of cuisine types.
  List<String> cuisineTypes;

  /// Description of what makes this restaurant special (from AI discovery).
  String? description;

  /// Operating hours as JSON structure.
  String? hours;

  /// Dish-level data for digestion optimization.
  String? dishData;

  /// OpenTable restaurant ID for exact matching.
  String? opentableId;

  /// OpenTable URL slug for web deep links.
  String? opentableSlug;

  /// Phone number for fallback contact.
  String? phone;

  /// Website URL for fallback contact.
  String? websiteUrl;

  /// When the record was created.
  DateTime createdAt;

  /// When the record was last updated.
  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Restaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Restaurant copyWith({
    int? id,
    String? fsqId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? priceTier,
    double? rating,
    List<String>? cuisineTypes,
    String? description,
    String? hours,
    String? dishData,
    String? opentableId,
    String? opentableSlug,
    String? phone,
    String? websiteUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Restaurant',
      if (id != null) 'id': id,
      'fsqId': fsqId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'priceTier': priceTier,
      if (rating != null) 'rating': rating,
      'cuisineTypes': cuisineTypes.toJson(),
      if (description != null) 'description': description,
      if (hours != null) 'hours': hours,
      if (dishData != null) 'dishData': dishData,
      if (opentableId != null) 'opentableId': opentableId,
      if (opentableSlug != null) 'opentableSlug': opentableSlug,
      if (phone != null) 'phone': phone,
      if (websiteUrl != null) 'websiteUrl': websiteUrl,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Restaurant',
      if (id != null) 'id': id,
      'fsqId': fsqId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'priceTier': priceTier,
      if (rating != null) 'rating': rating,
      'cuisineTypes': cuisineTypes.toJson(),
      if (description != null) 'description': description,
      if (hours != null) 'hours': hours,
      if (dishData != null) 'dishData': dishData,
      if (opentableId != null) 'opentableId': opentableId,
      if (opentableSlug != null) 'opentableSlug': opentableSlug,
      if (phone != null) 'phone': phone,
      if (websiteUrl != null) 'websiteUrl': websiteUrl,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static RestaurantInclude include() {
    return RestaurantInclude._();
  }

  static RestaurantIncludeList includeList({
    _i1.WhereExpressionBuilder<RestaurantTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RestaurantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RestaurantTable>? orderByList,
    RestaurantInclude? include,
  }) {
    return RestaurantIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Restaurant.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Restaurant.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RestaurantImpl extends Restaurant {
  _RestaurantImpl({
    int? id,
    required String fsqId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required int priceTier,
    double? rating,
    required List<String> cuisineTypes,
    String? description,
    String? hours,
    String? dishData,
    String? opentableId,
    String? opentableSlug,
    String? phone,
    String? websiteUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         fsqId: fsqId,
         name: name,
         address: address,
         latitude: latitude,
         longitude: longitude,
         priceTier: priceTier,
         rating: rating,
         cuisineTypes: cuisineTypes,
         description: description,
         hours: hours,
         dishData: dishData,
         opentableId: opentableId,
         opentableSlug: opentableSlug,
         phone: phone,
         websiteUrl: websiteUrl,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Restaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Restaurant copyWith({
    Object? id = _Undefined,
    String? fsqId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? priceTier,
    Object? rating = _Undefined,
    List<String>? cuisineTypes,
    Object? description = _Undefined,
    Object? hours = _Undefined,
    Object? dishData = _Undefined,
    Object? opentableId = _Undefined,
    Object? opentableSlug = _Undefined,
    Object? phone = _Undefined,
    Object? websiteUrl = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Restaurant(
      id: id is int? ? id : this.id,
      fsqId: fsqId ?? this.fsqId,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      priceTier: priceTier ?? this.priceTier,
      rating: rating is double? ? rating : this.rating,
      cuisineTypes: cuisineTypes ?? this.cuisineTypes.map((e0) => e0).toList(),
      description: description is String? ? description : this.description,
      hours: hours is String? ? hours : this.hours,
      dishData: dishData is String? ? dishData : this.dishData,
      opentableId: opentableId is String? ? opentableId : this.opentableId,
      opentableSlug: opentableSlug is String?
          ? opentableSlug
          : this.opentableSlug,
      phone: phone is String? ? phone : this.phone,
      websiteUrl: websiteUrl is String? ? websiteUrl : this.websiteUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RestaurantUpdateTable extends _i1.UpdateTable<RestaurantTable> {
  RestaurantUpdateTable(super.table);

  _i1.ColumnValue<String, String> fsqId(String value) => _i1.ColumnValue(
    table.fsqId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> address(String value) => _i1.ColumnValue(
    table.address,
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

  _i1.ColumnValue<int, int> priceTier(int value) => _i1.ColumnValue(
    table.priceTier,
    value,
  );

  _i1.ColumnValue<double, double> rating(double? value) => _i1.ColumnValue(
    table.rating,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> cuisineTypes(
    List<String> value,
  ) => _i1.ColumnValue(
    table.cuisineTypes,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> hours(String? value) => _i1.ColumnValue(
    table.hours,
    value,
  );

  _i1.ColumnValue<String, String> dishData(String? value) => _i1.ColumnValue(
    table.dishData,
    value,
  );

  _i1.ColumnValue<String, String> opentableId(String? value) => _i1.ColumnValue(
    table.opentableId,
    value,
  );

  _i1.ColumnValue<String, String> opentableSlug(String? value) =>
      _i1.ColumnValue(
        table.opentableSlug,
        value,
      );

  _i1.ColumnValue<String, String> phone(String? value) => _i1.ColumnValue(
    table.phone,
    value,
  );

  _i1.ColumnValue<String, String> websiteUrl(String? value) => _i1.ColumnValue(
    table.websiteUrl,
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

class RestaurantTable extends _i1.Table<int?> {
  RestaurantTable({super.tableRelation}) : super(tableName: 'restaurants') {
    updateTable = RestaurantUpdateTable(this);
    fsqId = _i1.ColumnString(
      'fsqId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    address = _i1.ColumnString(
      'address',
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
    priceTier = _i1.ColumnInt(
      'priceTier',
      this,
    );
    rating = _i1.ColumnDouble(
      'rating',
      this,
    );
    cuisineTypes = _i1.ColumnSerializable<List<String>>(
      'cuisineTypes',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    hours = _i1.ColumnString(
      'hours',
      this,
    );
    dishData = _i1.ColumnString(
      'dishData',
      this,
    );
    opentableId = _i1.ColumnString(
      'opentableId',
      this,
    );
    opentableSlug = _i1.ColumnString(
      'opentableSlug',
      this,
    );
    phone = _i1.ColumnString(
      'phone',
      this,
    );
    websiteUrl = _i1.ColumnString(
      'websiteUrl',
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

  late final RestaurantUpdateTable updateTable;

  /// Foursquare unique identifier.
  late final _i1.ColumnString fsqId;

  /// Restaurant name.
  late final _i1.ColumnString name;

  /// Full address string.
  late final _i1.ColumnString address;

  /// Latitude coordinate.
  late final _i1.ColumnDouble latitude;

  /// Longitude coordinate.
  late final _i1.ColumnDouble longitude;

  /// Price tier (1-4, where 1 is cheapest).
  late final _i1.ColumnInt priceTier;

  /// Rating from 0-10 scale.
  late final _i1.ColumnDouble rating;

  /// List of cuisine types.
  late final _i1.ColumnSerializable<List<String>> cuisineTypes;

  /// Description of what makes this restaurant special (from AI discovery).
  late final _i1.ColumnString description;

  /// Operating hours as JSON structure.
  late final _i1.ColumnString hours;

  /// Dish-level data for digestion optimization.
  late final _i1.ColumnString dishData;

  /// OpenTable restaurant ID for exact matching.
  late final _i1.ColumnString opentableId;

  /// OpenTable URL slug for web deep links.
  late final _i1.ColumnString opentableSlug;

  /// Phone number for fallback contact.
  late final _i1.ColumnString phone;

  /// Website URL for fallback contact.
  late final _i1.ColumnString websiteUrl;

  /// When the record was created.
  late final _i1.ColumnDateTime createdAt;

  /// When the record was last updated.
  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    fsqId,
    name,
    address,
    latitude,
    longitude,
    priceTier,
    rating,
    cuisineTypes,
    description,
    hours,
    dishData,
    opentableId,
    opentableSlug,
    phone,
    websiteUrl,
    createdAt,
    updatedAt,
  ];
}

class RestaurantInclude extends _i1.IncludeObject {
  RestaurantInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Restaurant.t;
}

class RestaurantIncludeList extends _i1.IncludeList {
  RestaurantIncludeList._({
    _i1.WhereExpressionBuilder<RestaurantTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Restaurant.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Restaurant.t;
}

class RestaurantRepository {
  const RestaurantRepository._();

  /// Returns a list of [Restaurant]s matching the given query parameters.
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
  Future<List<Restaurant>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RestaurantTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RestaurantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RestaurantTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Restaurant>(
      where: where?.call(Restaurant.t),
      orderBy: orderBy?.call(Restaurant.t),
      orderByList: orderByList?.call(Restaurant.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Restaurant] matching the given query parameters.
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
  Future<Restaurant?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RestaurantTable>? where,
    int? offset,
    _i1.OrderByBuilder<RestaurantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RestaurantTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Restaurant>(
      where: where?.call(Restaurant.t),
      orderBy: orderBy?.call(Restaurant.t),
      orderByList: orderByList?.call(Restaurant.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Restaurant] by its [id] or null if no such row exists.
  Future<Restaurant?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Restaurant>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Restaurant]s in the list and returns the inserted rows.
  ///
  /// The returned [Restaurant]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Restaurant>> insert(
    _i1.Session session,
    List<Restaurant> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Restaurant>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Restaurant] and returns the inserted row.
  ///
  /// The returned [Restaurant] will have its `id` field set.
  Future<Restaurant> insertRow(
    _i1.Session session,
    Restaurant row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Restaurant>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Restaurant]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Restaurant>> update(
    _i1.Session session,
    List<Restaurant> rows, {
    _i1.ColumnSelections<RestaurantTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Restaurant>(
      rows,
      columns: columns?.call(Restaurant.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Restaurant]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Restaurant> updateRow(
    _i1.Session session,
    Restaurant row, {
    _i1.ColumnSelections<RestaurantTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Restaurant>(
      row,
      columns: columns?.call(Restaurant.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Restaurant] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Restaurant?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<RestaurantUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Restaurant>(
      id,
      columnValues: columnValues(Restaurant.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Restaurant]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Restaurant>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<RestaurantUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RestaurantTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RestaurantTable>? orderBy,
    _i1.OrderByListBuilder<RestaurantTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Restaurant>(
      columnValues: columnValues(Restaurant.t.updateTable),
      where: where(Restaurant.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Restaurant.t),
      orderByList: orderByList?.call(Restaurant.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Restaurant]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Restaurant>> delete(
    _i1.Session session,
    List<Restaurant> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Restaurant>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Restaurant].
  Future<Restaurant> deleteRow(
    _i1.Session session,
    Restaurant row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Restaurant>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Restaurant>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RestaurantTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Restaurant>(
      where: where(Restaurant.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RestaurantTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Restaurant>(
      where: where?.call(Restaurant.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
