import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/company_controller.dart';
import '../controllers/auth_controller.dart';
import 'company_detail_screen.dart';
import 'feedback_screen.dart';

class CompanyListScreen extends StatelessWidget {
  const CompanyListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CompanyController());
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Companies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.logout();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.companies.length,
                itemBuilder: (context, index) {
                  final company = controller.companies[index];

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(company.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle:
                      Text('${company.industry} • ${company.country}'),
                      trailing: Obx(() => IconButton(
                        icon: Icon(
                          controller.favorites.contains(company.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () =>
                            controller.toggleFavorite(company.id),
                      )),
                      onTap: () =>
                          Get.to(() => CompanyDetailScreen(company: company)),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.feedback),
                label: const Text('Give Feedback'),
                onPressed: () => Get.to(() => FeedbackScreen()),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
