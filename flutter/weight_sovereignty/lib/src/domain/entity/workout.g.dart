// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWorkoutCollection on Isar {
  IsarCollection<Workout> get workouts => this.collection();
}

const WorkoutSchema = CollectionSchema(
  name: r'Workout',
  id: 1535508263686820971,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'exercises': PropertySchema(
      id: 1,
      name: r'exercises',
      type: IsarType.objectList,
      target: r'ExerciseBase',
    ),
    r'workoutBase': PropertySchema(
      id: 2,
      name: r'workoutBase',
      type: IsarType.object,
      target: r'WorkoutBase',
    )
  },
  estimateSize: _workoutEstimateSize,
  serialize: _workoutSerialize,
  deserialize: _workoutDeserialize,
  deserializeProp: _workoutDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {
    r'WorkoutBase': WorkoutBaseSchema,
    r'ExerciseBase': ExerciseBaseSchema,
    r'ExerciseSet': ExerciseSetSchema
  },
  getId: _workoutGetId,
  getLinks: _workoutGetLinks,
  attach: _workoutAttach,
  version: '3.1.0+1',
);

int _workoutEstimateSize(
  Workout object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.exercises;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ExerciseBase]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          if (value != null) {
            bytesCount +=
                ExerciseBaseSchema.estimateSize(value, offsets, allOffsets);
          }
        }
      }
    }
  }
  {
    final value = object.workoutBase;
    if (value != null) {
      bytesCount += 3 +
          WorkoutBaseSchema.estimateSize(
              value, allOffsets[WorkoutBase]!, allOffsets);
    }
  }
  return bytesCount;
}

void _workoutSerialize(
  Workout object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeObjectList<ExerciseBase>(
    offsets[1],
    allOffsets,
    ExerciseBaseSchema.serialize,
    object.exercises,
  );
  writer.writeObject<WorkoutBase>(
    offsets[2],
    allOffsets,
    WorkoutBaseSchema.serialize,
    object.workoutBase,
  );
}

Workout _workoutDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Workout();
  object.date = reader.readDateTimeOrNull(offsets[0]);
  object.exercises = reader.readObjectOrNullList<ExerciseBase>(
    offsets[1],
    ExerciseBaseSchema.deserialize,
    allOffsets,
  );
  object.id = id;
  object.workoutBase = reader.readObjectOrNull<WorkoutBase>(
    offsets[2],
    WorkoutBaseSchema.deserialize,
    allOffsets,
  );
  return object;
}

P _workoutDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readObjectOrNullList<ExerciseBase>(
        offset,
        ExerciseBaseSchema.deserialize,
        allOffsets,
      )) as P;
    case 2:
      return (reader.readObjectOrNull<WorkoutBase>(
        offset,
        WorkoutBaseSchema.deserialize,
        allOffsets,
      )) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _workoutGetId(Workout object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _workoutGetLinks(Workout object) {
  return [];
}

void _workoutAttach(IsarCollection<dynamic> col, Id id, Workout object) {
  object.id = id;
}

extension WorkoutQueryWhereSort on QueryBuilder<Workout, Workout, QWhere> {
  QueryBuilder<Workout, Workout, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Workout, Workout, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension WorkoutQueryWhere on QueryBuilder<Workout, Workout, QWhereClause> {
  QueryBuilder<Workout, Workout, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Workout, Workout, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Workout, Workout, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Workout, Workout, QAfterWhereClause> idBetween(
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

  QueryBuilder<Workout, Workout, QAfterWhereClause> dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [null],
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterWhereClause> dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterWhereClause> dateEqualTo(
      DateTime? date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterWhereClause> dateNotEqualTo(
      DateTime? date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Workout, Workout, QAfterWhereClause> dateGreaterThan(
    DateTime? date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterWhereClause> dateLessThan(
    DateTime? date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterWhereClause> dateBetween(
    DateTime? lowerDate,
    DateTime? upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WorkoutQueryFilter
    on QueryBuilder<Workout, Workout, QFilterCondition> {
  QueryBuilder<Workout, Workout, QAfterFilterCondition> dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition> dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition> dateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition> dateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition> dateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition> dateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition> exercisesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exercises',
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition> exercisesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exercises',
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition>
      exercisesElementIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.elementIsNull(
        property: r'exercises',
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition>
      exercisesElementIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.elementIsNotNull(
        property: r'exercises',
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition> exercisesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition> exercisesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition> exercisesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition> exercisesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition>
      exercisesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition> exercisesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Workout, Workout, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Workout, Workout, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Workout, Workout, QAfterFilterCondition> workoutBaseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'workoutBase',
      ));
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition> workoutBaseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'workoutBase',
      ));
    });
  }
}

extension WorkoutQueryObject
    on QueryBuilder<Workout, Workout, QFilterCondition> {
  QueryBuilder<Workout, Workout, QAfterFilterCondition> exercisesElement(
      FilterQuery<ExerciseBase> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'exercises');
    });
  }

  QueryBuilder<Workout, Workout, QAfterFilterCondition> workoutBase(
      FilterQuery<WorkoutBase> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'workoutBase');
    });
  }
}

