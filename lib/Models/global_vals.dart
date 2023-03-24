import 'dart:core';

class GlobalVals {
  static String name = "";
  static String phone = "";
  static String type = "";
  static String email = "";

  static void setData(String n, String p, String t, String e) {
    name = n;
    phone = p;
    type = t;
    email = e;
  }

  static String getName() {
    return name;
  }

  static String getPhone() {
    return phone;
  }

  static String getType() {
    return type;
  }

  static String getEmail() {
    return email;
  }
}