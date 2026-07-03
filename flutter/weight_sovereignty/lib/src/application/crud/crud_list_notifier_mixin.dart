import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/domain/repo/crud_repository.dart';

mixin CrudListNotifierMixin<T> on AsyncNotifier<List<T>> {
  CrudRepository<T> repository();

  @override
  Future<List<T>> build() => repository().getAll();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await repository().getAll());
  }

  Future<T> create(T item) async {
    await repository().save(item);
    await refresh();
    return item;
  }

  Future<T> updateItem(T item) async {
    await repository().save(item);
    await refresh();
    return item;
  }

  Future<void> delete(int id) async {
    await repository().deleteById(id);
    await refresh();
  }

  Future<T?> read(int id) => repository().getById(id);
}
