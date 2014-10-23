import 'dart:io';
import 'package:args/args.dart';
import 'package:secret_sharing/secret_sharing.dart';
import 'console_util.dart';

const RAW = "raw";
const SHARES = "shares";


final ArgParser parser = new ArgParser();


void setupParser() {
  parser.addFlag(RAW, help: "Use this flag if input are raw shares",
      negatable: false);
  parser.addOption(SHARES, help: "The shares, divided by newline");
}


main(List<String> args) {
  setupParser();
  var result = parser.parse(args);
  
  var shares = result[SHARES] != null ? result[SHARES].split(",") :
    readShares();
  
  shares = shares.map((share) => result[RAW] ? new RawShare(share) :
    new StringShare.parse(share)).toList();
  
  var decoder = result[RAW] ? new RawShareDecoder() : new StringShareDecoder();
  var secret = decoder.convert(shares);
  
  print(secret);
}


List<String> readShares() {
  print("Please enter the number of shares");
  var noOfShares = readNumber(errorMsg: "Please enter a number > 1",
      test: (n) => n > 1);
  
  var shares = [];
  for (int i = 1; i <= noOfShares; i++) {
    print("Please enter share no. $i");
    var str = stdin.readLineSync();
    shares.add(str);
  }
  
  return shares;
}