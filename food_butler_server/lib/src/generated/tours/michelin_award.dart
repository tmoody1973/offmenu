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
import '../tours/michelin_designation.dart' as _i2;

/// Michelin Guide award record for restaurant designations.
abstract class MichelinAward
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  MichelinAward._({
    this.id,
    required this.restaurantName,
    required this.city,
    this.address,
    this.latitude,
    this.longitude,
    required this.designation,
    required this.awardYear,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MichelinAward({
    int? id,
    required String restaurantName,
    required String city,
    String? address,
    double? latitude,
    double? longitude,
    required _i2.MichelinDesignation designation,
    required int awardYear,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MichelinAwardImpl;

  factory MichelinAward.fromJson(Map<String, dynamic> jsonSerialization) {
    return MichelinAward(
      id: jsonSerialization['id'] as int?,
      restaurantName: jsonSerialization['restaurantName'] as String,
      city: jsonSerialization['city'] as String,
      address: jsonSerialization['address'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      designation: _i2.MichelinDesignation.fromJson(
        (jsonSerialization['designation'] as String),
      ),
      awardYear: jsonSerialization['awardYear'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = MichelinAwardTable();

  static const db = MichelinAwardRepository._();

  @override
  int? id;

  /// Restaurant name as it appears in Michelin Guide.
  String restaurantName;

  /// City where the restaurant is located.
  String city;

  /// Full street address.
  String? address;

  /// Latitude coordinate for location matching.
  double? latitude;

  /// Longitude coordinate for location matching.
  double? longitude;

  /// Michelin designation type.
  _i2.MichelinDesignation designation;

  /// Year the award was given.
  int awardYear;

  /// When the record was created.
  DateTime createdAt;

  /// When the record was last updated.
  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [MichelinAward]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MichelinAward copyWith({
    int? id,
    String? restaurantName,
    String? city,
    String? address,
    double? latitude,
    double? longitude,
    _i2.MichelinDesignation? designation,
    int? awardYear,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MichelinAward',
      if (id != null) 'id': id,
      'restaurantName': restaurantName,
      'city': city,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'designation': designation.toJson(),
      'awardYear': awardYear,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MichelinAward',
      if (id != null) 'id': id,
      'restaurantName': restaurantName,
      'city': city,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'designation': designation.toJson(),
      'awardYear': awardYear,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static MichelinAwardInclude include() {
    return MichelinAwardInclude._();
  }

  static MichelinAwardIncludeList includeList({
    _i1.WhereExpressionBuilder<MichelinAwardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MichelinAwardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MichelinAwardTable>? orderByList,
    MichelinAwardInclude? include,
  }) {
    return MichelinAwardIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MichelinAward.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MichelinAward.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MichelinAwardImpl extends MichelinAward {
  _MichelinAwardImpl({
    int? id,
    required String restaurantName,
    required String city,
    String? address,
    double? latitude,
    double? longitude,
    required _i2.MichelinDesignation designation,
    required int awardYear,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         restaurantName: restaurantName,
         city: city,
         address: address,
         latitude: latitude,
         longitude: longitude,
         designation: designation,
         awardYear: awardYear,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [MichelinAward]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MichelinAward copyWith({
    Object? id = _Undefined,
    String? restaurantName,
    String? city,
    Object? address = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    _i2.MichelinDesignation? designation,
    int? awardYear,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MichelinAward(
      id: id is int? ? id : this.id,
      restaurantName: restaurantName ?? this.restaurantName,
      city: city ?? this.city,
      address: address is String? ? address : this.address,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      designation: designation ?? this.designation,
      awardYear: awardYear ?? this.awardYear,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class MichelinAwardUpdateTable extends _i1.UpdateTable<MichelinAwardTable> {
  MichelinAwardUpdateTable(super.table);

  _i1.ColumnValue<String, String> restaurantName(String value) =>
      _i1.ColumnValue(
        table.restaurantName,
        value,
      );

  _i1.ColumnValue<String, String> city(String value) => _i1.ColumnValue(
    table.city,
    value,
  );

  _i1.ColumnValue<String, String> address(String? value) => _i1.ColumnValue(
    table.address,
    value,
  );

  _i1.ColumnValue<double, double> latitude(double? value) => _i1.ColumnValue(
    table.latitude,
    value,
  );

  _i1.ColumnValue<double, double> longitude(double? value) => _i1.ColumnValue(
    table.longitude,
    value,
  );

  _i1.ColumnValue<_i2.MichelinDesignation, _i2.MichelinDesignation> designation(
    _i2.MichelinDesignation value,
  ) => _i1.ColumnValue(
    table.designation,
    value,
  );

  _i1.ColumnValue<int, int> awardYear(int value) => _i1.ColumnValue(
    table.awardYear,
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

class MichelinAwardTable extends _i1.Table<int?> {
  MichelinAwardTable({super.tableRelation})
    : super(tableName: 'michelin_awards') {
    updateTable = MichelinAwardUpdateTable(this);
    restaurantName = _i1.ColumnString(
      'restaurantName',
      this,
    );
    city = _i1.ColumnString(
      'city',
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
    designation = _i1.ColumnEnum(
      'designation',
      this,
      _i1.EnumSerialization.byName,
    );
    awardYear = _i1.ColumnInt(
      'awardYear',
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

  late final MichelinAwardUpdateTable updateTable;

  /// Restaurant name as it appears in Michelin Guide.
  late final _i1.ColumnString restaurantName;

  /// City where the restaurant is located.
  late final _i1.ColumnString city;

  /// Full street address.
  late final _i1.ColumnString address;

  /// Latitude coordinate for location matching.
  late final _i1.ColumnDouble latitude;

  /// Longitude coordinate for location matching.
  late final _i1.ColumnDouble longitude;

  /// Michelin designation type.
  late final _i1.ColumnEnum<_i2.MichelinDesignation> designation;

  /// Year the award was given.
  late final _i1.ColumnInt awardYear;

  /// When the record was created.
  late final _i1.ColumnDateTime createdAt;

  /// When the record was last updated.
  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    restaurantName,
    city,
    address,
    latitude,
    longitude,
    designation,
    awardYear,
    createdAt,
    updatedAt,
  ];
}

class MichelinAwardInclude extends _i1.IncludeObject {
  MichelinAwardInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => MichelinAward.t;
}

class MichelinAwardIncludeList extends _i1.IncludeList {
  MichelinAwardIncludeList._({
    _i1.WhereExpressionBuilder<MichelinAwardTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MichelinAward.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MichelinAward.t;
}

class MichelinAwardRepository {
  const MichelinAwardRepository._();

  /// Returns a list of [MichelinAward]s matching the given query parameters.
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
  Future<List<MichelinAward>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MichelinAwardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MichelinAwardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MichelinAwardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MichelinAward>(
      where: where?.call(MichelinAward.t),
      orderBy: orderBy?.call(MichelinAward.t),
      orderByList: orderByList?.call(MichelinAward.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [MichelinAward] matching the given query parameters.
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
  Future<MichelinAward?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MichelinAwardTable>? where,
    int? offset,
    _i1.OrderByBuilder<MichelinAwardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MichelinAwardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<MichelinAward>(
      where: where?.call(MichelinAward.t),
      orderBy: orderBy?.call(MichelinAward.t),
      orderByList: orderByList?.call(MichelinAward.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [MichelinAward] by its [id] or null if no such row exists.
  Future<MichelinAward?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<MichelinAward>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [MichelinAward]s in the list and returns the inserted rows.
  ///
  /// The returned [MichelinAward]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<MichelinAward>> insert(
    _i1.Session session,
    List<MichelinAward> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MichelinAward>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [MichelinAward] and returns the inserted row.
  ///
  /// The returned [MichelinAward] will have its `id` field set.
  Future<MichelinAward> insertRow(
    _i1.Session session,
    MichelinAward row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MichelinAward>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MichelinAward]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MichelinAward>> update(
    _i1.Session session,
    List<MichelinAward> rows, {
    _i1.ColumnSelections<MichelinAwardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MichelinAward>(
      rows,
      columns: columns?.call(MichelinAward.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MichelinAward]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MichelinAward> updateRow(
    _i1.Session session,
    MichelinAward row, {
    _i1.ColumnSelections<MichelinAwardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MichelinAward>(
      row,
      columns: columns?.call(MichelinAward.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MichelinAward] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MichelinAward?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<MichelinAwardUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<MichelinAward>(
      id,
      columnValues: columnValues(MichelinAward.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MichelinAward]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<MichelinAward>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<MichelinAwardUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<MichelinAwardTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MichelinAwardTable>? orderBy,
    _i1.OrderByListBuilder<MichelinAwardTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<MichelinAward>(
      columnValues: columnValues(MichelinAward.t.updateTable),
      where: where(MichelinAward.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MichelinAward.t),
      orderByList: orderByList?.call(MichelinAward.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [MichelinAward]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MichelinAward>> delete(
    _i1.Session session,
    List<MichelinAward> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MichelinAward>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MichelinAward].
  Future<MichelinAward> deleteRow(
    _i1.Session session,
    MichelinAward row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MichelinAward>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MichelinAward>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MichelinAwardTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MichelinAward>(
      where: where(MichelinAward.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MichelinAwardTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MichelinAward>(
      where: where?.call(MichelinAward.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
