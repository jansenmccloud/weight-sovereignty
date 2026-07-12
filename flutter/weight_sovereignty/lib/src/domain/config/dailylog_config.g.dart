// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dailylog_config.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyLogConfigCollection on Isar {
  IsarCollection<DailyLogConfig> get dailyLogConfigs => this.collection();
}

const DailyLogConfigSchema = CollectionSchema(
  name: r'DailyLogConfig',
  id: -3282966432489337833,
  properties: {
    r'bmrCaloriesKcal': PropertySchema(
      id: 0,
      name: r'bmrCaloriesKcal',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    ),
    r'plannedCarbsG': PropertySchema(
      id: 2,
      name: r'plannedCarbsG',
      type: IsarType.long,
    ),
    r'plannedDeficitKcal': PropertySchema(
      id: 3,
      name: r'plannedDeficitKcal',
      type: IsarType.long,
    ),
    r'plannedFatG': PropertySchema(
      id: 4,
      name: r'plannedFatG',
      type: IsarType.long,
    ),
    r'plannedProteinG': PropertySchema(
      id: 5,
      name: r'plannedProteinG',
      type: IsarType.long,
    )
  },
  estimateSize: _dailyLogConfigEstimateSize,
  serialize: _dailyLogConfigSerialize,
  deserialize: _dailyLogConfigDeserialize,
  deserializeProp: _dailyLogConfigDeserializeProp,
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dailyLogConfigGetId,
  getLinks: _dailyLogConfigGetLinks,
  attach: _dailyLogConfigAttach,
  version: '3.1.0+1',
);

int _dailyLogConfigEstimateSize(
  DailyLogConfig object,
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
  return bytesCount;
}

void _dailyLogConfigSerialize(
  DailyLogConfig object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bmrCaloriesKcal);
  writer.writeString(offsets[1], object.name);
  writer.writeLong(offsets[2], object.plannedCarbsG);
  writer.writeLong(offsets[3], object.plannedDeficitKcal);
  writer.writeLong(offsets[4], object.plannedFatG);
  writer.writeLong(offsets[5], object.plannedProteinG);
}

DailyLogConfig _dailyLogConfigDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyLogConfig();
  object.bmrCaloriesKcal = reader.readLongOrNull(offsets[0]);
  object.id = id;
  object.name = reader.readStringOrNull(offsets[1]);
  object.plannedCarbsG = reader.readLongOrNull(offsets[2]);
  object.plannedDeficitKcal = reader.readLongOrNull(offsets[3]);
  object.plannedFatG = reader.readLongOrNull(offsets[4]);
  object.plannedProteinG = reader.readLongOrNull(offsets[5]);
  return object;
}

