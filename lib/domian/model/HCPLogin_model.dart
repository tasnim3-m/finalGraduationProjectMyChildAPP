class AdminModel {
  //هون انا بعتت داتا للسوبا بيس

  final String userName;
  final String password;

  AdminModel({required this.userName, required this.password});
}

class AdminInformRespond {
  //الداتا يلي رح ترجع من الداتا بيس
  final String User_Name;
  final String First_Name;
  final String Last_Name;
  final int Employee_Id;
  AdminInformRespond({
    required this.User_Name,
    required this.First_Name,
    required this.Last_Name,
    required this.Employee_Id,
  });

  factory AdminInformRespond.fromMap(Map<String, dynamic> map) {
    return AdminInformRespond(
      //هون عم ابعت الداتا يلي جبتها من السوبابيس على شكل ماب الى الاوبجكت
      //حولها من ماب الى مودل او اوبجكت 
      User_Name: map['User_Name'],
      First_Name: map['First_Name'],
      Last_Name: map['Last_Name'],
      Employee_Id: map['Employee_Id'],
    );
  }
}