extension WorkoutQueryLinks
    on QueryBuilder<Workout, Workout, QFilterCondition> {}

extension WorkoutQuerySortBy on QueryBuilder<Workout, Workout, QSortBy> {
  QueryBuilder<Workout, Workout, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Workout, Workout, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }
}

extension WorkoutQuerySortThenBy
    on QueryBuilder<Workout, Workout, QSortThenBy> {
  QueryBuilder<Workout, Workout, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Workout, Workout, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Workout, Workout, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Workout, Workout, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension WorkoutQueryWhereDistinct
    on QueryBuilder<Workout, Workout, QDistinct> {
  QueryBuilder<Workout, Workout, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }
}

extension WorkoutQueryProperty
    on QueryBuilder<Workout, Workout, QQueryProperty> {
  QueryBuilder<Workout, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Workout, DateTime?, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<Workout, List<ExerciseBase?>?, QQueryOperations>
      exercisesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exercises');
    });
  }

  QueryBuilder<Workout, WorkoutBase?, QQueryOperations> workoutBaseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutBase');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const WorkoutBaseSchema = Schema(
  name: r'WorkoutBase',
  id: 5571672860850075628,
  properties: {
    r'exercisePresetNames': PropertySchema(
      id: 0,
      name: r'exercisePresetNames',
      type: IsarType.stringList,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _workoutBaseEstimateSize,
  serialize: _workoutBaseSerialize,
  deserialize: _workoutBaseDeserialize,
  deserializeProp: _workoutBaseDeserializeProp,
);

int _workoutBaseEstimateSize(
  WorkoutBase object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.exercisePresetNames;
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

void _workoutBaseSerialize(
  WorkoutBase object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.exercisePresetNames);
  writer.writeString(offsets[1], object.name);
}

WorkoutBase _workoutBaseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WorkoutBase();
  object.exercisePresetNames = reader.readStringOrNullList(offsets[0]);
  object.name = reader.readStringOrNull(offsets[1]);
  return object;
}

