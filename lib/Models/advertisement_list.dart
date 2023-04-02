import 'dart:core';

class AdvertisementList {
  final int id;
  final String logo_url;
  final String name;
  final String location;

  AdvertisementList(this.id, this.logo_url, this.name, this.location);
}

List<AdvertisementList> advertisementList = [
  AdvertisementList(21, "images/handpicked/bansal.png", "Bansal Classes", "Kota"),
  AdvertisementList(14, "images/handpicked/resonance.jpg", "Resonance", "Kota"),
  AdvertisementList(15, "images/handpicked/motion.png", "Motion", "Kota"),
  AdvertisementList(23, "images/handpicked/jeeboard.png", "Jee Board Academy", "Delhi"),
  AdvertisementList(29, "images/handpicked/pace.jpg", "PACE IIT and MEdical", "Delhi")
];
