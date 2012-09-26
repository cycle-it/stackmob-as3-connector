# stackmob-as3-connector

StackMob AS3 oauth2 API Connector is an actionscript3 library that allows to consume StackMob REST services in compliance with OAuth2 protocol specification.

It is based on [Logging in with OAuth 2.0 documentation](https://gist.github.com/f5e8dc879f506c9a0268) provided by StackMob team.

## Source code

It's a Flex Library Project which the following structure:
  * main: Source code of the library
  * example: Source code of a Flex Mobile Project. You should import it into a new Flex Mobile Project.
  * libs: see dependencies below

## Dependencies

It depends on the following libraries (which are included in the project):

  * **[as3corelib](https://github.com/mikechambers/as3corelib)**: for the HMAC SHA-1 hash generation of the Authoritation header.
  * **[base64](http://www.sociodox.com/base64.html)**: for Base64 encoding the previous generated hash.

## Example

You should modify the flex mobile application that is living in the example folder:

    // Your public key
    public const XStackMobAPIKey:String = "";
    // Username. ie Bruce Wayne
    public const username:String = "";
    // Password. ie iambatman
    public const password:String = "";