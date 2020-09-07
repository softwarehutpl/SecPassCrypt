extension ListsExtensions<T> on List<T> {
  T firstOrNull() {
    return this.isNotEmpty ? this.first : null;
  }

  T secondOrNull() {
    return (this.isNotEmpty && this.length >= 2) ? this.elementAt(1) : null;
  }
}