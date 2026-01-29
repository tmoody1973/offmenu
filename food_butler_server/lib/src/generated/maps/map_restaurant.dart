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

/// A restaurant entry in a curated map with Eater-style editorial description.
abstract class MapRestaurant
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  MapRestaurant._({
    this.id,
    required this.mapId,
    required this.name,
    this.googlePlaceId,
    required this.editorialDescription,
    this.whyNotable,
    this.mustOrderDishes,
    this.priceLevel,
    this.cuisineTypes,
    required this.address,
    required this.city,
    this.stateOrRegion,
    this.postalCode,
    this.phoneNumber,
    this.websiteUrl,
    this.reservationUrl,
    required this.latitude,
    required this.longitude,
    this.primaryPhotoUrl,
    this.additionalPhotosJson,
    this.googleRating,
    this.googleReviewCount,
    required this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MapRestaurant({
    int? id,
    required int mapId,
    required String name,
    String? googlePlaceId,
    required String editorialDescription,
    String? whyNotable,
    String? mustOrderDishes,
    int? priceLevel,
    String? cuisineTypes,
    required String address,
    required String city,
    String? stateOrRegion,
    String? postalCode,
    String? phoneNumber,
    String? websiteUrl,
    String? reservationUrl,
    required double latitude,
    required double longitude,
    String? primaryPhotoUrl,
    String? additionalPhotosJson,
    double? googleRating,
    int? googleReviewCount,
    required int displayOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MapRestaurantImpl;

  factory MapRestaurant.fromJson(Map<String, dynamic> jsonSerialization) {
    return MapRestaurant(
      id: jsonSerialization['id'] as int?,
      mapId: jsonSerialization['mapId'] as int,
      name: jsonSerialization['name'] as String,
      googlePlaceId: jsonSerialization['googlePlaceId'] as String?,
      editorialDescription: jsonSerialization['editorialDescription'] as String,
      whyNotable: jsonSerialization['whyNotable'] as String?,
      mustOrderDishes: jsonSerialization['mustOrderDishes'] as String?,
      priceLevel: jsonSerialization['priceLevel'] as int?,
      cuisineTypes: jsonSerialization['cuisineTypes'] as String?,
      address: jsonSerialization['address'] as String,
      city: jsonSerialization['city'] as String,
      stateOrRegion: jsonSerialization['stateOrRegion'] as String?,
      postalCode: jsonSerialization['postalCode'] as String?,
      phoneNumber: jsonSerialization['phoneNumber'] as String?,
      websiteUrl: jsonSerialization['websiteUrl'] as String?,
      reservationUrl: jsonSerialization['reservationUrl'] as String?,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      primaryPhotoUrl: jsonSerialization['primaryPhotoUrl'] as String?,
      additionalPhotosJson:
          jsonSerialization['additionalPhotosJson'] as String?,
      googleRating: (jsonSerialization['googleRating'] as num?)?.toDouble(),
      googleReviewCount: jsonSerialization['googleReviewCount'] as int?,
      displayOrder: jsonSerialization['displayOrder'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = MapRestaurantTable();

  static const db = MapRestaurantRepository._();

  @override
  int? id;

  /// The curated map this restaurant belongs to.
  int mapId;

  /// Restaurant name.
  String name;

  /// Google Places ID for fetching photos and details.
  String? googlePlaceId;

  /// Editorial description written by Perplexity (Eater-style storytelling).
  String editorialDescription;

  /// Why this restaurant is notable (awards, chef, specialty).
  String? whyNotable;

  /// Signature dishes to order.
  String? mustOrderDishes;

  /// Price range (1-4 dollar signs).
  int? priceLevel;

  /// Cuisine types (comma-separated).
  String? cuisineTypes;

  /// Full street address.
  String address;

  /// City name.
  String city;

  /// State/region.
  String? stateOrRegion;

  /// Postal/ZIP code.
  String? postalCode;

  /// Phone number.
  String? phoneNumber;

  /// Website URL.
  String? websiteUrl;

  /// Reservation link (OpenTable, Resy, etc).
  String? reservationUrl;

  /// Latitude.
  double latitude;

  /// Longitude.
  double longitude;

  /// Primary photo URL from Google Places.
  String? primaryPhotoUrl;

  /// Additional photo URLs (JSON array).
  String? additionalPhotosJson;

  /// Google rating (1-5).
  double? googleRating;

  /// Google review count.
  int? googleReviewCount;

  /// Display order within the map.
  int displayOrder;

  /// When this entry was created.
  DateTime createdAt;

  /// When this entry was last updated.
  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [MapRestaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MapRestaurant copyWith({
    int? id,
    int? mapId,
    String? name,
    String? googlePlaceId,
    String? editorialDescription,
    String? whyNotable,
    String? mustOrderDishes,
    int? priceLevel,
    String? cuisineTypes,
    String? address,
    String? city,
    String? stateOrRegion,
    String? postalCode,
    String? phoneNumber,
    String? websiteUrl,
    String? reservationUrl,
    double? latitude,
    double? longitude,
    String? primaryPhotoUrl,
    String? additionalPhotosJson,
    double? googleRating,
    int? googleReviewCount,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MapRestaurant',
      if (id != null) 'id': id,
      'mapId': mapId,
      'name': name,
      if (googlePlaceId != null) 'googlePlaceId': googlePlaceId,
      'editorialDescription': editorialDescription,
      if (whyNotable != null) 'whyNotable': whyNotable,
      if (mustOrderDishes != null) 'mustOrderDishes': mustOrderDishes,
      if (priceLevel != null) 'priceLevel': priceLevel,
      if (cuisineTypes != null) 'cuisineTypes': cuisineTypes,
      'address': address,
      'city': city,
      if (stateOrRegion != null) 'stateOrRegion': stateOrRegion,
      if (postalCode != null) 'postalCode': postalCode,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (websiteUrl != null) 'websiteUrl': websiteUrl,
      if (reservationUrl != null) 'reservationUrl': reservationUrl,
      'latitude': latitude,
      'longitude': longitude,
      if (primaryPhotoUrl != null) 'primaryPhotoUrl': primaryPhotoUrl,
      if (additionalPhotosJson != null)
        'additionalPhotosJson': additionalPhotosJson,
      if (googleRating != null) 'googleRating': googleRating,
      if (googleReviewCount != null) 'googleReviewCount': googleReviewCount,
      'displayOrder': displayOrder,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MapRestaurant',
      if (id != null) 'id': id,
      'mapId': mapId,
      'name': name,
      if (googlePlaceId != null) 'googlePlaceId': googlePlaceId,
      'editorialDescription': editorialDescription,
      if (whyNotable != null) 'whyNotable': whyNotable,
      if (mustOrderDishes != null) 'mustOrderDishes': mustOrderDishes,
      if (priceLevel != null) 'priceLevel': priceLevel,
      if (cuisineTypes != null) 'cuisineTypes': cuisineTypes,
      'address': address,
      'city': city,
      if (stateOrRegion != null) 'stateOrRegion': stateOrRegion,
      if (postalCode != null) 'postalCode': postalCode,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (websiteUrl != null) 'websiteUrl': websiteUrl,
      if (reservationUrl != null) 'reservationUrl': reservationUrl,
      'latitude': latitude,
      'longitude': longitude,
      if (primaryPhotoUrl != null) 'primaryPhotoUrl': primaryPhotoUrl,
      if (additionalPhotosJson != null)
        'additionalPhotosJson': additionalPhotosJson,
      if (googleRating != null) 'googleRating': googleRating,
      if (googleReviewCount != null) 'googleReviewCount': googleReviewCount,
      'displayOrder': displayOrder,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static MapRestaurantInclude include() {
    return MapRestaurantInclude._();
  }

  static MapRestaurantIncludeList includeList({
    _i1.WhereExpressionBuilder<MapRestaurantTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MapRestaurantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MapRestaurantTable>? orderByList,
    MapRestaurantInclude? include,
  }) {
    return MapRestaurantIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MapRestaurant.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MapRestaurant.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MapRestaurantImpl extends MapRestaurant {
  _MapRestaurantImpl({
    int? id,
    required int mapId,
    required String name,
    String? googlePlaceId,
    required String editorialDescription,
    String? whyNotable,
    String? mustOrderDishes,
    int? priceLevel,
    String? cuisineTypes,
    required String address,
    required String city,
    String? stateOrRegion,
    String? postalCode,
    String? phoneNumber,
    String? websiteUrl,
    String? reservationUrl,
    required double latitude,
    required double longitude,
    String? primaryPhotoUrl,
    String? additionalPhotosJson,
    double? googleRating,
    int? googleReviewCount,
    required int displayOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         mapId: mapId,
         name: name,
         googlePlaceId: googlePlaceId,
         editorialDescription: editorialDescription,
         whyNotable: whyNotable,
         mustOrderDishes: mustOrderDishes,
         priceLevel: priceLevel,
         cuisineTypes: cuisineTypes,
         address: address,
         city: city,
         stateOrRegion: stateOrRegion,
         postalCode: postalCode,
         phoneNumber: phoneNumber,
         websiteUrl: websiteUrl,
         reservationUrl: reservationUrl,
         latitude: latitude,
         longitude: longitude,
         primaryPhotoUrl: primaryPhotoUrl,
         additionalPhotosJson: additionalPhotosJson,
         googleRating: googleRating,
         googleReviewCount: googleReviewCount,
         displayOrder: displayOrder,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [MapRestaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MapRestaurant copyWith({
    Object? id = _Undefined,
    int? mapId,
    String? name,
    Object? googlePlaceId = _Undefined,
    String? editorialDescription,
    Object? whyNotable = _Undefined,
    Object? mustOrderDishes = _Undefined,
    Object? priceLevel = _Undefined,
    Object? cuisineTypes = _Undefined,
    String? address,
    String? city,
    Object? stateOrRegion = _Undefined,
    Object? postalCode = _Undefined,
    Object? phoneNumber = _Undefined,
    Object? websiteUrl = _Undefined,
    Object? reservationUrl = _Undefined,
    double? latitude,
    double? longitude,
    Object? primaryPhotoUrl = _Undefined,
    Object? additionalPhotosJson = _Undefined,
    Object? googleRating = _Undefined,
    Object? googleReviewCount = _Undefined,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MapRestaurant(
      id: id is int? ? id : this.id,
      mapId: mapId ?? this.mapId,
      name: name ?? this.name,
      googlePlaceId: googlePlaceId is String?
          ? googlePlaceId
          : this.googlePlaceId,
      editorialDescription: editorialDescription ?? this.editorialDescription,
      whyNotable: whyNotable is String? ? whyNotable : this.whyNotable,
      mustOrderDishes: mustOrderDishes is String?
          ? mustOrderDishes
          : this.mustOrderDishes,
      priceLevel: priceLevel is int? ? priceLevel : this.priceLevel,
      cuisineTypes: cuisineTypes is String? ? cuisineTypes : this.cuisineTypes,
      address: address ?? this.address,
      city: city ?? this.city,
      stateOrRegion: stateOrRegion is String?
          ? stateOrRegion
          : this.stateOrRegion,
      postalCode: postalCode is String? ? postalCode : this.postalCode,
      phoneNumber: phoneNumber is String? ? phoneNumber : this.phoneNumber,
      websiteUrl: websiteUrl is String? ? websiteUrl : this.websiteUrl,
      reservationUrl: reservationUrl is String?
          ? reservationUrl
          : this.reservationUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      primaryPhotoUrl: primaryPhotoUrl is String?
          ? primaryPhotoUrl
          : this.primaryPhotoUrl,
      additionalPhotosJson: additionalPhotosJson is String?
          ? additionalPhotosJson
          : this.additionalPhotosJson,
      googleRating: googleRating is double? ? googleRating : this.googleRating,
      googleReviewCount: googleReviewCount is int?
          ? googleReviewCount
          : this.googleReviewCount,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class MapRestaurantUpdateTable extends _i1.UpdateTable<MapRestaurantTable> {
  MapRestaurantUpdateTable(super.table);

  _i1.ColumnValue<int, int> mapId(int value) => _i1.ColumnValue(
    table.mapId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> googlePlaceId(String? value) =>
      _i1.ColumnValue(
        table.googlePlaceId,
        value,
      );

  _i1.ColumnValue<String, String> editorialDescription(String value) =>
      _i1.ColumnValue(
        table.editorialDescription,
        value,
      );

  _i1.ColumnValue<String, String> whyNotable(String? value) => _i1.ColumnValue(
    table.whyNotable,
    value,
  );

  _i1.ColumnValue<String, String> mustOrderDishes(String? value) =>
      _i1.ColumnValue(
        table.mustOrderDishes,
        value,
      );

  _i1.ColumnValue<int, int> priceLevel(int? value) => _i1.ColumnValue(
    table.priceLevel,
    value,
  );

  _i1.ColumnValue<String, String> cuisineTypes(String? value) =>
      _i1.ColumnValue(
        table.cuisineTypes,
        value,
      );

  _i1.ColumnValue<String, String> address(String value) => _i1.ColumnValue(
    table.address,
    value,
  );

  _i1.ColumnValue<String, String> city(String value) => _i1.ColumnValue(
    table.city,
    value,
  );

  _i1.ColumnValue<String, String> stateOrRegion(String? value) =>
      _i1.ColumnValue(
        table.stateOrRegion,
        value,
      );

  _i1.ColumnValue<String, String> postalCode(String? value) => _i1.ColumnValue(
    table.postalCode,
    value,
  );

  _i1.ColumnValue<String, String> phoneNumber(String? value) => _i1.ColumnValue(
    table.phoneNumber,
    value,
  );

  _i1.ColumnValue<String, String> websiteUrl(String? value) => _i1.ColumnValue(
    table.websiteUrl,
    value,
  );

  _i1.ColumnValue<String, String> reservationUrl(String? value) =>
      _i1.ColumnValue(
        table.reservationUrl,
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

  _i1.ColumnValue<String, String> primaryPhotoUrl(String? value) =>
      _i1.ColumnValue(
        table.primaryPhotoUrl,
        value,
      );

  _i1.ColumnValue<String, String> additionalPhotosJson(String? value) =>
      _i1.ColumnValue(
        table.additionalPhotosJson,
        value,
      );

  _i1.ColumnValue<double, double> googleRating(double? value) =>
      _i1.ColumnValue(
        table.googleRating,
        value,
      );

  _i1.ColumnValue<int, int> googleReviewCount(int? value) => _i1.ColumnValue(
    table.googleReviewCount,
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

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class MapRestaurantTable extends _i1.Table<int?> {
  MapRestaurantTable({super.tableRelation})
    : super(tableName: 'map_restaurants') {
    updateTable = MapRestaurantUpdateTable(this);
    mapId = _i1.ColumnInt(
      'mapId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    googlePlaceId = _i1.ColumnString(
      'googlePlaceId',
      this,
    );
    editorialDescription = _i1.ColumnString(
      'editorialDescription',
      this,
    );
    whyNotable = _i1.ColumnString(
      'whyNotable',
      this,
    );
    mustOrderDishes = _i1.ColumnString(
      'mustOrderDishes',
      this,
    );
    priceLevel = _i1.ColumnInt(
      'priceLevel',
      this,
    );
    cuisineTypes = _i1.ColumnString(
      'cuisineTypes',
      this,
    );
    address = _i1.ColumnString(
      'address',
      this,
    );
    city = _i1.ColumnString(
      'city',
      this,
    );
    stateOrRegion = _i1.ColumnString(
      'stateOrRegion',
      this,
    );
    postalCode = _i1.ColumnString(
      'postalCode',
      this,
    );
    phoneNumber = _i1.ColumnString(
      'phoneNumber',
      this,
    );
    websiteUrl = _i1.ColumnString(
      'websiteUrl',
      this,
    );
    reservationUrl = _i1.ColumnString(
      'reservationUrl',
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
    primaryPhotoUrl = _i1.ColumnString(
      'primaryPhotoUrl',
      this,
    );
    additionalPhotosJson = _i1.ColumnString(
      'additionalPhotosJson',
      this,
    );
    googleRating = _i1.ColumnDouble(
      'googleRating',
      this,
    );
    googleReviewCount = _i1.ColumnInt(
      'googleReviewCount',
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
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final MapRestaurantUpdateTable updateTable;

  /// The curated map this restaurant belongs to.
  late final _i1.ColumnInt mapId;

  /// Restaurant name.
  late final _i1.ColumnString name;

  /// Google Places ID for fetching photos and details.
  late final _i1.ColumnString googlePlaceId;

  /// Editorial description written by Perplexity (Eater-style storytelling).
  late final _i1.ColumnString editorialDescription;

  /// Why this restaurant is notable (awards, chef, specialty).
  late final _i1.ColumnString whyNotable;

  /// Signature dishes to order.
  late final _i1.ColumnString mustOrderDishes;

  /// Price range (1-4 dollar signs).
  late final _i1.ColumnInt priceLevel;

  /// Cuisine types (comma-separated).
  late final _i1.ColumnString cuisineTypes;

  /// Full street address.
  late final _i1.ColumnString address;

  /// City name.
  late final _i1.ColumnString city;

  /// State/region.
  late final _i1.ColumnString stateOrRegion;

  /// Postal/ZIP code.
  late final _i1.ColumnString postalCode;

  /// Phone number.
  late final _i1.ColumnString phoneNumber;

  /// Website URL.
  late final _i1.ColumnString websiteUrl;

  /// Reservation link (OpenTable, Resy, etc).
  late final _i1.ColumnString reservationUrl;

  /// Latitude.
  late final _i1.ColumnDouble latitude;

  /// Longitude.
  late final _i1.ColumnDouble longitude;

  /// Primary photo URL from Google Places.
  late final _i1.ColumnString primaryPhotoUrl;

  /// Additional photo URLs (JSON array).
  late final _i1.ColumnString additionalPhotosJson;

  /// Google rating (1-5).
  late final _i1.ColumnDouble googleRating;

  /// Google review count.
  late final _i1.ColumnInt googleReviewCount;

  /// Display order within the map.
  late final _i1.ColumnInt displayOrder;

  /// When this entry was created.
  late final _i1.ColumnDateTime createdAt;

  /// When this entry was last updated.
  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    mapId,
    name,
    googlePlaceId,
    editorialDescription,
    whyNotable,
    mustOrderDishes,
    priceLevel,
    cuisineTypes,
    address,
    city,
    stateOrRegion,
    postalCode,
    phoneNumber,
    websiteUrl,
    reservationUrl,
    latitude,
    longitude,
    primaryPhotoUrl,
    additionalPhotosJson,
    googleRating,
    googleReviewCount,
    displayOrder,
    createdAt,
    updatedAt,
  ];
}

class MapRestaurantInclude extends _i1.IncludeObject {
  MapRestaurantInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => MapRestaurant.t;
}

class MapRestaurantIncludeList extends _i1.IncludeList {
  MapRestaurantIncludeList._({
    _i1.WhereExpressionBuilder<MapRestaurantTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MapRestaurant.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MapRestaurant.t;
}

class MapRestaurantRepository {
  const MapRestaurantRepository._();

  /// Returns a list of [MapRestaurant]s matching the given query parameters.
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
  Future<List<MapRestaurant>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MapRestaurantTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MapRestaurantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MapRestaurantTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MapRestaurant>(
      where: where?.call(MapRestaurant.t),
      orderBy: orderBy?.call(MapRestaurant.t),
      orderByList: orderByList?.call(MapRestaurant.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [MapRestaurant] matching the given query parameters.
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
  Future<MapRestaurant?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MapRestaurantTable>? where,
    int? offset,
    _i1.OrderByBuilder<MapRestaurantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MapRestaurantTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<MapRestaurant>(
      where: where?.call(MapRestaurant.t),
      orderBy: orderBy?.call(MapRestaurant.t),
      orderByList: orderByList?.call(MapRestaurant.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [MapRestaurant] by its [id] or null if no such row exists.
  Future<MapRestaurant?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<MapRestaurant>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [MapRestaurant]s in the list and returns the inserted rows.
  ///
  /// The returned [MapRestaurant]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<MapRestaurant>> insert(
    _i1.Session session,
    List<MapRestaurant> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MapRestaurant>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [MapRestaurant] and returns the inserted row.
  ///
  /// The returned [MapRestaurant] will have its `id` field set.
  Future<MapRestaurant> insertRow(
    _i1.Session session,
    MapRestaurant row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MapRestaurant>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MapRestaurant]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MapRestaurant>> update(
    _i1.Session session,
    List<MapRestaurant> rows, {
    _i1.ColumnSelections<MapRestaurantTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MapRestaurant>(
      rows,
      columns: columns?.call(MapRestaurant.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MapRestaurant]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MapRestaurant> updateRow(
    _i1.Session session,
    MapRestaurant row, {
    _i1.ColumnSelections<MapRestaurantTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MapRestaurant>(
      row,
      columns: columns?.call(MapRestaurant.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MapRestaurant] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MapRestaurant?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<MapRestaurantUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<MapRestaurant>(
      id,
      columnValues: columnValues(MapRestaurant.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MapRestaurant]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<MapRestaurant>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<MapRestaurantUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<MapRestaurantTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MapRestaurantTable>? orderBy,
    _i1.OrderByListBuilder<MapRestaurantTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<MapRestaurant>(
      columnValues: columnValues(MapRestaurant.t.updateTable),
      where: where(MapRestaurant.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MapRestaurant.t),
      orderByList: orderByList?.call(MapRestaurant.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [MapRestaurant]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MapRestaurant>> delete(
    _i1.Session session,
    List<MapRestaurant> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MapRestaurant>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MapRestaurant].
  Future<MapRestaurant> deleteRow(
    _i1.Session session,
    MapRestaurant row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MapRestaurant>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MapRestaurant>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MapRestaurantTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MapRestaurant>(
      where: where(MapRestaurant.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MapRestaurantTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MapRestaurant>(
      where: where?.call(MapRestaurant.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