P _workoutBaseDeserializeProp<P>(
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

extension WorkoutBaseQueryFilter
    on QueryBuilder<WorkoutBase, WorkoutBase, QFilterCondition> {
  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exercisePresetNames',
      ));
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exercisePresetNames',
      ));
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesElementIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.elementIsNull(
        property: r'exercisePresetNames',
      ));
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesElementIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.elementIsNotNull(
        property: r'exercisePresetNames',
      ));
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesElementEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exercisePresetNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesElementGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exercisePresetNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesElementLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exercisePresetNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesElementBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exercisePresetNames',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exercisePresetNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exercisePresetNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exercisePresetNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exercisePresetNames',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exercisePresetNames',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exercisePresetNames',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercisePresetNames',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercisePresetNames',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercisePresetNames',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercisePresetNames',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercisePresetNames',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      exercisePresetNamesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercisePresetNames',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition> nameContains(
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

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkoutBase, WorkoutBase, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension WorkoutBaseQueryObject
    on QueryBuilder<WorkoutBase, WorkoutBase, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ExerciseSetSchema = Schema(
  name: r'ExerciseSet',
  id: 5316752631366182897,
  properties: {
    r'finished': PropertySchema(
      id: 0,
      name: r'finished',
      type: IsarType.bool,
    ),
    r'reps': PropertySchema(
      id: 1,
      name: r'reps',
      type: IsarType.long,
    ),
    r'weightKg': PropertySchema(
      id: 2,
      name: r'weightKg',
      type: IsarType.long,
    )
  },
  estimateSize: _exerciseSetEstimateSize,
  serialize: _exerciseSetSerialize,
  deserialize: _exerciseSetDeserialize,
  deserializeProp: _exerciseSetDeserializeProp,
);

int _exerciseSetEstimateSize(
  ExerciseSet object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _exerciseSetSerialize(
  ExerciseSet object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.finished);
  writer.writeLong(offsets[1], object.reps);
  writer.writeLong(offsets[2], object.weightKg);
}

ExerciseSet _exerciseSetDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ExerciseSet();
  object.finished = reader.readBool(offsets[0]);
  object.reps = reader.readLongOrNull(offsets[1]);
  object.weightKg = reader.readLongOrNull(offsets[2]);
  return object;
}

P _exerciseSetDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ExerciseSetQueryFilter
    on QueryBuilder<ExerciseSet, ExerciseSet, QFilterCondition> {
  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> finishedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finished',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> repsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reps',
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      repsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reps',
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> repsEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reps',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> repsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reps',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> repsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reps',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> repsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      weightKgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weightKg',
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      weightKgIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weightKg',
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> weightKgEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weightKg',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      weightKgGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weightKg',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition>
      weightKgLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weightKg',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseSet, ExerciseSet, QAfterFilterCondition> weightKgBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weightKg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ExerciseSetQueryObject
    on QueryBuilder<ExerciseSet, ExerciseSet, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ExerciseBaseSchema = Schema(
  name: r'ExerciseBase',
  id: -666615400482886289,
  properties: {
    r'burnedCaloriesKcal': PropertySchema(
      id: 0,
      name: r'burnedCaloriesKcal',
      type: IsarType.long,
    ),
    r'categoryName': PropertySchema(
      id: 1,
      name: r'categoryName',
      type: IsarType.string,
    ),
    r'distanceKm': PropertySchema(
      id: 2,
      name: r'distanceKm',
      type: IsarType.double,
    ),
    r'durationMin': PropertySchema(
      id: 3,
      name: r'durationMin',
      type: IsarType.long,
    ),
    r'intensityLevelName': PropertySchema(
      id: 4,
      name: r'intensityLevelName',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'sets': PropertySchema(
      id: 6,
      name: r'sets',
      type: IsarType.objectList,
      target: r'ExerciseSet',
    ),
    r'typeName': PropertySchema(
      id: 7,
      name: r'typeName',
      type: IsarType.string,
    )
  },
  estimateSize: _exerciseBaseEstimateSize,
  serialize: _exerciseBaseSerialize,
  deserialize: _exerciseBaseDeserialize,
  deserializeProp: _exerciseBaseDeserializeProp,
);

int _exerciseBaseEstimateSize(
  ExerciseBase object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.categoryName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.intensityLevelName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.sets;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ExerciseSet]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          if (value != null) {
            bytesCount +=
                ExerciseSetSchema.estimateSize(value, offsets, allOffsets);
          }
        }
      }
    }
  }
  {
    final value = object.typeName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _exerciseBaseSerialize(
  ExerciseBase object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.burnedCaloriesKcal);
  writer.writeString(offsets[1], object.categoryName);
  writer.writeDouble(offsets[2], object.distanceKm);
  writer.writeLong(offsets[3], object.durationMin);
  writer.writeString(offsets[4], object.intensityLevelName);
  writer.writeString(offsets[5], object.name);
  writer.writeObjectList<ExerciseSet>(
    offsets[6],
    allOffsets,
    ExerciseSetSchema.serialize,
    object.sets,
  );
  writer.writeString(offsets[7], object.typeName);
}

