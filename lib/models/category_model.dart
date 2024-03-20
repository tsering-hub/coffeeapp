class CategoryModel {
  final String id;
  final int timeStamp;
  final String title;

  CategoryModel(this.id, this.timeStamp, this.title);

  getId() {
    return id;
  }

  getTimestamp() {
    return timeStamp;
  }

  getTitle() {
    return title;
  }
}
