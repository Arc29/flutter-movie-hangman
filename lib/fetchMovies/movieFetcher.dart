import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class Fetch {
  List<String> bolly,holly;
  Future<List<String>> fetchHolly() async{
//    bolly = await rootBundle.loadString('data/bollywood.txt');
    holly = (await rootBundle.loadString('data/worldmovies.txt')).split('\n');
//    print(holly);
    return holly;
  }
}