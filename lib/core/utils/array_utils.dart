getOrNull<T>(List<T>? items, int index) {
  if (items == null) return null;
  if (index < 0 || index >= items.length) return null;
  return items[index];
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}
