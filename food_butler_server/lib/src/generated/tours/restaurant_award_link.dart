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
import '../tours/award_type.dart' as _i2;
import '../tours/match_status.dart' as _i3;

/// Junction table linking restaurants to their awards.
abstract class RestaurantAwardLink
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RestaurantAwardLink._({
    this.id,
    required this.restaurantId,
    required this.awardType,
    required this.awardId,
    required this.matchConfidenceScore,
    required this.matchStatus,
    this.matchedByUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RestaurantAwardLink({
    int? id,
    required int restaurantId,
    required _i2.AwardType awardType,
    required int awardId,
    required double matchConfidenceScore,
    required _i3.MatchStatus matchStatus,
    int? matchedByUserId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RestaurantAwardLinkImpl;

  factory RestaurantAwardLink.fromJson(Map<String, dynamic> jsonSerialization) {
    return RestaurantAwardLink(
      id: jsonSerialization['id'] as int?,
      restaurantId: jsonSerialization['restaurantId'] as int,
      awardType: _i2.AwardType.fromJson(
        (jsonSerialization['awardType'] as String),
      ),
      awardId: jsonSerialization['awardId'] as int,
      matchConfidenceScore: (jsonSerialization['matchConfidenceScore'] as num)
          .toDouble(),
      matchStatus: _i3.MatchStatus.fromJson(
        (jsonSerialization['matchStatus'] as String),
      ),
      matchedByUserId: jsonSerialization['matchedByUserId'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = RestaurantAwardLinkTable();

  static const db = RestaurantAwardLinkRepository._();

  @override
  int? id;

  /// Reference to the restaurant.
  int restaurantId;

  /// Type of award (michelin or james_beard).
  _i2.AwardType awardType;

  /// Reference to the award record ID.
  int awardId;

  /// Confidence score of the match (0.0 to 1.0).
  double matchConfidenceScore;

  /// Status of the match.
  _i3.MatchStatus matchStatus;

  /// User who confirmed/rejected the match (null for auto matches).
  int? matchedByUserId;

  /// When the record was created.
  DateTime createdAt;

  /// When the record was last updated.
  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RestaurantAwardLink]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RestaurantAwardLink copyWith({
    int? id,
    int? restaurantId,
    _i2.AwardType? awardType,
    int? awardId,
    double? matchConfidenceScore,
    _i3.MatchStatus? matchStatus,
    int? matchedByUserId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RestaurantAwardLink',
      if (id != null) 'id': id,
      'restaurantId': restaurantId,
      'awardType': awardType.toJson(),
      'awardId': awardId,
      'matchConfidenceScore': matchConfidenceScore,
      'matchStatus': matchStatus.toJson(),
      if (matchedByUserId != null) 'matchedByUserId': matchedByUserId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RestaurantAwardLink',
      if (id != null) 'id': id,
      'restaurantId': restaurantId,
      'awardType': awardType.toJson(),
      'awardId': awardId,
      'matchConfidenceScore': matchConfidenceScore,
      'matchStatus': matchStatus.toJson(),
      if (matchedByUserId != null) 'matchedByUserId': matchedByUserId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static RestaurantAwardLinkInclude include() {
    return RestaurantAwardLinkInclude._();
  }

  static RestaurantAwardLinkIncludeList includeList({
    _i1.WhereExpressionBuilder<RestaurantAwardLinkTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RestaurantAwardLinkTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RestaurantAwardLinkTable>? orderByList,
    RestaurantAwardLinkInclude? include,
  }) {
    return RestaurantAwardLinkIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RestaurantAwardLink.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RestaurantAwardLink.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RestaurantAwardLinkImpl extends RestaurantAwardLink {
  _RestaurantAwardLinkImpl({
    int? id,
    required int restaurantId,
    required _i2.AwardType awardType,
    required int awardId,
    required double matchConfidenceScore,
    required _i3.MatchStatus matchStatus,
    int? matchedByUserId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         restaurantId: restaurantId,
         awardType: awardType,
         awardId: awardId,
         matchConfidenceScore: matchConfidenceScore,
         matchStatus: matchStatus,
         matchedByUserId: matchedByUserId,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RestaurantAwardLink]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RestaurantAwardLink copyWith({
    Object? id = _Undefined,
    int? restaurantId,
    _i2.AwardType? awardType,
    int? awardId,
    double? matchConfidenceScore,
    _i3.MatchStatus? matchStatus,
    Object? matchedByUserId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RestaurantAwardLink(
      id: id is int? ? id : this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      awardType: awardType ?? this.awardType,
      awardId: awardId ?? this.awardId,
      matchConfidenceScore: matchConfidenceScore ?? this.matchConfidenceScore,
      matchStatus: matchStatus ?? this.matchStatus,
      matchedByUserId: matchedByUserId is int?
          ? matchedByUserId
          : this.matchedByUserId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RestaurantAwardLinkUpdateTable
    extends _i1.UpdateTable<RestaurantAwardLinkTable> {
  RestaurantAwardLinkUpdateTable(super.table);

  _i1.ColumnValue<int, int> restaurantId(int value) => _i1.ColumnValue(
    table.restaurantId,
    value,
  );

  _i1.ColumnValue<_i2.AwardType, _i2.AwardType> awardType(
    _i2.AwardType value,
  ) => _i1.ColumnValue(
    table.awardType,
    value,
  );

  _i1.ColumnValue<int, int> awardId(int value) => _i1.ColumnValue(
    table.awardId,
    value,
  );

  _i1.ColumnValue<double, double> matchConfidenceScore(double value) =>
      _i1.ColumnValue(
        table.matchConfidenceScore,
        value,
      );

  _i1.ColumnValue<_i3.MatchStatus, _i3.MatchStatus> matchStatus(
    _i3.MatchStatus value,
  ) => _i1.ColumnValue(
    table.matchStatus,
    value,
  );

  _i1.ColumnValue<int, int> matchedByUserId(int? value) => _i1.ColumnValue(
    table.matchedByUserId,
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

class RestaurantAwardLinkTable extends _i1.Table<int?> {
  RestaurantAwardLinkTable({super.tableRelation})
    : super(tableName: 'restaurant_award_links') {
    updateTable = RestaurantAwardLinkUpdateTable(this);
    restaurantId = _i1.ColumnInt(
      'restaurantId',
      this,
    );
    awardType = _i1.ColumnEnum(
      'awardType',
      this,
      _i1.EnumSerialization.byName,
    );
    awardId = _i1.ColumnInt(
      'awardId',
      this,
    );
    matchConfidenceScore = _i1.ColumnDouble(
      'matchConfidenceScore',
      this,
    );
    matchStatus = _i1.ColumnEnum(
      'matchStatus',
      this,
      _i1.EnumSerialization.byName,
    );
    matchedByUserId = _i1.ColumnInt(
      'matchedByUserId',
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

  late final RestaurantAwardLinkUpdateTable updateTable;

  /// Reference to the restaurant.
  late final _i1.ColumnInt restaurantId;

  /// Type of award (michelin or james_beard).
  late final _i1.ColumnEnum<_i2.AwardType> awardType;

  /// Reference to the award record ID.
  late final _i1.ColumnInt awardId;

  /// Confidence score of the match (0.0 to 1.0).
  late final _i1.ColumnDouble matchConfidenceScore;

  /// Status of the match.
  late final _i1.ColumnEnum<_i3.MatchStatus> matchStatus;

  /// User who confirmed/rejected the match (null for auto matches).
  late final _i1.ColumnInt matchedByUserId;

  /// When the record was created.
  late final _i1.ColumnDateTime createdAt;

  /// When the record was last updated.
  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    restaurantId,
    awardType,
    awardId,
    matchConfidenceScore,
    matchStatus,
    matchedByUserId,
    createdAt,
    updatedAt,
  ];
}

class RestaurantAwardLinkInclude extends _i1.IncludeObject {
  RestaurantAwardLinkInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RestaurantAwardLink.t;
}

class RestaurantAwardLinkIncludeList extends _i1.IncludeList {
  RestaurantAwardLinkIncludeList._({
    _i1.WhereExpressionBuilder<RestaurantAwardLinkTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RestaurantAwardLink.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RestaurantAwardLink.t;
}

class RestaurantAwardLinkRepository {
  const RestaurantAwardLinkRepository._();

  /// Returns a list of [RestaurantAwardLink]s matching the given query parameters.
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
  Future<List<RestaurantAwardLink>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RestaurantAwardLinkTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RestaurantAwardLinkTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RestaurantAwardLinkTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<RestaurantAwardLink>(
      where: where?.call(RestaurantAwardLink.t),
      orderBy: orderBy?.call(RestaurantAwardLink.t),
      orderByList: orderByList?.call(RestaurantAwardLink.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [RestaurantAwardLink] matching the given query parameters.
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
  Future<RestaurantAwardLink?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RestaurantAwardLinkTable>? where,
    int? offset,
    _i1.OrderByBuilder<RestaurantAwardLinkTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RestaurantAwardLinkTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<RestaurantAwardLink>(
      where: where?.call(RestaurantAwardLink.t),
      orderBy: orderBy?.call(RestaurantAwardLink.t),
      orderByList: orderByList?.call(RestaurantAwardLink.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [RestaurantAwardLink] by its [id] or null if no such row exists.
  Future<RestaurantAwardLink?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<RestaurantAwardLink>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [RestaurantAwardLink]s in the list and returns the inserted rows.
  ///
  /// The returned [RestaurantAwardLink]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<RestaurantAwardLink>> insert(
    _i1.Session session,
    List<RestaurantAwardLink> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<RestaurantAwardLink>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [RestaurantAwardLink] and returns the inserted row.
  ///
  /// The returned [RestaurantAwardLink] will have its `id` field set.
  Future<RestaurantAwardLink> insertRow(
    _i1.Session session,
    RestaurantAwardLink row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RestaurantAwardLink>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RestaurantAwardLink]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RestaurantAwardLink>> update(
    _i1.Session session,
    List<RestaurantAwardLink> rows, {
    _i1.ColumnSelections<RestaurantAwardLinkTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RestaurantAwardLink>(
      rows,
      columns: columns?.call(RestaurantAwardLink.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RestaurantAwardLink]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RestaurantAwardLink> updateRow(
    _i1.Session session,
    RestaurantAwardLink row, {
    _i1.ColumnSelections<RestaurantAwardLinkTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RestaurantAwardLink>(
      row,
      columns: columns?.call(RestaurantAwardLink.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RestaurantAwardLink] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RestaurantAwardLink?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<RestaurantAwardLinkUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RestaurantAwardLink>(
      id,
      columnValues: columnValues(RestaurantAwardLink.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RestaurantAwardLink]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RestaurantAwardLink>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<RestaurantAwardLinkUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<RestaurantAwardLinkTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RestaurantAwardLinkTable>? orderBy,
    _i1.OrderByListBuilder<RestaurantAwardLinkTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RestaurantAwardLink>(
      columnValues: columnValues(RestaurantAwardLink.t.updateTable),
      where: where(RestaurantAwardLink.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RestaurantAwardLink.t),
      orderByList: orderByList?.call(RestaurantAwardLink.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RestaurantAwardLink]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RestaurantAwardLink>> delete(
    _i1.Session session,
    List<RestaurantAwardLink> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RestaurantAwardLink>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RestaurantAwardLink].
  Future<RestaurantAwardLink> deleteRow(
    _i1.Session session,
    RestaurantAwardLink row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RestaurantAwardLink>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RestaurantAwardLink>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RestaurantAwardLinkTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RestaurantAwardLink>(
      where: where(RestaurantAwardLink.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RestaurantAwardLinkTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RestaurantAwardLink>(
      where: where?.call(RestaurantAwardLink.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
