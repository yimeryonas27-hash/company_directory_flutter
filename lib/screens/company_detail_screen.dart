import 'package:flutter/material.dart';
import '../models/company.dart';

class CompanyDetailScreen extends StatelessWidget {
  final Company company;

  const CompanyDetailScreen({
    Key? key,
    required this.company,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(company.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    company.logo,
                    height: 80,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.business, size: 80),
                  ),
                ),
                const SizedBox(height: 16),
                info('CEO', company.ceoName),
                info('Industry', company.industry),
                info('Employees', company.employeeCount.toString()),
                info('Market Cap', company.marketCap.toString()),
                info('Domain', company.domain),
                info('Address', company.address),
                info('ZIP', company.zip),
                info('Country', company.country),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$title: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
