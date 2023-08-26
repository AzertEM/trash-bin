class Photo {
  late int? id = 0;
  late String? photoName = "";
  Photo(int i, String imgString){
      this.photoName = imgString;
  }
  Map <String, dynamic> toMap(){
    var map = <String, dynamic>{
            'id': id,
            'photoName': photoName,
    };
    return map;
  }
  Photo.fromMap(Map<String, dynamic>map){
    id = map['id'];
    photoName = map ['photoName'];
  }
}