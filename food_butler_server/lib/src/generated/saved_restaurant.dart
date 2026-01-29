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
import 'saved_restaurant_source.dart' as _i2;

/// A restaurant saved/bookmarked by the user.
///
/// Allows users to save restaurants from maps, Ask the Butler,
/// or stories for later reference.
abstract class SavedRestaurant
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SavedRestaurant._({
    this.id,
    required this.userId,
    required this.name,
    this.placeId,
    this.address,
    this.cuisineType,
    this.imageUrl,
    this.rating,
    this.priceLevel,
    this.notes,
    this.userRating,
    required this.source,
    required this.savedAt,
  });

  factory SavedRestaurant({
    int? id,
    required String userId,
    required String name,
    String? placeId,
    String? address,
    String? cuisineType,
    String? imageUrl,
    double? rating,
    int? priceLevel,
    String? notes,
    int? userRating,
    required _i2.SavedRestaurantSource source,
    required DateTime savedAt,
  }) = _SavedRestaurantImpl;

  factory SavedRestaurant.fromJson(Map<String, dynamic> jsonSerialization) {
    return SavedRestaurant(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      name: jsonSerialization['name'] as String,
      placeId: jsonSerialization['placeId'] as String?,
      address: jsonSerialization['address'] as String?,
      cuisineType: jsonSerialization['cuisineType'] as String?,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      priceLevel: jsonSerialization['priceLevel'] as int?,
      notes: jsonSerialization['notes'] as String?,
      userRating: jsonSerialization['userRating'] as int?,
      source: _i2.SavedRestaurantSource.fromJson(
        (jsonSerialization['source'] as String),
      ),
      savedAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['savedAt']),
    );
  }

  static final t = SavedRestaurantTable();

  static const db = SavedRestaurantRepository._();

  @override
  int? id;

  /// The user who saved this restaurant.
  String userId;

  /// Restaurant name.
  String name;

  /// Google Place ID for looking up details.
  String? placeId;

  /// Restaurant address.
  String? address;

  /// Type of cuisine.
  String? cuisineType;

  /// Photo URL.
  String? imageUrl;

  /// Google rating (0-5).
  double? rating;

  /// Price level (1-4).
  int? priceLevel;

  /// User's personal notes about this restaurant.
  String? notes;

  /// User's personal rating (1-5 stars).
  int? userRating;

  /// Where the restaurant was saved from.
  _i2.SavedRestaurantSource source;

  /// When it was saved.
  DateTime savedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SavedRestaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SavedRestaurant copyWith({
    int? id,
    String? userId,
    String? name,
    String? placeId,
    String? address,
    String? cuisineType,
    String? imageUrl,
    double? rating,
    int? priceLevel,
    String? notes,
    int? userRating,
    _i2.SavedRestaurantSource? source,
    DateTime? savedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SavedRestaurant',
      if (id != null) 'id': id,
      'userId': userId,
      'name': name,
      if (placeId != null) 'placeId': placeId,
      if (address != null) 'address': address,
      if (cuisineType != null) 'cuisineType': cuisineType,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (rating != null) 'rating': rating,
      if (priceLevel != null) 'priceLevel': priceLevel,
      if (notes != null) 'notes': notes,
      if (userRating != null) 'userRating': userRating,
      'source': source.toJson(),
      'savedAt': savedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SavedRestaurant',
      if (id != null) 'id': id,
      'userId': userId,
      'name': name,
      if (placeId != null) 'placeId': placeId,
      if (address != null) 'address': address,
      if (cuisineType != null) 'cuisineType': cuisineType,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (rating != null) 'rating': rating,
      if (priceLevel != null) 'priceLevel': priceLevel,
      if (notes != null) 'notes': notes,
      if (userRating != null) 'userRating': userRating,
      'source': source.toJson(),
      'savedAt': savedAt.toJson(),
    };
  }

  static SavedRestaurantInclude include() {
    return SavedRestaurantInclude._();
  }

  static SavedRestaurantIncludeList includeList({
    _i1.WhereExpressionBuilder<SavedRestaurantTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SavedRestaurantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SavedRestaurantTable>? orderByList,
    SavedRestaurantInclude? include,
  }) {
    return SavedRestaurantIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SavedRestaurant.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SavedRestaurant.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SavedRestaurantImpl extends SavedRestaurant {
  _SavedRestaurantImpl({
    int? id,
    required String userId,
    required String name,
    String? placeId,
    String? address,
    String? cuisineType,
    String? imageUrl,
    double? rating,
    int? priceLevel,
    String? notes,
    int? userRating,
    required _i2.SavedRestaurantSource source,
    required DateTime savedAt,
  }) : super._(
         id: id,
         userId: userId,
         name: name,
         placeId: placeId,
         address: address,
         cuisineType: cuisineType,
         imageUrl: imageUrl,
         rating: rating,
         priceLevel: priceLevel,
         notes: notes,
         userRating: userRating,
         source: source,
         savedAt: savedAt,
       );

  /// Returns a shallow copy of this [SavedRestaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SavedRestaurant copyWith({
    Object? id = _Undefined,
    String? userId,
    String? name,
    Object? placeId = _Undefined,
    Object? address = _Undefined,
    Object? cuisineType = _Undefined,
    Object? imageUrl = _Undefined,
    Object? rating = _Undefined,
    Object? priceLevel = _Undefined,
    Object? notes = _Undefined,
    Object? userRating = _Undefined,
    _i2.SavedRestaurantSource? source,
    DateTime? savedAt,
  }) {
    return SavedRestaurant(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      placeId: placeId is String? ? placeId : this.placeId,
      address: address is String? ? address : this.address,
      cuisineType: cuisineType is String? ? cuisineType : this.cuisineType,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      rating: rating is double? ? rating : this.rating,
      priceLevel: priceLevel is int? ? priceLevel : this.priceLevel,
      notes: notes is String? ? notes : this.notes,
      userRating: userRating is int? ? userRating : this.userRating,
      source: source ?? this.source,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}

class SavedRestaurantUpdateTable extends _i1.UpdateTable<SavedRestaurantTable> {
  SavedRestaurantUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> placeId(String? value) => _i1.ColumnValue(
    table.placeId,
    value,
  );

  _i1.ColumnValue<String, String> address(String? value) => _i1.ColumnValue(
    table.address,
    value,
  );

  _i1.ColumnValue<String, String> cuisineType(String? value) => _i1.ColumnValue(
    table.cuisineType,
    value,
  );

  _i1.ColumnValue<String, String> imageUrl(String? value) => _i1.ColumnValue(
    table.imageUrl,
    value,
  );

  _i1.ColumnValue<double, double> rating(double? value) => _i1.ColumnValue(
    table.rating,
    value,
  );

  _i1.ColumnValue<int, int> priceLevel(int? value) => _i1.ColumnValue(
    table.priceLevel,
    value,
  );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
    value,
  );

  _i1.ColumnValue<int, int> userRating(int? value) => _i1.ColumnValue(
    table.userRating,
    value,
  );

  _i1.ColumnValue<_i2.SavedRestaurantSource, _i2.SavedRestaurantSource> source(
    _i2.SavedRestaurantSource value,
  ) => _i1.ColumnValue(
    table.source,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> savedAt(DateTime value) =>
      _i1.ColumnValue(
        table.savedAt,
        value,
      );
}

class SavedRestaurantTable extends _i1.Table<int?> {
  SavedRestaurantTable({super.tableRelation})
    : super(tableName: 'saved_restaurants') {
    updateTable = SavedRestaurantUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    placeId = _i1.ColumnString(
      'placeId',
      this,
    );
    address = _i1.ColumnString(
      'address',
      this,
    );
    cuisineType = _i1.ColumnString(
      'cuisineType',
      this,
    );
    imageUrl = _i1.ColumnString(
      'imageUrl',
      this,
    );
    rating = _i1.ColumnDouble(
      'rating',
      this,
    );
    priceLevel = _i1.ColumnInt(
      'priceLevel',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
      this,
    );
    userRating = _i1.ColumnInt(
      'userRating',
      this,
    );
    source = _i1.ColumnEnum(
      'source',
      this,
      _i1.EnumSerialization.byName,
    );
    savedAt = _i1.ColumnDateTime(
      'savedAt',
      this,
    );
  }

  late final SavedRestaurantUpdateTable updateTable;

  /// The user who saved this restaurant.
  late final _i1.ColumnString userId;

  /// Restaurant name.
  late final _i1.ColumnString name;

  /// Google Place ID for looking up details.
  late final _i1.ColumnString placeId;

  /// Restaurant address.
  late final _i1.ColumnString address;

  /// Type of cuisine.
  late final _i1.ColumnString cuisineType;

  /// Photo URL.
  late final _i1.ColumnString imageUrl;

  /// Google rating (0-5).
  late final _i1.ColumnDouble rating;

  /// Price level (1-4).
  late final _i1.ColumnInt priceLevel;

  /// User's personal notes about this restaurant.
  late final _i1.ColumnString notes;

  /// User's personal rating (1-5 stars).
  late final _i1.ColumnInt userRating;

  /// Where the restaurant was saved from.
  late final _i1.ColumnEnum<_i2.SavedRestaurantSource> source;

  /// When it was saved.
  late final _i1.ColumnDateTime savedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    name,
    placeId,
    address,
    cuisineType,
    imageUrl,
    rating,
    priceLevel,
    notes,
    userRating,
    source,
    savedAt,
  ];
}

