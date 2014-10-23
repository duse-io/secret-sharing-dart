import 'dart:io';
import "package:args/args.dart";
import "package:secret_sharing/secret_sharing.dart";
import "console_util.dart";

const RAW = "raw";
const ASCII = "ascii";
const SECRET = "secret";
const TOTAL = "total";
const NEEDED = "needed";

final ArgParser parser = new ArgParser();

void setupParser() {
  parser.addFlag(RAW, abbr: "r", help: "If the input is an int, this " +
      "generates raw shares", negatable: false);
  parser.addFlag(ASCII, help: "Should the shares be ASCII-Encoded?",
       negatable: false);
  parser.addOption(SECRET, help: "The secret which should be encoded");
  parser.addOption(TOTAL, help: "The total number of shares");
  parser.addOption(NEEDED,
      help: "The needed number of shares to recover the secret");
}


main(List<String> args) {
  setupParser();
  var result = parser.parse(args);
  
  var secret = result[SECRET] != null ? result[SECRET] :
    readSecret(raw: result[RAW]);
  
  var noOfShares = result[TOTAL] != null? int.parse(result[TOTAL]) :
    readNoOfShares();
  
  var neededShares = result[NEEDED] != null? int.parse(result[NEEDED]) :
    readNeededShares(noOfShares);
  
  var charset = result[ASCII] ? new ASCIICharset() :
    new DynamicCharset.create(secret);
  
  ShareCodec converter = result[RAW] ? new RawShareCodec(noOfShares, neededShares) :
    new StringShareCodec(noOfShares, neededShares, charset);
  
  var shares = converter.encode(secret);
  print(shares.join(","));
}


readSecret({bool raw: false}) {
  print("Please enter your secret");
  var secret = stdin.readLineSync();
  if (raw) secret = int.parse(secret);
  return secret;
}


int readNoOfShares() {
  print("Please enter the number of total shares");
  var noOfShares = readNumber(errorMsg: "Please enter a valid number > 1",
      test: (arg) => arg > 1);
  return noOfShares;
}


int readNeededShares(int noOfShares) {
  print("Please enter the number of needed shares");
  var neededShares = readNumber(errorMsg: "Please enter a valid number > 1 " +
      "and smaller or equal the number of total shares",
      test: (arg) => arg > 0 && arg <= noOfShares);
  return neededShares;
}