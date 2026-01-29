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

/// A curated restaurant map like Eater's "Best Tacos in Austin" or "38 Best Restaurants in Chicago 2026".
/// Can be system-generated (Perplexity) or user-created custom maps.
abstract class CuratedMap
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CuratedMap._({
    this.id,
    this.userId,
    required this.isUserCreated,
    required this.cityName,
    this.stateOrRegion,
    required this.country,
    required this.title,
    required this.slug,
    required this.category,
    this.cuisineType,
    required this.shortDescription,
    this.introText,
    this.coverImageUrl,
    required this.restaurantCount,
    required this.lastUpdatedAt,
    required this.createdAt,
    required this.isPublished,
  });

  factory CuratedMap({
    int? id,
    String? userId,
    required bool isUserCreated,
    required String cityName,
    String? stateOrRegion,
    required String country,
    required String title,
    required String slug,
    required String category,
    String? cuisineType,
    required String shortDescription,
    String? introText,
    String? coverImageUrl,
    required int restaurantCount,
    required DateTime lastUpdatedAt,
    required DateTime createdAt,
    required bool isPublished,
  }) = _CuratedMapImpl;

  factory CuratedMap.fromJson(Map<String, dynamic> jsonSerialization) {
    return CuratedMap(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String?,
      isUserCreated: jsonSerialization['isUserCreated'] as bool,
      cityName: jsonSerialization['cityName'] as String,
      stateOrRegion: jsonSerialization['stateOrRegion'] as String?,
      country: jsonSerialization['country'] as String,
      title: jsonSerialization['title'] as String,
      slug: jsonSerialization['slug'] as String,
      category: jsonSerialization['category'] as String,
      cuisineType: jsonSerialization['cuisineType'] as String?,
      shortDescription: jsonSerialization['shortDescription'] as String,
      introText: jsonSerialization['introText'] as String?,
      coverImageUrl: jsonSerialization['coverImageUrl'] as String?,
      restaurantCount: jsonSerialization['restaurantCount'] as int,
      lastUpdatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastUpdatedAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      isPublished: jsonSerialization['isPublished'] as bool,
    );
  }

  static final t = CuratedMapTable();

  static const db = CuratedMapRepository._();

  @override
  int? id;

  /// User ID if this is a user-created map (null for system maps).
  String? userId;

  /// Whether this is a user-created custom map.
  bool isUserCreated;

  /// City this map is for.
  String cityName;

  /// State/region.
  String? stateOrRegion;

  /// Country.
  String country;

  /// Map title (e.g., "Best Tacos in Austin", "Hidden Gems in Chicago").
  String title;

  /// Map slug for URL (e.g., "best-tacos-austin", "hidden-gems-chicago").
  String slug;

  /// Map category (e.g., "best-of", "cuisine", "occasion", "neighborhood").
  String category;

  /// Cuisine type if applicable (e.g., "Mexican", "Japanese").
  String? cuisineType;

  /// Short description for the map listing.
  String shortDescription;

  /// Full editorial intro paragraph written by Perplexity.
  String? introText;

  /// Cover image URL (from one of the restaurants).
  String? coverImageUrl;

  /// Number of restaurants in this map.
  int restaurantCount;

  /// When this map was last updated.
  DateTime lastUpdatedAt;

  /// When this map was created.
  DateTime createdAt;

  /// Whether this map is published/visible.
  bool isPublished;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CuratedMap]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CuratedMap copyWith({
    int? id,
    String? userId,
    bool? isUserCreated,
    String? cityName,
    String? stateOrRegion,
    String? country,
    String? title,
    String? slug,
    String? category,
    String? cuisineType,
    String? shortDescription,
    String? introText,
    String? coverImageUrl,
    int? restaurantCount,
    DateTime? lastUpdatedAt,
    DateTime? createdAt,
    bool? isPublished,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CuratedMap',
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      'isUserCreated': isUserCreated,
      'cityName': cityName,
      if (stateOrRegion != null) 'stateOrRegion': stateOrRegion,
      'country': country,
      'title': title,
      'slug': slug,
      'category': category,
      if (cuisineType != null) 'cuisineType': cuisineType,
      'shortDescription': shortDescription,
      if (introText != null) 'introText': introText,
      if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,
      'restaurantCount': restaurantCount,
      'lastUpdatedAt': lastUpdatedAt.toJson(),
      'createdAt': createdAt.toJson(),
      'isPublished': isPublished,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CuratedMap',
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      'isUserCreated': isUserCreated,
      'cityName': cityName,
      if (stateOrRegion != null) 'stateOrRegion': stateOrRegion,
      'country': country,
      'title': title,
      'slug': slug,
      'category': category,
      if (cuisineType != null) 'cuisineType': cuisineType,
      'shortDescription': shortDescription,
      if (introText != null) 'introText': introText,
      if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,
      'restaurantCount': restaurantCount,
      'lastUpdatedAt': lastUpdatedAt.toJson(),
      'createdAt': createdAt.toJson(),
      'isPublished': isPublished,
    };
  }

  static CuratedMapInclude include() {
    return CuratedMapInclude._();
  }

  static CuratedMapIncludeList includeList({
    _i1.WhereExpressionBuilder<CuratedMapTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CuratedMapTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CuratedMapTable>? orderByList,
    CuratedMapInclude? include,
  }) {
    return CuratedMapIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CuratedMap.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CuratedMap.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CuratedMapImpl extends CuratedMap {
  _CuratedMapImpl({
    int? id,
    String? userId,
    required bool isUserCreated,
    required String cityName,
    String? stateOrRegion,
    required String country,
    required String title,
    required String slug,
    required String category,
    String? cuisineType,
    required String shortDescription,
    String? introText,
    String? coverImageUrl,
    required int restaurantCount,
    required DateTime lastUpdatedAt,
    required DateTime createdAt,
    required bool isPublished,
  }) : super._(
         id: id,
         userId: userId,
         isUserCreated: isUserCreated,
         cityName: cityName,
         stateOrRegion: stateOrRegion,
         country: country,
         title: title,
         slug: slug,
         category: category,
         cuisineType: cuisineType,
         shortDescription: shortDescription,
         introText: introText,
         coverImageUrl: coverImageUrl,
         restaurantCount: restaurantCount,
         lastUpdatedAt: lastUpdatedAt,
         createdAt: createdAt,
         isPublished: isPublished,
       );

  /// Returns a shallow copy of this [CuratedMap]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CuratedMap copyWith({
    Object? id = _Undefined,
    Object? userId = _Undefined,
    bool? isUserCreated,
    String? cityName,
    Object? stateOrRegion = _Undefined,
    String? country,
    String? title,
    String? slug,
    String? category,
    Object? cuisineType = _Undefined,
    String? shortDescription,
    Object? introText = _Undefined,
    Object? coverImageUrl = _Undefined,
    int? restaurantCount,
    DateTime? lastUpdatedAt,
    DateTime? createdAt,
    bool? isPublished,
  }) {
    return CuratedMap(
      id: id is int? ? id : this.id,
      userId: userId is String? ? userId : this.userId,
      isUserCreated: isUserCreated ?? this.isUserCreated,
      cityName: cityName ?? this.cityName,
      stateOrRegion: stateOrRegion is String?
          ? stateOrRegion
          : this.stateOrRegion,
      country: country ?? this.country,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      category: category ?? this.category,
      cuisineType: cuisineType is String? ? cuisineType : this.cuisineType,
      shortDescription: shortDescription ?? this.shortDescription,
      introText: introText is String? ? introText : this.introText,
      coverImageUrl: coverImageUrl is String?
          ? coverImageUrl
          : this.coverImageUrl,
      restaurantCount: restaurantCount ?? this.restaurantCount,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      createdAt: createdAt ?? this.createdAt,
      isPublished: isPublished ?? this.isPublished,
    );
  }
}

