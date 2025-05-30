
import '../../model/vaccine_schedule_model.dart';

abstract class VaccineScheduleRepository {
  Future<List<VaccineScheduleModel>> getUpcomingVaccines({
    required String personId,
  });
}