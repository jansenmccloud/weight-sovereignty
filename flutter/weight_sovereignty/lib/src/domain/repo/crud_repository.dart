abstract class CrudRepository<T> {
  Future<T?> getById(int id);

  Future<List<T>> getAll();

  Future<int> save(T entity);

  Future<bool> deleteById(int id);
}
