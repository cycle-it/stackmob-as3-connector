# stackmob-as3-connector

StackMob AS3 oauth2 API Connector is an actionscript3 library that allows to consume StackMob REST services in compliance with OAuth2 protocol specification.

It is based on [Logging in with OAuth 2.0 documentation](https://gist.github.com/f5e8dc879f506c9a0268) provided by StackMob team.

## Source code

It's a Flex Library Project which the following structure:
  * main: Source code of the library
  * example: Source code of a Flex Mobile Project. You should import it into a new Flex Mobile Project.
  * libs: see [dependencies](#dependencies) below

## Dependencies

It depends on the following libraries (which are included in the project):

  * **[as3corelib](https://github.com/mikechambers/as3corelib)**: for the HMAC SHA-1 hash generation of the Authoritation header.
  * **[base64](http://www.sociodox.com/base64.html)**: for Base64 encoding the previous generated hash.

## Example

A functional example could be found under the example directory. 

### Step by step

First, modify the following constants:

    // Your public key
    public const XStackMobAPIKey:String = "";
    // Username. ie Bruce Wayne
    public const username:String = "";
    // Password. ie iambatman
    public const password:String = "";

Lets consider that we've created a **blogentry** schema in our StackMob development platform with the following structure:

  * id: blogentry ID
  * message: blogentry message

Now, we want populate this schema with data, consult it later, update some entries and delete the obsolete ones. So:

Create an StackMobService, using your public key (currently it uses development version only: 0):

    var smService:StackMobService = new StackMobService(XStackMobAPIKey);
    
Lets login with previous username and password:

    // login event fired after successful login
    smService.addEventListener(LoginEvent.LOGIN, loginHandler);
    // loginError event fired in case of error
    smService.addEventListener(LoginEvent.LOGIN_ERROR, loginErrorHandler);
    smService.login(username, password);
    
After login you could check your user credentials for further use:

    var credentials:Object = smService.credentials;

Now, you can request StackMob API. Every request fires an Event.COMPLETE in case of a HTTP OK response or an Event.IOErrorEvent in other case. In every case, you can check your StackMobService.data attribute in order to see the result or the error.

#### GET all entries

    smService.get("blogentry");
    
#### GET one entry
    
    smService.get("blogentry/" + entry.id);
    
#### POST an entry

    var entry:Object = {"message" : "A message"}
    smService.post("blogentry", entry);
    
#### PUT an entry

    var updatedEntry:Object = {"message" : "Updated message"}
    smService.put("blogentry/" + entry.id, updatedEntry);
    
#### DEL an entry

    var entry:Object = {"id" : id}
    smService.del("blogentry", entry);