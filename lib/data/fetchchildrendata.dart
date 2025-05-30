import 'package:supabase_flutter/supabase_flutter.dart';

class ChildrenData {
  Future<PostgrestList> fetchChildrenByFamilyBookNumber(
    String familyBookNumber,
  ) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('Person')
          .select()
          .eq('Family_Card_Id', familyBookNumber);

      if (response.isEmpty) {
        throw Exception('No data found for this family book number.');
      }

      return response;
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<Map<String, dynamic>> fetchChildBasicInfo(String childId) async {
    final supabase = Supabase.instance.client;

    try {
      final response =
          await supabase
              .from('Person')
              .select('National_Id,First_Name, Last_Name, Birth_Date, Gender')
              .eq('National_Id', childId)
              .single();

      if (response.isEmpty) {
        throw Exception('No child found with this ID.');
      }

      return Map<String, dynamic>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch child info: $e');
    }
  }

  Future<bool> checkFamilyBookExists(String familyBookNumber) async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('Person')
          .select('Family_Card_Id')
          .eq('Family_Card_Id', familyBookNumber)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('Error checking family book: $e');
    }
  }
}
