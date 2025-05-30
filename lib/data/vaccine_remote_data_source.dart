import 'package:supabase_flutter/supabase_flutter.dart';

class VaccineRemoteDataSource {
  final SupabaseClient client;
  VaccineRemoteDataSource(this.client);

  Future<Map<String, dynamic>> fetchPersonByNationalId(String nationalId) async {
    final result = await client
        .from('Person')
        .select('Birth_Date')
        .eq('National_Id', nationalId)
        .single();
    return result;
  }

  Future<List<Map<String, dynamic>>> fetchVaccineDosesAge() async {
    final result = await client
        .from('Vax_Doses_Age')
        .select('id, vax_id, dose_num, dose_age, Vax(Vax_Name, max_delay)');
    return List<Map<String, dynamic>>.from(result);
  }

  Future<List<Map<String, dynamic>>> fetchTakenVaccineIds(String personId) async {
  final data = await client
      .from('PersonVaxCard')
      .select('VaxCard_ID, Dose_Num')
      .eq('Person_ID', personId);

  return List<Map<String, dynamic>>.from(data);
}

}
