import 'dart:core';

class AdvertisementList {
  final String logo_url;
  final String name;
  final String location;
  final String fees;
  final String selection_rate;
  final String top_rank;
  final String in_top_100;
  final String rating;

  AdvertisementList(this.logo_url, this.name, this.location, this.fees, this.selection_rate,
      this.top_rank, this.in_top_100, this.rating);
}

List<AdvertisementList> advertisementList = [
  AdvertisementList("images/smicon22.png", "ABC Institute", "New Delhi", "₹ 1.7 Lakhs", "97%", "AIR 5", "33", "4.7"),
  AdvertisementList("images/smicon22.png", "Career Institute", "New Delhi", "₹ 1.9 Lakhs", "90%", "AIR 14", "27", "4.8"),
  AdvertisementList("images/smicon22.png", "Super Institute", "Kota", "₹ 1.4 Lakhs", "92%", "AIR 32", "5", "4.9"),
  AdvertisementList("images/smicon22.png", "XYZ Institute", "Hyderabad", "₹ 2.1 Lakhs", "82%", "AIR 2", "8", "4.8"),
  AdvertisementList("images/smicon22.png", "Medical Classes", "Kolkata", "₹ 2 Lakhs", "94%", "AIR 21", "12", "4.2")
];