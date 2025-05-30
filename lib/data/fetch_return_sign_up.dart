import 'package:supabase_flutter/supabase_flutter.dart';

class FetchReturnSignUp {
  final SupabaseClient _client;

  FetchReturnSignUp(this._client);

  Future<bool> checkAccountExists(String familyCardId) async {
    final List<dynamic> persons = await _client
        .from('Person')
        .select()
        .eq('Family_Card_Id', familyCardId);

    return persons.isNotEmpty;
  }


  Future<void> insertPerson({
    required String familyCardId,
    required String fatherId,
    required String motherId,
  }) async {
    await _client.from('Person').insert({
      'Family_Card_Id': familyCardId,
      'Father_National_Id': fatherId,
      'Mother_National_Id': motherId,
    });
  }


  Future<void> insertUser({
    required String familyCardId,
    required String phone,
    required String password,
  }) async {
    await _client.from('user_accounts').insert({
      'Family_Card_Id': familyCardId,
      'phone_number': phone,
      'password': password,
    });
  }
}
