// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dailylog.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyLogCollection on Isar {
  IsarCollection<DailyLog> get dailyLogs => this.collection();
}

const DailyLogSchema = CollectionSchema(
  name: r'DailyLog',
  id: -3995615497450705259,
  properties: {
    r'bodyWeight': PropertySchema(
      id: 0,
      name: r'bodyWeight',
      type: IsarType.double,
    ),
    r'calculation': PropertySchema(
      id: 1,
      name: r'calculation',
      type: IsarType.object,
      target: r'Calculation',
    ),
    r'dailyLogBase': PropertySchema(
      id: 2,
      name: r'dailyLogBase',
      type: IsarType.object,
      target: r'DailyLogBase',
    ),
    r'date': PropertySchema(
      id: 3,
      name: r'date',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _dailyLogEstimateSize,
  serialize: _dailyLogSerialize,
  deserialize: _dailyLogDeserialize,
  deserializeProp: _dailyLogDeserializeProp,
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
    r'DailyLogBase': DailyLogBaseSchema,
    r'Calculation': CalculationSchema
  },
  getId: _dailyLogGetId,
  getLinks: _dailyLogGetLinks,
  attach: _dailyLogAttach,
  version: '3.1.0+1',
);

int _dailyLogEstimateSize(
  DailyLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.calculation;
    if (value != null) {
      bytesCount += 3 +
          CalculationSchema.estimateSize(
              value, allOffsets[Calculation]!, allOffsets);
    }
  }
  {
    final value = object.dailyLogBase;
    if (value != null) {
      bytesCount += 3 +
          DailyLogBaseSchema.estimateSize(
              value, allOffsets[DailyLogBase]!, allOffsets);
    }
  }
  return bytesCount;
}

void _dailyLogSerialize(
  DailyLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.bodyWeight);
  writer.writeObject<Calculation>(
    offsets[1],
    allOffsets,
    CalculationSchema.serialize,
    object.calculation,
  );
  writer.writeObject<DailyLogBase>(
    offsets[2],
    allOffsets,
    DailyLogBaseSchema.serialize,
    object.dailyLogBase,
  );
  writer.writeDateTime(offsets[3], object.date);
}

DailyLog _dailyLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyLog();
  object.bodyWeight = reader.readDoubleOrNull(offsets[0]);
  object.calculation = reader.readObjectOrNull<Calculation>(
    offsets[1],
    CalculationSchema.deserialize,
    allOffsets,
  );
  object.dailyLogBase = reader.readObjectOrNull<DailyLogBase>(
    offsets[2],
    DailyLogBaseSchema.deserialize,
    allOffsets,
  );
  object.date = reader.readDateTimeOrNull(offsets[3]);
  object.id = id;
  return object;
}

