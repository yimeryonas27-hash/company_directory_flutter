import 'package:get/get.dart';
import '../models/company.dart';
import '../services/api_service.dart';
import 'auth_controller.dart';

class CompanyController extends GetxController {
  var companies = <Company>[].obs;
  var favorites = <int>[].obs;
  var isLoading = true.obs;

  final authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    fetchCompanies();
    loadFavorites();
  }

  void fetchCompanies() async {
    try {
      isLoading(true);
      companies.value = await ApiService.fetchCompanies();
    } finally {
      isLoading(false);
    }
  }

  void loadFavorites() async {
    final userData = await authController.getCurrentUserData();
    if (userData != null) {
      favorites.value =
      List<int>.from(userData['favorites'] ?? []);
    }
  }

  void toggleFavorite(int id) async {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }

    final userData = await authController.getCurrentUserData();
    if (userData != null) {
      userData['favorites'] = favorites;
      await authController.updateCurrentUser(userData);
    }
  }
}