ExerciseBase _exerciseBaseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ExerciseBase();
  object.burnedCaloriesKcal = reader.readLongOrNull(offsets[0]);
  object.categoryName = reader.readStringOrNull(offsets[1]);
  object.distanceKm = reader.readDoubleOrNull(offsets[2]);
  object.durationMin = reader.readLongOrNull(offsets[3]);
  object.intensityLevelName = reader.readStringOrNull(offsets[4]);
  object.name = reader.readStringOrNull(offsets[5]);
  object.sets = reader.readObjectOrNullList<ExerciseSet>(
    offsets[6],
    ExerciseSetSchema.deserialize,
    allOffsets,
  );
  object.typeName = reader.readStringOrNull(offsets[7]);
  return object;
}

P _exerciseBaseDeserializeProp<P>(
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
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readObjectOrNullList<ExerciseSet>(
        offset,
        ExerciseSetSchema.deserialize,
        allOffsets,
      )) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ExerciseBaseQueryFilter
    on QueryBuilder<ExerciseBase, ExerciseBase, QFilterCondition> {
  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      burnedCaloriesKcalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'burnedCaloriesKcal',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      burnedCaloriesKcalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'burnedCaloriesKcal',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      burnedCaloriesKcalEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'burnedCaloriesKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      burnedCaloriesKcalGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'burnedCaloriesKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      burnedCaloriesKcalLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'burnedCaloriesKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      burnedCaloriesKcalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'burnedCaloriesKcal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      categoryNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'categoryName',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      categoryNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'categoryName',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      categoryNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      categoryNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      categoryNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      categoryNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      categoryNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      categoryNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      categoryNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      categoryNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoryName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      categoryNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryName',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      categoryNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoryName',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      distanceKmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'distanceKm',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      distanceKmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'distanceKm',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      distanceKmEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'distanceKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      distanceKmGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'distanceKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      distanceKmLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'distanceKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      distanceKmBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'distanceKm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      durationMinIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'durationMin',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      durationMinIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'durationMin',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      durationMinEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationMin',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      durationMinGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationMin',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      durationMinLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationMin',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      durationMinBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationMin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      intensityLevelNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'intensityLevelName',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      intensityLevelNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'intensityLevelName',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      intensityLevelNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intensityLevelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      intensityLevelNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intensityLevelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      intensityLevelNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intensityLevelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      intensityLevelNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intensityLevelName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      intensityLevelNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'intensityLevelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      intensityLevelNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'intensityLevelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      intensityLevelNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'intensityLevelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      intensityLevelNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'intensityLevelName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      intensityLevelNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intensityLevelName',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      intensityLevelNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'intensityLevelName',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
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

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
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

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition> nameContains(
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

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition> setsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sets',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      setsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sets',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      setsElementIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.elementIsNull(
        property: r'sets',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      setsElementIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.elementIsNotNull(
        property: r'sets',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      setsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      setsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      setsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      setsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      setsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      setsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      typeNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'typeName',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      typeNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'typeName',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      typeNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      typeNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      typeNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      typeNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      typeNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      typeNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      typeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      typeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'typeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      typeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeName',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition>
      typeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'typeName',
        value: '',
      ));
    });
  }
}

extension ExerciseBaseQueryObject
    on QueryBuilder<ExerciseBase, ExerciseBase, QFilterCondition> {
  QueryBuilder<ExerciseBase, ExerciseBase, QAfterFilterCondition> setsElement(
      FilterQuery<ExerciseSet> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sets');
    });
  }
}
