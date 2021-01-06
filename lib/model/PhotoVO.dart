class PhotoVO {
  int id;
  String imageString;
  String wearON;
  String isFav;

  PhotoVO(this.imageString, this.wearON, this.isFav);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map["id"] = id;
    }
    map["image"] = imageString;
    map["wear_type"] = wearON;
    map["favourite"] = isFav;
    return map;
  }

  PhotoVO.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    imageString = map['image'];
    wearON = map['wear_type'];
    isFav = map['favourite'];
  }
}