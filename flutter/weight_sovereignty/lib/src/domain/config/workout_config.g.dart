// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_config.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWorkoutConfigCollection on Isar {
  IsarCollection<WorkoutConfig> get workoutConfigs => this.collection();
}

const WorkoutConfigSchema = CollectionSchema(
  name: r'WorkoutConfig',
  id: -5383006905895054645,
  properties: {
    r'exercisePresetIds': PropertySchema(
      id: 0,
      name: r'exercisePresetIds',
      type: IsarType.stringList,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _workoutConfigEstimateSize,
  serialize: _workoutConfigSerialize,
  deserialize: _workoutConfigDeserialize,
  deserializeProp: _workoutConfigDeserializeProp,
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
  getId: _workoutConfigGetId,
  getLinks: _workoutConfigGetLinks,
  attach: _workoutConfigAttach,
  version: '3.1.0+1',
);

int _workoutConfigEstimateSize(
  WorkoutConfig object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.exercisePresetIds;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          if (value != null) {
            bytesCount += value.length * 3;
          }
        }
      }
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _workoutConfigSerialize(
  WorkoutConfig object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.exercisePresetIds);
  writer.writeString(offsets[1], object.name);
}

WorkoutConfig _workoutConfigDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WorkoutConfig();
  object.exercisePresetIds = reader.readStringOrNullList(offsets[0]);
  object.id = id;
  object.name = reader.readStringOrNull(offsets[1]);
  return object;
}

P _workoutConfigDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNullList(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _workoutConfigGetId(WorkoutConfig object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _workoutConfigGetLinks(WorkoutConfig object) {
  return [];
}

void _workoutConfigAttach(
    IsarCollection<dynamic> col, Id id, WorkoutConfig object) {
  object.id = id;
}

extension WorkoutConfigByIndex on IsarCollection<WorkoutConfig> {
  Future<WorkoutConfig?> getByName(String? name) {
    return getByIndex(r'name', [name]);
  }

  WorkoutConfig? getByNameSync(String? name) {
    return getByIndexSync(r'name', [name]);
  }

  Future<bool> deleteByName(String? name) {
    return deleteByIndex(r'name', [name]);
  }

  bool deleteByNameSync(String? name) {
    return deleteByIndexSync(r'name', [name]);
  }

  Future<List<WorkoutConfig?>> getAllByName(List<String?> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndex(r'name', values);
  }

  List<WorkoutConfig?> getAllByNameSync(List<String?> nameValues) {
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

  Future<Id> putByName(WorkoutConfig object) {
    return putByIndex(r'name', object);
  }

  Id putByNameSync(WorkoutConfig object, {bool saveLinks = true}) {
    return putByIndexSync(r'name', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByName(List<WorkoutConfig> objects) {
    return putAllByIndex(r'name', objects);
  }

  List<Id> putAllByNameSync(List<WorkoutConfig> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'name', objects, saveLinks: saveLinks);
  }
}

extension WorkoutConfigQueryWhereSort
    on QueryBuilder<WorkoutConfig, WorkoutConfig, QWhere> {
  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WorkoutConfigQueryWhere
    on QueryBuilder<WorkoutConfig, WorkoutConfig, QWhereClause> {
  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterWhereClause> idBetween(
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

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterWhereClause> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [null],
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterWhereClause>
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

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterWhereClause> nameEqualTo(
      String? name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterWhereClause> nameNotEqualTo(
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
}

extension WorkoutConfigQueryFilter
    on QueryBuilder<WorkoutConfig, WorkoutConfig, QFilterCondition> {
  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exercisePresetIds',
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exercisePresetIds',
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsElementIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.elementIsNull(
        property: r'exercisePresetIds',
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsElementIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.elementIsNotNull(
        property: r'exercisePresetIds',
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsElementEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exercisePresetIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsElementGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exercisePresetIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsElementLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exercisePresetIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsElementBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exercisePresetIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exercisePresetIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exercisePresetIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exercisePresetIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exercisePresetIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exercisePresetIds',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exercisePresetIds',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercisePresetIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercisePresetIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercisePresetIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercisePresetIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercisePresetIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      exercisePresetIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercisePresetIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
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

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
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

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
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

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
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

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
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

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension WorkoutConfigQueryObject
    on QueryBuilder<WorkoutConfig, WorkoutConfig, QFilterCondition> {}

extension WorkoutConfigQueryLinks
    on QueryBuilder<WorkoutConfig, WorkoutConfig, QFilterCondition> {}

extension WorkoutConfigQuerySortBy
    on QueryBuilder<WorkoutConfig, WorkoutConfig, QSortBy> {
  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension WorkoutConfigQuerySortThenBy
    on QueryBuilder<WorkoutConfig, WorkoutConfig, QSortThenBy> {
  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension WorkoutConfigQueryWhereDistinct
    on QueryBuilder<WorkoutConfig, WorkoutConfig, QDistinct> {
  QueryBuilder<WorkoutConfig, WorkoutConfig, QDistinct>
      distinctByExercisePresetIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exercisePresetIds');
    });
  }

  QueryBuilder<WorkoutConfig, WorkoutConfig, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension WorkoutConfigQueryProperty
    on QueryBuilder<WorkoutConfig, WorkoutConfig, QQueryProperty> {
  QueryBuilder<WorkoutConfig, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WorkoutConfig, List<String?>?, QQueryOperations>
      exercisePresetIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exercisePresetIds');
    });
  }

  QueryBuilder<WorkoutConfig, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