P _dailyLogConfigDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyLogConfigGetId(DailyLogConfig object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyLogConfigGetLinks(DailyLogConfig object) {
  return [];
}

void _dailyLogConfigAttach(
    IsarCollection<dynamic> col, Id id, DailyLogConfig object) {
  object.id = id;
}

extension DailyLogConfigByIndex on IsarCollection<DailyLogConfig> {
  Future<DailyLogConfig?> getByName(String? name) {
    return getByIndex(r'name', [name]);
  }

  DailyLogConfig? getByNameSync(String? name) {
    return getByIndexSync(r'name', [name]);
  }

  Future<bool> deleteByName(String? name) {
    return deleteByIndex(r'name', [name]);
  }

  bool deleteByNameSync(String? name) {
    return deleteByIndexSync(r'name', [name]);
  }

  Future<List<DailyLogConfig?>> getAllByName(List<String?> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndex(r'name', values);
  }

  List<DailyLogConfig?> getAllByNameSync(List<String?> nameValues) {
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

  Future<Id> putByName(DailyLogConfig object) {
    return putByIndex(r'name', object);
  }

  Id putByNameSync(DailyLogConfig object, {bool saveLinks = true}) {
    return putByIndexSync(r'name', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByName(List<DailyLogConfig> objects) {
    return putAllByIndex(r'name', objects);
  }

  List<Id> putAllByNameSync(List<DailyLogConfig> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'name', objects, saveLinks: saveLinks);
  }
}

extension DailyLogConfigQueryWhereSort
    on QueryBuilder<DailyLogConfig, DailyLogConfig, QWhere> {
  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DailyLogConfigQueryWhere
    on QueryBuilder<DailyLogConfig, DailyLogConfig, QWhereClause> {
  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterWhereClause> idBetween(
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

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterWhereClause> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [null],
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterWhereClause>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterWhereClause> nameEqualTo(
      String? name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterWhereClause>
      nameNotEqualTo(String? name) {
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
}

extension DailyLogConfigQueryFilter
    on QueryBuilder<DailyLogConfig, DailyLogConfig, QFilterCondition> {
  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      bmrCaloriesKcalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bmrCaloriesKcal',
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      bmrCaloriesKcalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bmrCaloriesKcal',
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      bmrCaloriesKcalEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bmrCaloriesKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      bmrCaloriesKcalGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bmrCaloriesKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      bmrCaloriesKcalLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bmrCaloriesKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      bmrCaloriesKcalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bmrCaloriesKcal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      nameEqualTo(
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

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      nameGreaterThan(
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

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      nameLessThan(
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

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      nameBetween(
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

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      nameStartsWith(
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

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedCarbsGIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'plannedCarbsG',
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedCarbsGIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'plannedCarbsG',
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedCarbsGEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plannedCarbsG',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedCarbsGGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'plannedCarbsG',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedCarbsGLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'plannedCarbsG',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedCarbsGBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'plannedCarbsG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedDeficitKcalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'plannedDeficitKcal',
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedDeficitKcalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'plannedDeficitKcal',
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedDeficitKcalEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plannedDeficitKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedDeficitKcalGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'plannedDeficitKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedDeficitKcalLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'plannedDeficitKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedDeficitKcalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'plannedDeficitKcal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedFatGIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'plannedFatG',
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedFatGIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'plannedFatG',
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedFatGEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plannedFatG',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedFatGGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'plannedFatG',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedFatGLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'plannedFatG',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedFatGBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'plannedFatG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedProteinGIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'plannedProteinG',
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedProteinGIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'plannedProteinG',
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedProteinGEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plannedProteinG',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedProteinGGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'plannedProteinG',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedProteinGLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'plannedProteinG',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterFilterCondition>
      plannedProteinGBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'plannedProteinG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyLogConfigQueryObject
    on QueryBuilder<DailyLogConfig, DailyLogConfig, QFilterCondition> {}

extension DailyLogConfigQueryLinks
    on QueryBuilder<DailyLogConfig, DailyLogConfig, QFilterCondition> {}

extension DailyLogConfigQuerySortBy
    on QueryBuilder<DailyLogConfig, DailyLogConfig, QSortBy> {
  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      sortByBmrCaloriesKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bmrCaloriesKcal', Sort.asc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      sortByBmrCaloriesKcalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bmrCaloriesKcal', Sort.desc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      sortByPlannedCarbsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedCarbsG', Sort.asc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      sortByPlannedCarbsGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedCarbsG', Sort.desc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      sortByPlannedDeficitKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedDeficitKcal', Sort.asc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      sortByPlannedDeficitKcalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedDeficitKcal', Sort.desc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      sortByPlannedFatG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedFatG', Sort.asc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      sortByPlannedFatGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedFatG', Sort.desc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      sortByPlannedProteinG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedProteinG', Sort.asc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      sortByPlannedProteinGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedProteinG', Sort.desc);
    });
  }
}

extension DailyLogConfigQuerySortThenBy
    on QueryBuilder<DailyLogConfig, DailyLogConfig, QSortThenBy> {
  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      thenByBmrCaloriesKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bmrCaloriesKcal', Sort.asc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      thenByBmrCaloriesKcalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bmrCaloriesKcal', Sort.desc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      thenByPlannedCarbsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedCarbsG', Sort.asc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      thenByPlannedCarbsGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedCarbsG', Sort.desc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      thenByPlannedDeficitKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedDeficitKcal', Sort.asc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      thenByPlannedDeficitKcalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedDeficitKcal', Sort.desc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      thenByPlannedFatG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedFatG', Sort.asc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      thenByPlannedFatGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedFatG', Sort.desc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      thenByPlannedProteinG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedProteinG', Sort.asc);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QAfterSortBy>
      thenByPlannedProteinGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedProteinG', Sort.desc);
    });
  }
}

extension DailyLogConfigQueryWhereDistinct
    on QueryBuilder<DailyLogConfig, DailyLogConfig, QDistinct> {
  QueryBuilder<DailyLogConfig, DailyLogConfig, QDistinct>
      distinctByBmrCaloriesKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bmrCaloriesKcal');
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QDistinct>
      distinctByPlannedCarbsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedCarbsG');
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QDistinct>
      distinctByPlannedDeficitKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedDeficitKcal');
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QDistinct>
      distinctByPlannedFatG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedFatG');
    });
  }

  QueryBuilder<DailyLogConfig, DailyLogConfig, QDistinct>
      distinctByPlannedProteinG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedProteinG');
    });
  }
}

extension DailyLogConfigQueryProperty
    on QueryBuilder<DailyLogConfig, DailyLogConfig, QQueryProperty> {
  QueryBuilder<DailyLogConfig, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyLogConfig, int?, QQueryOperations>
      bmrCaloriesKcalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bmrCaloriesKcal');
    });
  }

  QueryBuilder<DailyLogConfig, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<DailyLogConfig, int?, QQueryOperations> plannedCarbsGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedCarbsG');
    });
  }

  QueryBuilder<DailyLogConfig, int?, QQueryOperations>
      plannedDeficitKcalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedDeficitKcal');
    });
  }

  QueryBuilder<DailyLogConfig, int?, QQueryOperations> plannedFatGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedFatG');
    });
  }

  QueryBuilder<DailyLogConfig, int?, QQueryOperations>
      plannedProteinGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedProteinG');
    });
  }
}
