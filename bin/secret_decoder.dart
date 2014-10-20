import 'dart:io';
import 'package:args/args.dart';
import 'package:secret_sharing/secret_sharing.dart';
import 'console_util.dart';

const RAW = "raw";


final ArgParser parser = new ArgParser();


void setupParser() {
  parser.addFlag(RAW, help: "Use this flag if input are raw shares",
      negatable: false);
}


main(List<String> args) {
  setupParser();
  var result = parser.parse(args);
  
  print("Please enter the number of shares");
  var noOfShares = readNumber(errorMsg: "Please enter a number > 1",
      test: (n) => n > 1);
  
  var shares = [];
  for (int i = 1; i <= noOfShares; i++) {
    print("Please enter share no. $i");
    var str = stdin.readLineSync();
    var share = result[RAW] ? new RawShare(str) : new StringShare.parse(str);
    shares.add(share);
  }
  
  var decoder = result[RAW] ? new RawShareDecoder() : new StringShareDecoder();
  var secret = decoder.convert(shares);
  
  print("Your secret is:");
  print(secret);
}