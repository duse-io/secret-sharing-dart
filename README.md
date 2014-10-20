secret-sharing-dart
===================

> **Warning:** This implementation has not been tested in production nor has it been examined by a security audit.
> All uses are your own responsibility.

This library is an implementation of (Shamir's Secret Sharing Algorithm)[http://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing].
It also uses the `Converter` and `Codec` framework of `dart:convert`.

To encode a secret, first import the library:

```dart
import 'package:secret_sharing/secret_sharing.dart';
```

If you want to encode an `int`-Secret, you'll have to use the `RawShareCodec`. Otherwise,
use the `StringShareCodec`.

Usage of the `RawShareCodec`
----------------------------

### Encoding

```dart
var codec = new RawShareCodec(3, 2);
var shares = codec.encode(900000000000000);
```

This produces shares in the form of `x-y`, where x and y are hex values.

### Decoding

```dart
var decoded = codec.decode(shares);
```

This should reproduce the secret int (if the number of given shares is sufficient).

Usage of the `StringShareCodec`
-------------------------------

### Encoding

The `StringShareCodec` needs a charset as initialization parameter. If you want
to use an adaptive charset based on the secret you want to encode then use the
`bySecret`-Constructor. Otherwise, pass the Charset to the constructor (an included
Charset is the `ASCIICharset`).

Having obtained the codec, you can encode and decode like described before.

### Decoding

Decoding works the same as for `RawShare`s.


Command Line Tools
------------------

For the command line, there are two tools: The `secret_encoder` and the `secret_decoder`.
Those tools enable quick access for share generation and secret recovering and have both
an included help via `--help`.

Btw, this library is compatible to (flower-pot's Ruby implementation of Shamir's Secret Sharing)[https://github.com/flower-pot/secret_sharing].