P _dailyLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readObjectOrNull<Calculation>(
        offset,
        CalculationSchema.deserialize,
        allOffsets,
      )) as P;
    case 2:
      return (reader.readObjectOrNull<DailyLogBase>(
        offset,
        DailyLogBaseSchema.deserialize,
        allOffsets,
      )) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyLogGetId(DailyLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyLogGetLinks(DailyLog object) {
  return [];
}

void _dailyLogAttach(IsarCollection<dynamic> col, Id id, DailyLog object) {
  object.id = id;
}

extension DailyLogQueryWhereSort on QueryBuilder<DailyLog, DailyLog, QWhere> {
  QueryBuilder<DailyLog, DailyLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension DailyLogQueryWhere on QueryBuilder<DailyLog, DailyLog, QWhereClause> {
  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> idBetween(
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

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [null],
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> dateEqualTo(
      DateTime? date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> dateNotEqualTo(
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

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> dateGreaterThan(
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

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> dateLessThan(
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

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> dateBetween(
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

extension DailyLogQueryFilter
    on QueryBuilder<DailyLog, DailyLog, QFilterCondition> {
  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> bodyWeightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bodyWeight',
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
      bodyWeightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bodyWeight',
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> bodyWeightEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bodyWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> bodyWeightGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bodyWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> bodyWeightLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bodyWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> bodyWeightBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bodyWeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> calculationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'calculation',
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
      calculationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'calculation',
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dailyLogBaseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dailyLogBase',
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
      dailyLogBaseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dailyLogBase',
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateGreaterThan(
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

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateLessThan(
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

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateBetween(
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

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> idBetween(
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
}

extension DailyLogQueryObject
    on QueryBuilder<DailyLog, DailyLog, QFilterCondition> {
  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> calculation(
      FilterQuery<Calculation> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'calculation');
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dailyLogBase(
      FilterQuery<DailyLogBase> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'dailyLogBase');
    });
  }
}

extension DailyLogQueryLinks
    on QueryBuilder<DailyLog, DailyLog, QFilterCondition> {}

extension DailyLogQuerySortBy on QueryBuilder<DailyLog, DailyLog, QSortBy> {
  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByBodyWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bodyWeight', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByBodyWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bodyWeight', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }
}

extension DailyLogQuerySortThenBy
    on QueryBuilder<DailyLog, DailyLog, QSortThenBy> {
  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByBodyWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bodyWeight', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByBodyWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bodyWeight', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension DailyLogQueryWhereDistinct
    on QueryBuilder<DailyLog, DailyLog, QDistinct> {
  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByBodyWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bodyWeight');
    });
  }

  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }
}

extension DailyLogQueryProperty
    on QueryBuilder<DailyLog, DailyLog, QQueryProperty> {
  QueryBuilder<DailyLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyLog, double?, QQueryOperations> bodyWeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bodyWeight');
    });
  }

  QueryBuilder<DailyLog, Calculation?, QQueryOperations> calculationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calculation');
    });
  }

  QueryBuilder<DailyLog, DailyLogBase?, QQueryOperations>
      dailyLogBaseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyLogBase');
    });
  }

  QueryBuilder<DailyLog, DateTime?, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const DailyLogBaseSchema = Schema(
  name: r'DailyLogBase',
  id: -6558566378449483,
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
    r'plannedDeficitKcal': PropertySchema(
      id: 2,
      name: r'plannedDeficitKcal',
      type: IsarType.long,
    )
  },
  estimateSize: _dailyLogBaseEstimateSize,
  serialize: _dailyLogBaseSerialize,
  deserialize: _dailyLogBaseDeserialize,
  deserializeProp: _dailyLogBaseDeserializeProp,
);

int _dailyLogBaseEstimateSize(
  DailyLogBase object,
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

void _dailyLogBaseSerialize(
  DailyLogBase object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bmrCaloriesKcal);
  writer.writeString(offsets[1], object.name);
  writer.writeLong(offsets[2], object.plannedDeficitKcal);
}

DailyLogBase _dailyLogBaseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyLogBase();
  object.bmrCaloriesKcal = reader.readLongOrNull(offsets[0]);
  object.name = reader.readStringOrNull(offsets[1]);
  object.plannedDeficitKcal = reader.readLongOrNull(offsets[2]);
  return object;
}

P _dailyLogBaseDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension DailyLogBaseQueryFilter
    on QueryBuilder<DailyLogBase, DailyLogBase, QFilterCondition> {
  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition>
      bmrCaloriesKcalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bmrCaloriesKcal',
      ));
    });
  }

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition>
      bmrCaloriesKcalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bmrCaloriesKcal',
      ));
    });
  }

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition>
      bmrCaloriesKcalEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bmrCaloriesKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition>
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

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition>
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

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition>
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

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition>
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

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition>
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

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition> nameContains(
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

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition>
      plannedDeficitKcalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'plannedDeficitKcal',
      ));
    });
  }

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition>
      plannedDeficitKcalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'plannedDeficitKcal',
      ));
    });
  }

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition>
      plannedDeficitKcalEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plannedDeficitKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition>
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

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition>
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

  QueryBuilder<DailyLogBase, DailyLogBase, QAfterFilterCondition>
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
}

