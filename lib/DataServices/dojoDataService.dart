import 'dart:io';
import 'dart:core';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/httP.dart' as http;
import 'package:verb_client/Domain/dojo.dart';
import 'package:verb_client/Domain/verb.dart';

import 'httpContants.dart';

class DojoDataService {
  Future<List> getDojos() async {
    final dojoUrl = HttpConstants.domain + HttpConstants.dojoApi;
    http.Response response = await http.get(dojoUrl);

    if (response.statusCode == HttpStatus.ok) {
      final dojoJsonArray = json.decode(response.body);
      List dojoList =
          dojoJsonArray.map((dojoJson) => Dojo.fromJson(dojoJson)).toList();

      return dojoList;
    }

    return null;
  }

  Future<List> getVerbs(int dojoId) async {
    final verbsUrl =
        HttpConstants.domain + HttpConstants.verbApi + "/" + dojoId.toString();

    debugPrint('getVerbs: ' + verbsUrl);

    http.Response response = await http.get(verbsUrl);

    if (response.statusCode == HttpStatus.ok) {
      final verbJsonArray = json.decode(response.body);
      List verbList =
          verbJsonArray.map((verbJson) => Verb.fromJson(verbJson)).toList();

      return verbList;
    }

    return null;
  }
}