class SavedRestaurantInclude extends _i1.IncludeObject {
  SavedRestaurantInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SavedRestaurant.t;
}

class SavedRestaurantIncludeList extends _i1.IncludeList {
  SavedRestaurantIncludeList._({
    _i1.WhereExpressionBuilder<SavedRestaurantTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SavedRestaurant.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SavedRestaurant.t;
}

class SavedRestaurantRepository {
  const SavedRestaurantRepository._();

  /// Returns a list of [SavedRestaurant]s matching the given query parameters.
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
  Future<List<SavedRestaurant>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SavedRestaurantTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SavedRestaurantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SavedRestaurantTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SavedRestaurant>(
      where: where?.call(SavedRestaurant.t),
      orderBy: orderBy?.call(SavedRestaurant.t),
      orderByList: orderByList?.call(SavedRestaurant.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [SavedRestaurant] matching the given query parameters.
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
  Future<SavedRestaurant?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SavedRestaurantTable>? where,
    int? offset,
    _i1.OrderByBuilder<SavedRestaurantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SavedRestaurantTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<SavedRestaurant>(
      where: where?.call(SavedRestaurant.t),
      orderBy: orderBy?.call(SavedRestaurant.t),
      orderByList: orderByList?.call(SavedRestaurant.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [SavedRestaurant] by its [id] or null if no such row exists.
  Future<SavedRestaurant?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<SavedRestaurant>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [SavedRestaurant]s in the list and returns the inserted rows.
  ///
  /// The returned [SavedRestaurant]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SavedRestaurant>> insert(
    _i1.Session session,
    List<SavedRestaurant> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SavedRestaurant>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SavedRestaurant] and returns the inserted row.
  ///
  /// The returned [SavedRestaurant] will have its `id` field set.
  Future<SavedRestaurant> insertRow(
    _i1.Session session,
    SavedRestaurant row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SavedRestaurant>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SavedRestaurant]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SavedRestaurant>> update(
    _i1.Session session,
    List<SavedRestaurant> rows, {
    _i1.ColumnSelections<SavedRestaurantTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SavedRestaurant>(
      rows,
      columns: columns?.call(SavedRestaurant.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SavedRestaurant]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SavedRestaurant> updateRow(
    _i1.Session session,
    SavedRestaurant row, {
    _i1.ColumnSelections<SavedRestaurantTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SavedRestaurant>(
      row,
      columns: columns?.call(SavedRestaurant.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SavedRestaurant] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SavedRestaurant?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<SavedRestaurantUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SavedRestaurant>(
      id,
      columnValues: columnValues(SavedRestaurant.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SavedRestaurant]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SavedRestaurant>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SavedRestaurantUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<SavedRestaurantTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SavedRestaurantTable>? orderBy,
    _i1.OrderByListBuilder<SavedRestaurantTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SavedRestaurant>(
      columnValues: columnValues(SavedRestaurant.t.updateTable),
      where: where(SavedRestaurant.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SavedRestaurant.t),
      orderByList: orderByList?.call(SavedRestaurant.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SavedRestaurant]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SavedRestaurant>> delete(
    _i1.Session session,
    List<SavedRestaurant> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SavedRestaurant>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SavedRestaurant].
  Future<SavedRestaurant> deleteRow(
    _i1.Session session,
    SavedRestaurant row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SavedRestaurant>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SavedRestaurant>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SavedRestaurantTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SavedRestaurant>(
      where: where(SavedRestaurant.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SavedRestaurantTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SavedRestaurant>(
      where: where?.call(SavedRestaurant.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