extension DailyLogBaseQueryObject
    on QueryBuilder<DailyLogBase, DailyLogBase, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CalculationSchema = Schema(
  name: r'Calculation',
  id: 3713705161983668359,
  properties: {
    r'totalBurnedCaloriesKcal': PropertySchema(
      id: 0,
      name: r'totalBurnedCaloriesKcal',
      type: IsarType.long,
    ),
    r'totalIntakeCaloriesKcal': PropertySchema(
      id: 1,
      name: r'totalIntakeCaloriesKcal',
      type: IsarType.long,
    ),
    r'totalIntakeCarbsG': PropertySchema(
      id: 2,
      name: r'totalIntakeCarbsG',
      type: IsarType.double,
    ),
    r'totalIntakeFatG': PropertySchema(
      id: 3,
      name: r'totalIntakeFatG',
      type: IsarType.double,
    ),
    r'totalIntakeProteinG': PropertySchema(
      id: 4,
      name: r'totalIntakeProteinG',
      type: IsarType.double,
    )
  },
  estimateSize: _calculationEstimateSize,
  serialize: _calculationSerialize,
  deserialize: _calculationDeserialize,
  deserializeProp: _calculationDeserializeProp,
);

int _calculationEstimateSize(
  Calculation object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _calculationSerialize(
  Calculation object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.totalBurnedCaloriesKcal);
  writer.writeLong(offsets[1], object.totalIntakeCaloriesKcal);
  writer.writeDouble(offsets[2], object.totalIntakeCarbsG);
  writer.writeDouble(offsets[3], object.totalIntakeFatG);
  writer.writeDouble(offsets[4], object.totalIntakeProteinG);
}

Calculation _calculationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Calculation();
  object.totalBurnedCaloriesKcal = reader.readLongOrNull(offsets[0]);
  object.totalIntakeCaloriesKcal = reader.readLongOrNull(offsets[1]);
  object.totalIntakeCarbsG = reader.readDoubleOrNull(offsets[2]);
  object.totalIntakeFatG = reader.readDoubleOrNull(offsets[3]);
  object.totalIntakeProteinG = reader.readDoubleOrNull(offsets[4]);
  return object;
}

P _calculationDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CalculationQueryFilter
    on QueryBuilder<Calculation, Calculation, QFilterCondition> {
  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalBurnedCaloriesKcalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalBurnedCaloriesKcal',
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalBurnedCaloriesKcalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalBurnedCaloriesKcal',
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalBurnedCaloriesKcalEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalBurnedCaloriesKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalBurnedCaloriesKcalGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalBurnedCaloriesKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalBurnedCaloriesKcalLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalBurnedCaloriesKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalBurnedCaloriesKcalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalBurnedCaloriesKcal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeCaloriesKcalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalIntakeCaloriesKcal',
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeCaloriesKcalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalIntakeCaloriesKcal',
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeCaloriesKcalEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalIntakeCaloriesKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeCaloriesKcalGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalIntakeCaloriesKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeCaloriesKcalLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalIntakeCaloriesKcal',
        value: value,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeCaloriesKcalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalIntakeCaloriesKcal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeCarbsGIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalIntakeCarbsG',
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeCarbsGIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalIntakeCarbsG',
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeCarbsGEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalIntakeCarbsG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeCarbsGGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalIntakeCarbsG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeCarbsGLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalIntakeCarbsG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeCarbsGBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalIntakeCarbsG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeFatGIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalIntakeFatG',
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeFatGIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalIntakeFatG',
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeFatGEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalIntakeFatG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeFatGGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalIntakeFatG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeFatGLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalIntakeFatG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeFatGBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalIntakeFatG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeProteinGIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalIntakeProteinG',
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeProteinGIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalIntakeProteinG',
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeProteinGEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalIntakeProteinG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeProteinGGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalIntakeProteinG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeProteinGLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalIntakeProteinG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Calculation, Calculation, QAfterFilterCondition>
      totalIntakeProteinGBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalIntakeProteinG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension CalculationQueryObject
    on QueryBuilder<Calculation, Calculation, QFilterCondition> {}
