import 'package:isar/isar.dart';

class IsarCrud<T> {
  IsarCrud(this._collection);

  final IsarCollection<T> _collection;

  Future<T?> getById(int id) => _collection.get(id);

  Future<List<T>> getAll() => _collection.where().findAll();

  Future<int> put(T entity) async {
    return _collection.isar.writeTxn(() => _collection.put(entity));
  }

  Future<bool> deleteById(int id) async {
    return _collection.isar.writeTxn(() => _collection.delete(id));
  }
}
