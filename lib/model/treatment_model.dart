// 'title': title,
// 'amount': amount,
// "timesPerDay": timesPerDay,
// "startTime": DateFormat('dd/MM/yyyy').format(dateTimeRange.start),
// "endTime": DateFormat('dd/MM/yyyy').format(dateTimeRange.end),
// 'photo': image,
// 'times_of_took': 0,
// 'finished': false,
// 'userID: ': FirebaseAuth.instance.currentUser!.uid
class TreatMentModel {
  String title;
  num amount;
  num duration;
  String startTime;
  String lastTimeTake;
  String photo;
  num times_of_took;
  bool finished;
  String userID;
  String id;
  String nameSound;
  TreatMentModel({
    required this.title,
    required this.amount,
    required this.duration,
    required this.photo,
    required this.times_of_took,
    required this.finished,
    required this.userID,
    required this.id,
    required this.startTime
    ,required this.lastTimeTake,
    required this.nameSound
  });

  Map<String, dynamic> toMap() {
    return {
      'title': this.title,
      'lastTimeTake':this.lastTimeTake,
      'startTime':this.startTime,
      'amount': this.amount,
      'duration': this.duration,
      'photo': this.photo,
      'times_of_took': this.times_of_took,
      'finished': this.finished,
      'userID': this.userID,
      'id': this.id,
      'sound':this.nameSound
    };
  }

  factory TreatMentModel.fromMap(Map<String, dynamic> map) {
    return TreatMentModel(
      title: map['title'] as String,
      startTime: map['startTime'] as String,
      lastTimeTake: map['lastTimeTake'] as String,
      amount: map['amount'] as num,
      duration: map['duration'] as num,
      nameSound: map['sound'] as String,
      photo: map['photo'] as String,
      times_of_took: map['times_of_took'] as num,
      finished: map['finished'] as bool,
      userID: map['userID'] as String,
      id: map['id'] as String,
    );
  }
}
