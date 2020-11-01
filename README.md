# p-adic Cryto Ruby
Ruby code for a leveled FHE scheme by David W. H. A. da Silva, dhonorio@uccs.edu.

## Requirements

This code requires Ruby installed on your system. There are [several options for downloading and installing Ruby](https://www.ruby-lang.org/en/downloads/ "Download Ruby").

This project uses only Ruby standard libraries, so once you have Ruby installed (version 2.6.3 and greater), you have everything required to run the code. We tested our implementation on Mac OSX version 10.13.6 with ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-darwin17].

## Usage

### Running tests

Once Ruby is installed on your machine, from the command line and in the root directory of the project, run the tests to check the code with the following command:

`$ rake`

You should get a result similiar to the following:

```console
Run options: --seed 9109

# Running:

...........

Finished in 5.316182s, 2.0692 runs/s, 9.0290 assertions/s.

11 runs, 48 assertions, 0 failures, 0 errors, 0 skips
```

### Ruby Interactive Shell

You can also run code from the Ruby Interactive Shell (IRB). From the project's root directory, execute the following command on the terminal:

`$ irb`

You will see the IRB's prompt. Next, command snippets for specific cases that can be executed on IRB.

#### Key Generation

Require the file the will boot the entire project on IRB:

`> require './p-adic-crypto'`

Create the secret key object `k` with the required secret and public variables by passing the security parameter as argument (which defines the bit size of the secret prime numbers):

`> k = Gen.new 32`

Encrypt the number 219:

`> c1 = PAdicCrypto.encrypt(k,219)`

Encrypt the number 173:

`> c2 = PAdicCrypto.encrypt(k,173)`

Add c1 and c2:

`> c1_plus_c2 = PAdicCrypto.add(k.g,c1,c2)`

Subtract c1 and c2:

`> c1_minus_c2 = PAdicCrypto.sub(k.g,c1,c2)`

Multiply c1 and c2:

`> c1_times_c2 = PAdicCrypto.mul(k.g,c1,c2)`

Decrypt c1_plus_c2

`> PAdicCrypto.decrypt(k,c1_plus_c2)`

which returns

`=> 392`

and we see that the result equals to 219 + 173 = 392

Decrypt c1_minus_c2

`> PAdicCrypto.decrypt(k,c1_minus_c2)`

which returns

`=> 46`

and we see that the result equals to 219 - 173 = 46

Decrypt c1_times_c2:

`> PAdicCrypto.decrypt(k,c1_times_c2)`

which returns

`=> 37887`

and we see that the result equals to 219 * 173 = 37887
