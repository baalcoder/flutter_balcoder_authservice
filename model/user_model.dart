import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? key;
  String? email;
  String? name;
  String? lastName;
  String? phoneNumber;
  String? urlPhoto;
  String? userType;
  String? amountCoin;
  String? country;
  String? uid;
  Timestamp? lastLogin;
  Timestamp? createdDate;
  bool? emailVerified;
  bool? phoneVerified;
  bool? isNew;
  bool? isSubscribed;
  bool? isDeleted;

  UserModel({this.email, this.uid});

  UserModel.fromJson(dynamic obj) {
    this.key = obj['key'];
    this.email = obj['email'];
    this.name = obj['name'];
    this.lastName = obj['lastName'];
    this.phoneNumber = obj['phoneNumber'];
    this.urlPhoto = obj['urlPhoto'];
    this.userType = obj['userType'];
    this.amountCoin = obj['amountCoin'];
    this.country = obj['country'];
    this.lastLogin = obj['lastLogin'];
    this.createdDate = obj['createdDate'];
    this.emailVerified = obj['emailVerified'];
    this.phoneVerified = obj['phoneVerified'];
    this.isNew = obj['isNew'];
    this.isSubscribed = obj['isSubscribed'];
    this.isDeleted = obj['isDeleted'];
    this.uid = obj['uid'];
  }

  UserModel.fromSnapshot({data, id})
      : key = id,
        email = data["email"],
        name = data["name"],
        lastName = data["lastName"],
        phoneNumber = data["phoneNumber"],
        urlPhoto = data["urlPhoto"],
        userType = data["userType"],
        amountCoin = data["amountCoin"],
        country = data["country"],
        // lastLogin = data["lastLogin"],
        // createdDate = data["createdDate"],
        emailVerified = data["emailVerified"],
        phoneVerified = data["phoneVerified"],
        isNew = data["isNew"],
        isSubscribed = data["isSubscribed"],
        isDeleted = data["isDeleted"],
        uid = data["uid"];

  toJson() {
    return {
      "email": email,
      "name": name,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "urlPhoto": urlPhoto,
      "userType": userType,
      "amountCoin": amountCoin,
      "country": country,
      // "lastLogin": lastLogin,
      // "createdDate": createdDate,
      "emailVerified": emailVerified,
      "phoneVerified": phoneVerified,
      "isNew": isNew,
      "isSubscribed": isSubscribed,
      "isDeleted": isDeleted,
      "uid": uid,
    };
  }
}
