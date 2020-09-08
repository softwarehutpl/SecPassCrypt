# SecPassCrypt

It's  a playground for encryption & secure storage in Flutter.

Keep your secrets secret with SecPassCrypt. This App allows you to store
any text you like. Stored text is encrypted using method of user choice &
same method is requested to decrypt it.

## Available login methods
* password
* pattern
* pin
* biometric

## Tech Stack

RSA Keys are used for encryption/decryption of entries. RSA Keys are generated
once when user setup login method and then are stored as encrypted PEMs within
Shared Preferences or are stored within biometric encrypted file as PEMs.

* [BLoC & Provider](https://pub.dev/packages/flutter_bloc)
\- for business logic & dependency injection.
* [Pattern Lock](https://pub.dev/packages/pattern_lock)
\- to be used as one of login method.
* [pin_code_fields](https://pub.dev/packages/pin_code_fields)
\- for another login method.
* [biometric_storage](https://pub.dev/packages/biometric_storage)
\- yet another login method. Plus biometric encrypted safe persistent storage.
* [Pointy Castle](https://pub.dev/packages/pointycastle), [rsa_encrypt](https://pub.dev/packages/rsa_encrypt), [encrypt](https://pub.dev/packages/encrypt),
\- enable RSA encryption of the text entries.
Which is needed for ML Kit to work properly.
* [flutter_string_encryption](https://pub.dev/packages/flutter_string_encryption)
\- password-based string encryption to encrypt keys PEMs while using other
login method than Biometric.
* [Shared preferences plugin](https://pub.dev/packages/shared_preferences)
\- persistent storage.
* [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter)
\- for logout icon. Well it's not much but it's honest work :)
* [Moor](https://pub.dev/packages/moor#-readme-tab-)
\- persistent storage on top of sqlite.


## iOS config disclaimer
During development there were none iOS configuration done for project dependencies.  
So be aware that currently project can have issues with compiling for iOS.  
This will be addressed later down the line.  
PR with required changes are welcome.

## Database
If there is a need to add new table go to `lib/database/db.dart`.  
Please add table class. Once you define table add it's class to `tables`  
array in annotation for `Database` class.  
After that you should run
`flutter packages pub run build_runner build` in CLI to generate code or
just run `flutter packages pub run build_runner watch` to auto generate it
on every save.

Ref. [https://moor.simonbinder.eu/docs/getting-started/](https://moor.simonbinder.eu/docs/getting-started/)
