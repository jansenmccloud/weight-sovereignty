// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_config.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFoodConfigCollection on Isar {
  IsarCollection<FoodConfig> get foodConfigs => this.collection();
}

const FoodConfigSchema = CollectionSchema(
  name: r'FoodConfig',
  id: 8125931724790768062,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.long,
    ),
    r'favorite': PropertySchema(
      id: 1,
      name: r'favorite',
      type: IsarType.bool,
    ),
    r'intakeCaloriesKcal': PropertySchema(
      id: 2,
      name: r'intakeCaloriesKcal',
      type: IsarType.long,
    ),
    r'intakeCarbsG': PropertySchema(
      id: 3,
      name: r'intakeCarbsG',
      type: IsarType.long,
    ),
    r'intakeFatG': PropertySchema(
      id: 4,
      name: r'intakeFatG',
      type: IsarType.long,
    ),
    r'intakeProteinG': PropertySchema(
      id: 5,
      name: r'intakeProteinG',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 6,
      name: r'name',
      type: IsarType.string,
    ),
    r'unit': PropertySchema(
      id: 7,
      name: r'unit',
      type: IsarType.string,
    )
  },
  estimateSize: _foodConfigEstimateSize,
  serialize: _foodConfigSerialize,
  deserialize: _foodConfigDeserialize,
  deserializeProp: _foodConfigDeserializeProp,
  idName: r'id',
  indexes: {
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'favorite': IndexSchema(
      id: 4264748667377999100,
      name: r'favorite',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'favorite',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _foodConfigGetId,
  getLinks: _foodConfigGetLinks,
  attach: _foodConfigAttach,
  version: '3.1.0+1',
);

int _foodConfigEstimateSize(
  FoodConfig object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.unit;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _foodConfigSerialize(
  FoodConfig object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amount);
  writer.writeBool(offsets[1], object.favorite);
  writer.writeLong(offsets[2], object.intakeCaloriesKcal);
  writer.writeLong(offsets[3], object.intakeCarbsG);
  writer.writeLong(offsets[4], object.intakeFatG);
  writer.writeLong(offsets[5], object.intakeProteinG);
  writer.writeString(offsets[6], object.name);
  writer.writeString(offsets[7], object.unit);
}

FoodConfig _foodConfigDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FoodConfig();
  object.amount = reader.readLongOrNull(offsets[0]);
  object.favorite = reader.readBoolOrNull(offsets[1]);
  object.id = id;
  object.intakeCaloriesKcal = reader.readLongOrNull(offsets[2]);
  object.intakeCarbsG = reader.readLongOrNull(offsets[3]);
  object.intakeFatG = reader.readLongOrNull(offsets[4]);
  object.intakeProteinG = reader.readLongOrNull(offsets[5]);
  object.name = reader.readStringOrNull(offsets[6]);
  object.unit = reader.readStringOrNull(offsets[7]);
  return object;
}

P _foodConfigDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _foodConfigGetId(FoodConfig object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _foodConfigGetLinks(FoodConfig object) {
  return [];
}

void _foodConfigAttach(IsarCollection<dynamic> col, Id id, FoodConfig object) {
  object.id = id;
}

extension FoodConfigByIndex on IsarCollection<FoodConfig> {
  Future<FoodConfig?> getByName(String? name) {
    return getByIndex(r'name', [name]);
  }

  FoodConfig? getByNameSync(String? name) {
    return getByIndexSync(r'name', [name]);
  }

  Future<bool> deleteByName(String? name) {
    return deleteByIndex(r'name', [name]);
  }

  bool deleteByNameSync(String? name) {
    return deleteByIndexSync(r'name', [name]);
  }

  Future<List<FoodConfig?>> getAllByName(List<String?> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndex(r'name', values);
  }

  List<FoodConfig?> getAllByNameSync(List<String?> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'name', values);
  }

  Future<int> deleteAllByName(List<String?> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'name', values);
  }

  int deleteAllByNameSync(List<String?> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'name', values);
  }

  Future<Id> putByName(FoodConfig object) {
    return putByIndex(r'name', object);
  }

  Id putByNameSync(FoodConfig object, {bool saveLinks = true}) {
    return putByIndexSync(r'name', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByName(List<FoodConfig> objects) {
    return putAllByIndex(r'name', objects);
  }

  List<Id> putAllByNameSync(List<FoodConfig> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'name', objects, saveLinks: saveLinks);
  }
}

extension FoodConfigQueryWhereSort
    on QueryBuilder<FoodConfig, FoodConfig, QWhere> {
  QueryBuilder<FoodConfig, FoodConfig, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterWhere> anyFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'favorite'),
      );
    });
  }
}

extension FoodConfigQueryWhere
    on QueryBuilder<FoodConfig, FoodConfig, QWhereClause> {
  QueryBuilder<FoodConfig, FoodConfig, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterWhereClause> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [null],
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterWhereClause> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterWhereClause> nameEqualTo(
      String? name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterWhereClause> nameNotEqualTo(
      String? name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterWhereClause> favoriteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'favorite',
        value: [null],
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterWhereClause> favoriteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'favorite',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterWhereClause> favoriteEqualTo(
      bool? favorite) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'favorite',
        value: [favorite],
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterWhereClause> favoriteNotEqualTo(
      bool? favorite) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favorite',
              lower: [],
              upper: [favorite],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favorite',
              lower: [favorite],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favorite',
              lower: [favorite],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favorite',
              lower: [],
              upper: [favorite],
              includeUpper: false,
            ));
      }
    });
  }
}

