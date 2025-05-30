// ignore_for_file: non_constant_identifier_names

class ChildModel {
  final String id;
  final String First_Name;
  final String Last_Name;
  final String birthDate;
  final String Gender;

  //National_Id,First_Name, Last_Name, Birth_Date, Gender,Phone_Number,
  //Vax_Card_Id,Mother_National_Id,Father_National_Id,
  //Family_Card_IdRegions,Health_Center,
  ChildModel({
    required this.id,
    required this.First_Name,
    required this.Last_Name,
    required this.birthDate,
    required this.Gender,
  });

  factory ChildModel.fromMap(Map<String, dynamic> map) {
    return ChildModel(
      id: map['National_Id'].toString(),
      First_Name: map['First_Name'] ?? '',
      Last_Name: map['Last_Name'] ?? '',
      birthDate: map['Birth_Date'] ?? '',
      Gender: map['Gender'] ?? '',
    );
  }
}
