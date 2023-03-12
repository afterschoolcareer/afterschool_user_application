import 'dart:core';

class AdvertisementList {
  final int id;
  final String logo_url;
  String name;
  final String location;
  final String fees;
  final String selection_rate;
  final String top_rank;
  final String in_top_100;
  final String rating;

  AdvertisementList(this.id, this.logo_url, this.name, this.location, this.fees, this.selection_rate,
      this.top_rank, this.in_top_100, this.rating);
}

List<AdvertisementList> advertisementList = [
  AdvertisementList(190, "images/smicon22.png", "ABC Institute", "New Delhi", "₹ 1.7 Lakhs", "97%", "AIR 5", "33", "4.7"),
  AdvertisementList(191, "images/smicon22.png", "Career Institute", "New Delhi", "₹ 1.9 Lakhs", "90%", "AIR 14", "27", "4.8"),
  AdvertisementList(192, "images/smicon22.png", "Super Institute", "Kota", "₹ 1.4 Lakhs", "92%", "AIR 32", "5", "4.9"),
  AdvertisementList(193, "images/smicon22.png", "XYZ Institute", "Hyderabad", "₹ 2.1 Lakhs", "82%", "AIR 2", "8", "4.8"),
  AdvertisementList(194, "images/smicon22.png", "Medical Classes", "Kolkata", "₹ 2.0 Lakhs", "94%", "AIR 21", "12", "4.2")
];