extension FoodConfigQueryFilter
    on QueryBuilder<FoodConfig, FoodConfig, QFilterCondition> {
  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> amountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'amount',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      amountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'amount',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> amountEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> amountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> amountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> amountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> favoriteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'favorite',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      favoriteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'favorite',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> favoriteEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favorite',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeCaloriesKcalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'intakeCaloriesKcal',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeCaloriesKcalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'intakeCaloriesKcal',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeCaloriesKcalEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intakeCaloriesKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeCaloriesKcalGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intakeCaloriesKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeCaloriesKcalLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intakeCaloriesKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeCaloriesKcalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intakeCaloriesKcal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeCarbsGIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'intakeCarbsG',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeCarbsGIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'intakeCarbsG',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeCarbsGEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intakeCarbsG',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeCarbsGGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intakeCarbsG',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeCarbsGLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intakeCarbsG',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeCarbsGBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intakeCarbsG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeFatGIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'intakeFatG',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeFatGIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'intakeFatG',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> intakeFatGEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intakeFatG',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeFatGGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intakeFatG',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeFatGLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intakeFatG',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> intakeFatGBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intakeFatG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeProteinGIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'intakeProteinG',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeProteinGIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'intakeProteinG',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeProteinGEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intakeProteinG',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeProteinGGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intakeProteinG',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeProteinGLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intakeProteinG',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition>
      intakeProteinGBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intakeProteinG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> unitIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'unit',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> unitIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'unit',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> unitEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> unitGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> unitLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> unitBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> unitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> unitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> unitContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> unitMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'unit',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> unitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unit',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterFilterCondition> unitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'unit',
        value: '',
      ));
    });
  }
}

extension FoodConfigQueryObject
    on QueryBuilder<FoodConfig, FoodConfig, QFilterCondition> {}

extension FoodConfigQueryLinks
    on QueryBuilder<FoodConfig, FoodConfig, QFilterCondition> {}

extension FoodConfigQuerySortBy
    on QueryBuilder<FoodConfig, FoodConfig, QSortBy> {
  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> sortByFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favorite', Sort.asc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> sortByFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favorite', Sort.desc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy>
      sortByIntakeCaloriesKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakeCaloriesKcal', Sort.asc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy>
      sortByIntakeCaloriesKcalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakeCaloriesKcal', Sort.desc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> sortByIntakeCarbsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakeCarbsG', Sort.asc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> sortByIntakeCarbsGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakeCarbsG', Sort.desc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> sortByIntakeFatG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakeFatG', Sort.asc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> sortByIntakeFatGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakeFatG', Sort.desc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> sortByIntakeProteinG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakeProteinG', Sort.asc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy>
      sortByIntakeProteinGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakeProteinG', Sort.desc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> sortByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> sortByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }
}

extension FoodConfigQuerySortThenBy
    on QueryBuilder<FoodConfig, FoodConfig, QSortThenBy> {
  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> thenByFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favorite', Sort.asc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> thenByFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favorite', Sort.desc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy>
      thenByIntakeCaloriesKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakeCaloriesKcal', Sort.asc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy>
      thenByIntakeCaloriesKcalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakeCaloriesKcal', Sort.desc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> thenByIntakeCarbsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakeCarbsG', Sort.asc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> thenByIntakeCarbsGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakeCarbsG', Sort.desc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> thenByIntakeFatG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakeFatG', Sort.asc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> thenByIntakeFatGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakeFatG', Sort.desc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> thenByIntakeProteinG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakeProteinG', Sort.asc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy>
      thenByIntakeProteinGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intakeProteinG', Sort.desc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> thenByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QAfterSortBy> thenByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }
}

extension FoodConfigQueryWhereDistinct
    on QueryBuilder<FoodConfig, FoodConfig, QDistinct> {
  QueryBuilder<FoodConfig, FoodConfig, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QDistinct> distinctByFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'favorite');
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QDistinct>
      distinctByIntakeCaloriesKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intakeCaloriesKcal');
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QDistinct> distinctByIntakeCarbsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intakeCarbsG');
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QDistinct> distinctByIntakeFatG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intakeFatG');
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QDistinct> distinctByIntakeProteinG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intakeProteinG');
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodConfig, FoodConfig, QDistinct> distinctByUnit(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unit', caseSensitive: caseSensitive);
    });
  }
}

extension FoodConfigQueryProperty
    on QueryBuilder<FoodConfig, FoodConfig, QQueryProperty> {
  QueryBuilder<FoodConfig, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FoodConfig, int?, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<FoodConfig, bool?, QQueryOperations> favoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'favorite');
    });
  }

  QueryBuilder<FoodConfig, int?, QQueryOperations>
      intakeCaloriesKcalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intakeCaloriesKcal');
    });
  }

  QueryBuilder<FoodConfig, int?, QQueryOperations> intakeCarbsGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intakeCarbsG');
    });
  }

  QueryBuilder<FoodConfig, int?, QQueryOperations> intakeFatGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intakeFatG');
    });
  }

  QueryBuilder<FoodConfig, int?, QQueryOperations> intakeProteinGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intakeProteinG');
    });
  }

  QueryBuilder<FoodConfig, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<FoodConfig, String?, QQueryOperations> unitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unit');
    });
  }
}
