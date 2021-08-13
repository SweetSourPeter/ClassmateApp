import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

class CollegeDomain {
  List<String> domains;
  List<String> webPages;
  String name;
  String alphaTwoCode;
  Null stateProvince;
  String country;

  CollegeDomain(
      {this.domains,
      this.webPages,
      this.name,
      this.alphaTwoCode,
      this.stateProvince,
      this.country});

  CollegeDomain.fromJson(Map<String, dynamic> json) {
    domains = json['domains'].cast<String>() ?? '';
    webPages = json['web_pages'].cast<String>() ?? '';
    name = json['name'] ?? '';
    alphaTwoCode = json['alpha_two_code'] ?? '';
    // stateProvince = json['state-province'] ?? '';
    country = json['country'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domains'] = this.domains ?? '';
    data['web_pages'] = this.webPages ?? '';
    data['name'] = this.name ?? '';
    data['alpha_two_code'] = this.alphaTwoCode ?? '';
    // data['state-province'] = this.stateProvince ?? '';
    data['country'] = this.country ?? '';
    return data;
  }
}

class CollgeDomainApi {
  // ignore: missing_return
  // static Future<bool> checkCollegeName(String query) async {
  //   final url = Uri.parse(
  //       'http://universities.hipolabs.com/search?country=UNITED%20STATES');
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     List<CollegeDomain> _collegeDomain = [];
  //     final List colleges = json.decode(response.body);
  //     _collegeDomain =
  //         colleges.map((json) => CollegeDomain.fromJson(json)).where((college) {
  //       colleges
  //       return nameLower.equal(queryLower);
  //     }).toList();
  //   } else {
  //     throw Exception();
  //   }
  // }

  static Future<List<CollegeDomain>> getCollegeSuggestions(String query) async {
    // final String response =
    //     await rootBundle.loadString('assets/data/UsCollegeDomains.json');
    // final data = await json.decode(response);
    // return _collegeDomain =
    //     await data.map((json) => CollegeDomain.fromJson(json)).toList();

    // https://universities.hipolabs.com/search?name=boston%20university
    // http://universities.hipolabs.com/search?country=UNITED%20STATES
    final url = Uri.parse(
        'http://universities.hipolabs.com/search?country=UNITED%20STATES');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<CollegeDomain> _collegeDomain = [];
      final List colleges = json.decode(response.body);
      return colleges
          .map((json) => CollegeDomain.fromJson(json))
          .where((college) {
        final nameLower = college.name.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
  // final response = await http.get(Uri.parse(url));
  // List<CollegeDomain> _collegeDomain = [];
  // print('API CALLED');
  // if (response.statusCode == 200) {
  // // print('object');
  // await http.get(Uri.parse(url), headers: {
  //   HttpHeaders.authorizationHeader: "...",
  //   "Accept": "application/json"
  // }).then((data) {
  //   final List colleges = json.decode(data.body);
  //   // print(colleges.toString());

  //   // print(_collegeDomain[0].name.toString());
  //   // return _collegeDomain;
  // }).catchError((e) {
  //   // print('object1');
  //   print(e);
  // });
  // }
}
