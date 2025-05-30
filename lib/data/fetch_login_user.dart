import 'package:supabase_flutter/supabase_flutter.dart';

class FetchLoginUser {

  Future<Map<String, dynamic>?> getUserByFamilyBookAndPassword({
  required String familyBookId,
  required String password,
}) async {
   final supabase = Supabase.instance.client;
  final response = await supabase
      .from('user_account')
      .select('*, Person(*)')
      .eq('password', password)
      .eq('Person.Family_Card_Id', familyBookId)
      .maybeSingle();

  return response;
}


}