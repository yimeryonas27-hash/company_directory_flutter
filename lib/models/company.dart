class Company {
  final int id;
  final String name;
  final String address;
  final String zip;
  final String country;
  final int employeeCount;
  final String industry;
  final int marketCap;
  final String domain;
  final String logo;
  final String ceoName;

  Company({
    required this.id,
    required this.name,
    required this.address,
    required this.zip,
    required this.country,
    required this.employeeCount,
    required this.industry,
    required this.marketCap,
    required this.domain,
    required this.logo,
    required this.ceoName,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      zip: json['zip'],
      country: json['country'],
      employeeCount: json['employeeCount'],
      industry: json['industry'],
      marketCap: json['marketCap'],
      domain: json['domain'],
      logo: json['logo'],
      ceoName: json['ceoName'],
    );
  }
}
