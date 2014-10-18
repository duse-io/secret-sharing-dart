import 'dart:io';
import "package:args/args.dart";
import "package:secret_sharing/secret_sharing.dart";
import "console_util.dart";

const RAW = "raw";

final ArgParser parser = new ArgParser();

void setupParser() {
  parser.addFlag(RAW, abbr: "r", help: "If the input is an int, this " +
      "generates raw shares", negatable: false);
}


main(List<String> args) {
  setupParser();
  var result = parser.parse(args);
  
  print("Please enter your secret");
  var secret = stdin.readLineSync();
  if (result[RAW]) secret = int.parse(secret);
  
  print("Please enter the number of total shares");
  var noOfShares = readNumber(errorMsg: "Please enter a valid number > 1",
      test: (arg) => arg > 1);
  
  print("Please enter the number of needed shares");
  var neededShares = readNumber(errorMsg: "Please enter a valid number > 1 " +
      "and smaller or equal the number of total shares",
      test: (arg) => arg > 0 && arg <= noOfShares);
  
  ShareCodec converter = result[RAW] ? new RawShareCodec(noOfShares, neededShares) :
    new StringShareCodec(noOfShares, neededShares);
  
  var shares = converter.encode(secret);
  shares.forEach((share) => print(share));
}