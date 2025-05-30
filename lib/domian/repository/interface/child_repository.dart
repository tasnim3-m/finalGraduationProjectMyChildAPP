
import '../../model/child_model.dart';

// هاد الملف عبارة عن توثيق للميثودس الي احنا كتبناهم جوا ال impl
abstract class ChildRepository {
  Future<List<ChildModel>> getChildrenByFamilyBookNumber(
    String familyBookNumber,
  );
  Future<ChildModel> getChildBasicInfo(String childId);
    Future<bool> checkFamilyBookExists(String familyBookNumber);

}
