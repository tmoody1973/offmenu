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
import '../daily/daily_story_type.dart' as _i2;

/// Personalized daily story for a user.
/// Generated once per day based on user profile and preferences.
abstract class DailyStory
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  DailyStory._({
    this.id,
    required this.userId,
    required this.storyDate,
    required this.city,
    this.state,
    this.country,
    required this.headline,
    required this.subheadline,
    this.bodyText,
    required this.restaurantName,
    this.restaurantAddress,
    this.restaurantPlaceId,
    required this.heroImageUrl,
    this.thumbnailUrl,
    required this.storyType,
    this.cuisineType,
    this.sourceUrl,
    required this.createdAt,
  });

  factory DailyStory({
    int? id,
    required String userId,
    required String storyDate,
    required String city,
    String? state,
    String? country,
    required String headline,
    required String subheadline,
    String? bodyText,
    required String restaurantName,
    String? restaurantAddress,
    String? restaurantPlaceId,
    required String heroImageUrl,
    String? thumbnailUrl,
    required _i2.DailyStoryType storyType,
    String? cuisineType,
    String? sourceUrl,
    required DateTime createdAt,
  }) = _DailyStoryImpl;

  factory DailyStory.fromJson(Map<String, dynamic> jsonSerialization) {
    return DailyStory(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      storyDate: jsonSerialization['storyDate'] as String,
      city: jsonSerialization['city'] as String,
      state: jsonSerialization['state'] as String?,
      country: jsonSerialization['country'] as String?,
      headline: jsonSerialization['headline'] as String,
      subheadline: jsonSerialization['subheadline'] as String,
      bodyText: jsonSerialization['bodyText'] as String?,
      restaurantName: jsonSerialization['restaurantName'] as String,
      restaurantAddress: jsonSerialization['restaurantAddress'] as String?,
      restaurantPlaceId: jsonSerialization['restaurantPlaceId'] as String?,
      heroImageUrl: jsonSerialization['heroImageUrl'] as String,
      thumbnailUrl: jsonSerialization['thumbnailUrl'] as String?,
      storyType: _i2.DailyStoryType.fromJson(
        (jsonSerialization['storyType'] as String),
      ),
      cuisineType: jsonSerialization['cuisineType'] as String?,
      sourceUrl: jsonSerialization['sourceUrl'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = DailyStoryTable();

  static const db = DailyStoryRepository._();

  @override
  int? id;

  /// User ID this story is for.
  String userId;

  /// Date this story is for (YYYY-MM-DD format).
  String storyDate;

  /// City the story is about.
  String city;

  /// State/region of the city.
  String? state;

  /// Country of the city.
  String? country;

  /// Compelling headline (magazine style, 8-15 words).
  String headline;

  /// 1-2 sentence teaser that hooks the reader.
  String subheadline;

  /// Full story text (2-3 paragraphs, optional).
  String? bodyText;

  /// Name of the featured restaurant.
  String restaurantName;

  /// Restaurant street address.
  String? restaurantAddress;

  /// Google Places ID for the restaurant.
  String? restaurantPlaceId;

  /// Hero image URL (proxied through our server).
  String heroImageUrl;

  /// Thumbnail image URL.
  String? thumbnailUrl;

  /// Type of story (hidden gem, legacy, etc).
  _i2.DailyStoryType storyType;

  /// Cuisine type featured in the story.
  String? cuisineType;

  /// Source URL for attribution/citation.
  String? sourceUrl;

  /// When this story was generated.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [DailyStory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DailyStory copyWith({
    int? id,
    String? userId,
    String? storyDate,
    String? city,
    String? state,
    String? country,
    String? headline,
    String? subheadline,
    String? bodyText,
    String? restaurantName,
    String? restaurantAddress,
    String? restaurantPlaceId,
    String? heroImageUrl,
    String? thumbnailUrl,
    _i2.DailyStoryType? storyType,
    String? cuisineType,
    String? sourceUrl,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailyStory',
      if (id != null) 'id': id,
      'userId': userId,
      'storyDate': storyDate,
      'city': city,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
      'headline': headline,
      'subheadline': subheadline,
      if (bodyText != null) 'bodyText': bodyText,
      'restaurantName': restaurantName,
      if (restaurantAddress != null) 'restaurantAddress': restaurantAddress,
      if (restaurantPlaceId != null) 'restaurantPlaceId': restaurantPlaceId,
      'heroImageUrl': heroImageUrl,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      'storyType': storyType.toJson(),
      if (cuisineType != null) 'cuisineType': cuisineType,
      if (sourceUrl != null) 'sourceUrl': sourceUrl,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DailyStory',
      if (id != null) 'id': id,
      'userId': userId,
      'storyDate': storyDate,
      'city': city,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
      'headline': headline,
      'subheadline': subheadline,
      if (bodyText != null) 'bodyText': bodyText,
      'restaurantName': restaurantName,
      if (restaurantAddress != null) 'restaurantAddress': restaurantAddress,
      if (restaurantPlaceId != null) 'restaurantPlaceId': restaurantPlaceId,
      'heroImageUrl': heroImageUrl,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      'storyType': storyType.toJson(),
      if (cuisineType != null) 'cuisineType': cuisineType,
      if (sourceUrl != null) 'sourceUrl': sourceUrl,
      'createdAt': createdAt.toJson(),
    };
  }

  static DailyStoryInclude include() {
    return DailyStoryInclude._();
  }

  static DailyStoryIncludeList includeList({
    _i1.WhereExpressionBuilder<DailyStoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DailyStoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DailyStoryTable>? orderByList,
    DailyStoryInclude? include,
  }) {
    return DailyStoryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DailyStory.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DailyStory.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DailyStoryImpl extends DailyStory {
  _DailyStoryImpl({
    int? id,
    required String userId,
    required String storyDate,
    required String city,
    String? state,
    String? country,
    required String headline,
    required String subheadline,
    String? bodyText,
    required String restaurantName,
    String? restaurantAddress,
    String? restaurantPlaceId,
    required String heroImageUrl,
    String? thumbnailUrl,
    required _i2.DailyStoryType storyType,
    String? cuisineType,
    String? sourceUrl,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         storyDate: storyDate,
         city: city,
         state: state,
         country: country,
         headline: headline,
         subheadline: subheadline,
         bodyText: bodyText,
         restaurantName: restaurantName,
         restaurantAddress: restaurantAddress,
         restaurantPlaceId: restaurantPlaceId,
         heroImageUrl: heroImageUrl,
         thumbnailUrl: thumbnailUrl,
         storyType: storyType,
         cuisineType: cuisineType,
         sourceUrl: sourceUrl,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DailyStory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DailyStory copyWith({
    Object? id = _Undefined,
    String? userId,
    String? storyDate,
    String? city,
    Object? state = _Undefined,
    Object? country = _Undefined,
    String? headline,
    String? subheadline,
    Object? bodyText = _Undefined,
    String? restaurantName,
    Object? restaurantAddress = _Undefined,
    Object? restaurantPlaceId = _Undefined,
    String? heroImageUrl,
    Object? thumbnailUrl = _Undefined,
    _i2.DailyStoryType? storyType,
    Object? cuisineType = _Undefined,
    Object? sourceUrl = _Undefined,
    DateTime? createdAt,
  }) {
    return DailyStory(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      storyDate: storyDate ?? this.storyDate,
      city: city ?? this.city,
      state: state is String? ? state : this.state,
      country: country is String? ? country : this.country,
      headline: headline ?? this.headline,
      subheadline: subheadline ?? this.subheadline,
      bodyText: bodyText is String? ? bodyText : this.bodyText,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantAddress: restaurantAddress is String?
          ? restaurantAddress
          : this.restaurantAddress,
      restaurantPlaceId: restaurantPlaceId is String?
          ? restaurantPlaceId
          : this.restaurantPlaceId,
      heroImageUrl: heroImageUrl ?? this.heroImageUrl,
      thumbnailUrl: thumbnailUrl is String? ? thumbnailUrl : this.thumbnailUrl,
      storyType: storyType ?? this.storyType,
      cuisineType: cuisineType is String? ? cuisineType : this.cuisineType,
      sourceUrl: sourceUrl is String? ? sourceUrl : this.sourceUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DailyStoryUpdateTable extends _i1.UpdateTable<DailyStoryTable> {
  DailyStoryUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> storyDate(String value) => _i1.ColumnValue(
    table.storyDate,
    value,
  );

  _i1.ColumnValue<String, String> city(String value) => _i1.ColumnValue(
    table.city,
    value,
  );

  _i1.ColumnValue<String, String> state(String? value) => _i1.ColumnValue(
    table.state,
    value,
  );

  _i1.ColumnValue<String, String> country(String? value) => _i1.ColumnValue(
    table.country,
    value,
  );

  _i1.ColumnValue<String, String> headline(String value) => _i1.ColumnValue(
    table.headline,
    value,
  );

  _i1.ColumnValue<String, String> subheadline(String value) => _i1.ColumnValue(
    table.subheadline,
    value,
  );

  _i1.ColumnValue<String, String> bodyText(String? value) => _i1.ColumnValue(
    table.bodyText,
    value,
  );

  _i1.ColumnValue<String, String> restaurantName(String value) =>
      _i1.ColumnValue(
        table.restaurantName,
        value,
      );

  _i1.ColumnValue<String, String> restaurantAddress(String? value) =>
      _i1.ColumnValue(
        table.restaurantAddress,
        value,
      );

  _i1.ColumnValue<String, String> restaurantPlaceId(String? value) =>
      _i1.ColumnValue(
        table.restaurantPlaceId,
        value,
      );

  _i1.ColumnValue<String, String> heroImageUrl(String value) => _i1.ColumnValue(
    table.heroImageUrl,
    value,
  );

  _i1.ColumnValue<String, String> thumbnailUrl(String? value) =>
      _i1.ColumnValue(
        table.thumbnailUrl,
        value,
      );

  _i1.ColumnValue<_i2.DailyStoryType, _i2.DailyStoryType> storyType(
    _i2.DailyStoryType value,
  ) => _i1.ColumnValue(
    table.storyType,
    value,
  );

  _i1.ColumnValue<String, String> cuisineType(String? value) => _i1.ColumnValue(
    table.cuisineType,
    value,
  );

  _i1.ColumnValue<String, String> sourceUrl(String? value) => _i1.ColumnValue(
    table.sourceUrl,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class DailyStoryTable extends _i1.Table<int?> {
  DailyStoryTable({super.tableRelation}) : super(tableName: 'daily_stories') {
    updateTable = DailyStoryUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    storyDate = _i1.ColumnString(
      'storyDate',
      this,
    );
    city = _i1.ColumnString(
      'city',
      this,
    );
    state = _i1.ColumnString(
      'state',
      this,
    );
    country = _i1.ColumnString(
      'country',
      this,
    );
    headline = _i1.ColumnString(
      'headline',
      this,
    );
    subheadline = _i1.ColumnString(
      'subheadline',
      this,
    );
    bodyText = _i1.ColumnString(
      'bodyText',
      this,
    );
    restaurantName = _i1.ColumnString(
      'restaurantName',
      this,
    );
    restaurantAddress = _i1.ColumnString(
      'restaurantAddress',
      this,
    );
    restaurantPlaceId = _i1.ColumnString(
      'restaurantPlaceId',
      this,
    );
    heroImageUrl = _i1.ColumnString(
      'heroImageUrl',
      this,
    );
    thumbnailUrl = _i1.ColumnString(
      'thumbnailUrl',
      this,
    );
    storyType = _i1.ColumnEnum(
      'storyType',
      this,
      _i1.EnumSerialization.byName,
    );
    cuisineType = _i1.ColumnString(
      'cuisineType',
      this,
    );
    sourceUrl = _i1.ColumnString(
      'sourceUrl',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final DailyStoryUpdateTable updateTable;

  /// User ID this story is for.
  late final _i1.ColumnString userId;

  /// Date this story is for (YYYY-MM-DD format).
  late final _i1.ColumnString storyDate;

  /// City the story is about.
  late final _i1.ColumnString city;

  /// State/region of the city.
  late final _i1.ColumnString state;

  /// Country of the city.
  late final _i1.ColumnString country;

  /// Compelling headline (magazine style, 8-15 words).
  late final _i1.ColumnString headline;

  /// 1-2 sentence teaser that hooks the reader.
  late final _i1.ColumnString subheadline;

  /// Full story text (2-3 paragraphs, optional).
  late final _i1.ColumnString bodyText;

  /// Name of the featured restaurant.
  late final _i1.ColumnString restaurantName;

  /// Restaurant street address.
  late final _i1.ColumnString restaurantAddress;

  /// Google Places ID for the restaurant.
  late final _i1.ColumnString restaurantPlaceId;

  /// Hero image URL (proxied through our server).
  late final _i1.ColumnString heroImageUrl;

  /// Thumbnail image URL.
  late final _i1.ColumnString thumbnailUrl;

  /// Type of story (hidden gem, legacy, etc).
  late final _i1.ColumnEnum<_i2.DailyStoryType> storyType;

  /// Cuisine type featured in the story.
  late final _i1.ColumnString cuisineType;

  /// Source URL for attribution/citation.
  late final _i1.ColumnString sourceUrl;

  /// When this story was generated.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    storyDate,
    city,
    state,
    country,
    headline,
    subheadline,
    bodyText,
    restaurantName,
    restaurantAddress,
    restaurantPlaceId,
    heroImageUrl,
    thumbnailUrl,
    storyType,
    cuisineType,
    sourceUrl,
    createdAt,
  ];
}

class DailyStoryInclude extends _i1.IncludeObject {
  DailyStoryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DailyStory.t;
}

class DailyStoryIncludeList extends _i1.IncludeList {
  DailyStoryIncludeList._({
    _i1.WhereExpressionBuilder<DailyStoryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DailyStory.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DailyStory.t;
}

class DailyStoryRepository {
  const DailyStoryRepository._();

  /// Returns a list of [DailyStory]s matching the given query parameters.
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
  Future<List<DailyStory>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DailyStoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DailyStoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DailyStoryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DailyStory>(
      where: where?.call(DailyStory.t),
      orderBy: orderBy?.call(DailyStory.t),
      orderByList: orderByList?.call(DailyStory.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [DailyStory] matching the given query parameters.
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
  Future<DailyStory?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DailyStoryTable>? where,
    int? offset,
    _i1.OrderByBuilder<DailyStoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DailyStoryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<DailyStory>(
      where: where?.call(DailyStory.t),
      orderBy: orderBy?.call(DailyStory.t),
      orderByList: orderByList?.call(DailyStory.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [DailyStory] by its [id] or null if no such row exists.
  Future<DailyStory?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<DailyStory>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [DailyStory]s in the list and returns the inserted rows.
  ///
  /// The returned [DailyStory]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<DailyStory>> insert(
    _i1.Session session,
    List<DailyStory> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<DailyStory>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [DailyStory] and returns the inserted row.
  ///
  /// The returned [DailyStory] will have its `id` field set.
  Future<DailyStory> insertRow(
    _i1.Session session,
    DailyStory row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DailyStory>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DailyStory]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DailyStory>> update(
    _i1.Session session,
    List<DailyStory> rows, {
    _i1.ColumnSelections<DailyStoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DailyStory>(
      rows,
      columns: columns?.call(DailyStory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DailyStory]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DailyStory> updateRow(
    _i1.Session session,
    DailyStory row, {
    _i1.ColumnSelections<DailyStoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DailyStory>(
      row,
      columns: columns?.call(DailyStory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DailyStory] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DailyStory?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<DailyStoryUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DailyStory>(
      id,
      columnValues: columnValues(DailyStory.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DailyStory]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DailyStory>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<DailyStoryUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<DailyStoryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DailyStoryTable>? orderBy,
    _i1.OrderByListBuilder<DailyStoryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DailyStory>(
      columnValues: columnValues(DailyStory.t.updateTable),
      where: where(DailyStory.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DailyStory.t),
      orderByList: orderByList?.call(DailyStory.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DailyStory]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DailyStory>> delete(
    _i1.Session session,
    List<DailyStory> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DailyStory>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DailyStory].
  Future<DailyStory> deleteRow(
    _i1.Session session,
    DailyStory row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DailyStory>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DailyStory>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DailyStoryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DailyStory>(
      where: where(DailyStory.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DailyStoryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DailyStory>(
      where: where?.call(DailyStory.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
