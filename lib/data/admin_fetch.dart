import 'package:supabase_flutter/supabase_flutter.dart';
class AdminFetch {
 Future<Map<String, dynamic>> fetchHCPLoginMethod(
    //بس ترجع داتا من الداتا بس على شكل ماب
    String username,
    String password,
  ) async {
    final supabase = Supabase.instance.client;
    try {
      final response =
          await supabase
              .from('Admin')
              //بترجع ليست
              .select('User_Name, First_Name,Last_Name,Employee_Id')
              //زي كانها جملة شرط
              .eq('User_Name', username)
              .eq('password', password)
              //بتجيب بس عنصر واحد
              .single();

      if (response.isEmpty) {
        throw Exception('لم يتم العثور على الحساب');
      }

      return response;
    } catch (e) {
      throw Exception('خطأ في الاتصال بقاعدة البيانات: $e');
    }
  }
  

 
}