class CuratedMapUpdateTable extends _i1.UpdateTable<CuratedMapTable> {
  CuratedMapUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String? value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<bool, bool> isUserCreated(bool value) => _i1.ColumnValue(
    table.isUserCreated,
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

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> slug(String value) => _i1.ColumnValue(
    table.slug,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<String, String> cuisineType(String? value) => _i1.ColumnValue(
    table.cuisineType,
    value,
  );

  _i1.ColumnValue<String, String> shortDescription(String value) =>
      _i1.ColumnValue(
        table.shortDescription,
        value,
      );

  _i1.ColumnValue<String, String> introText(String? value) => _i1.ColumnValue(
    table.introText,
    value,
  );

  _i1.ColumnValue<String, String> coverImageUrl(String? value) =>
      _i1.ColumnValue(
        table.coverImageUrl,
        value,
      );

  _i1.ColumnValue<int, int> restaurantCount(int value) => _i1.ColumnValue(
    table.restaurantCount,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastUpdatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.lastUpdatedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<bool, bool> isPublished(bool value) => _i1.ColumnValue(
    table.isPublished,
    value,
  );
}

class CuratedMapTable extends _i1.Table<int?> {
  CuratedMapTable({super.tableRelation}) : super(tableName: 'curated_maps') {
    updateTable = CuratedMapUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    isUserCreated = _i1.ColumnBool(
      'isUserCreated',
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
    title = _i1.ColumnString(
      'title',
      this,
    );
    slug = _i1.ColumnString(
      'slug',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    cuisineType = _i1.ColumnString(
      'cuisineType',
      this,
    );
    shortDescription = _i1.ColumnString(
      'shortDescription',
      this,
    );
    introText = _i1.ColumnString(
      'introText',
      this,
    );
    coverImageUrl = _i1.ColumnString(
      'coverImageUrl',
      this,
    );
    restaurantCount = _i1.ColumnInt(
      'restaurantCount',
      this,
    );
    lastUpdatedAt = _i1.ColumnDateTime(
      'lastUpdatedAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    isPublished = _i1.ColumnBool(
      'isPublished',
      this,
    );
  }

  late final CuratedMapUpdateTable updateTable;

  /// User ID if this is a user-created map (null for system maps).
  late final _i1.ColumnString userId;

  /// Whether this is a user-created custom map.
  late final _i1.ColumnBool isUserCreated;

  /// City this map is for.
  late final _i1.ColumnString cityName;

  /// State/region.
  late final _i1.ColumnString stateOrRegion;

  /// Country.
  late final _i1.ColumnString country;

  /// Map title (e.g., "Best Tacos in Austin", "Hidden Gems in Chicago").
  late final _i1.ColumnString title;

  /// Map slug for URL (e.g., "best-tacos-austin", "hidden-gems-chicago").
  late final _i1.ColumnString slug;

  /// Map category (e.g., "best-of", "cuisine", "occasion", "neighborhood").
  late final _i1.ColumnString category;

  /// Cuisine type if applicable (e.g., "Mexican", "Japanese").
  late final _i1.ColumnString cuisineType;

  /// Short description for the map listing.
  late final _i1.ColumnString shortDescription;

  /// Full editorial intro paragraph written by Perplexity.
  late final _i1.ColumnString introText;

  /// Cover image URL (from one of the restaurants).
  late final _i1.ColumnString coverImageUrl;

  /// Number of restaurants in this map.
  late final _i1.ColumnInt restaurantCount;

  /// When this map was last updated.
  late final _i1.ColumnDateTime lastUpdatedAt;

  /// When this map was created.
  late final _i1.ColumnDateTime createdAt;

  /// Whether this map is published/visible.
  late final _i1.ColumnBool isPublished;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    isUserCreated,
    cityName,
    stateOrRegion,
    country,
    title,
    slug,
    category,
    cuisineType,
    shortDescription,
    introText,
    coverImageUrl,
    restaurantCount,
    lastUpdatedAt,
    createdAt,
    isPublished,
  ];
}

class CuratedMapInclude extends _i1.IncludeObject {
  CuratedMapInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CuratedMap.t;
}

class CuratedMapIncludeList extends _i1.IncludeList {
  CuratedMapIncludeList._({
    _i1.WhereExpressionBuilder<CuratedMapTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CuratedMap.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CuratedMap.t;
}

class CuratedMapRepository {
  const CuratedMapRepository._();

  /// Returns a list of [CuratedMap]s matching the given query parameters.
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
  Future<List<CuratedMap>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CuratedMapTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CuratedMapTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CuratedMapTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CuratedMap>(
      where: where?.call(CuratedMap.t),
      orderBy: orderBy?.call(CuratedMap.t),
      orderByList: orderByList?.call(CuratedMap.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CuratedMap] matching the given query parameters.
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
  Future<CuratedMap?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CuratedMapTable>? where,
    int? offset,
    _i1.OrderByBuilder<CuratedMapTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CuratedMapTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CuratedMap>(
      where: where?.call(CuratedMap.t),
      orderBy: orderBy?.call(CuratedMap.t),
      orderByList: orderByList?.call(CuratedMap.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CuratedMap] by its [id] or null if no such row exists.
  Future<CuratedMap?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CuratedMap>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CuratedMap]s in the list and returns the inserted rows.
  ///
  /// The returned [CuratedMap]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CuratedMap>> insert(
    _i1.Session session,
    List<CuratedMap> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CuratedMap>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CuratedMap] and returns the inserted row.
  ///
  /// The returned [CuratedMap] will have its `id` field set.
  Future<CuratedMap> insertRow(
    _i1.Session session,
    CuratedMap row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CuratedMap>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CuratedMap]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CuratedMap>> update(
    _i1.Session session,
    List<CuratedMap> rows, {
    _i1.ColumnSelections<CuratedMapTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CuratedMap>(
      rows,
      columns: columns?.call(CuratedMap.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CuratedMap]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CuratedMap> updateRow(
    _i1.Session session,
    CuratedMap row, {
    _i1.ColumnSelections<CuratedMapTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CuratedMap>(
      row,
      columns: columns?.call(CuratedMap.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CuratedMap] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CuratedMap?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<CuratedMapUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CuratedMap>(
      id,
      columnValues: columnValues(CuratedMap.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CuratedMap]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CuratedMap>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CuratedMapUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CuratedMapTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CuratedMapTable>? orderBy,
    _i1.OrderByListBuilder<CuratedMapTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CuratedMap>(
      columnValues: columnValues(CuratedMap.t.updateTable),
      where: where(CuratedMap.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CuratedMap.t),
      orderByList: orderByList?.call(CuratedMap.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CuratedMap]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CuratedMap>> delete(
    _i1.Session session,
    List<CuratedMap> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CuratedMap>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CuratedMap].
  Future<CuratedMap> deleteRow(
    _i1.Session session,
    CuratedMap row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CuratedMap>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CuratedMap>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CuratedMapTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CuratedMap>(
      where: where(CuratedMap.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CuratedMapTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CuratedMap>(
      where: where?.call(CuratedMap.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
