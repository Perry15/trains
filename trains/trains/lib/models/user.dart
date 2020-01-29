class User {
  final String uid;
  String displayName;
  String email;
  int valutationsPoints;
  int locationsPoints;
  int trainsPoints;
  double level;
  //constructor
  User({this.uid});

  /*
  @override
  String toString(){
    return "{"+this.uid+", "+this.displayName+", "+this.email+", "+this.valutationsPoints.toString()+", "+this.locationsPoints.toString()+", "+this.trainsPoints.toString()+", "+this.level.toString()+"}";
  }
  */
}
