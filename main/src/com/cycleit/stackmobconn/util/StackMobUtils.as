/*############################################################################*/
/*                                                                            */
/*   Cycle-IT                                                                 */
/*   Copyright @2012                                                          */
/*   All rights reserved.                                                     */
/*																			  */
/*   NOTICE: Cycle-IT permits you to use, modify, and distribute this file    */
/*   in accordance with the terms of the license agreement accompanying it.   */
/*                                                                            */
/*############################################################################*/
package com.cycleit.stackmobconn.util {

	import com.adobe.crypto.HMAC;
	import com.adobe.crypto.SHA1;
	import com.sociodox.utils.Base64;

	import flash.utils.ByteArray;

	public final class StackMobUtils {

		static private const NONCE:String = "n";

		static private const LINEFEED:String = "\u000A";

		public function StackMobUtils() {
		}

		static public function generateAuthorization(method:String, mackey:String, accessToken:String, host:String,
													 domain:String):String {

			var ts:Number = (new Date().time / 1000) | 0;
			var nonce:String = NONCE + ((Math.random() * 10000) | 0);

			var base:String = createBaseString(ts, nonce, method, host, domain);

			var bstring:String = HMAC.hash(accessToken, base, SHA1);

			var mac:String = encodeUTFBytes(bstring);

			var authorization:String = 'MAC id="' + mackey + '",ts="' + ts + '",nonce="' + nonce + '",mac="' + mac + '"';
			return authorization;
		}

		static private function createBaseString(ts:Number, nonce:String, method:String, uri:String, host:String,
												 port:uint = 80):String {
			return ts + LINEFEED + NONCE + LINEFEED + method + LINEFEED + uri + LINEFEED + host + LINEFEED + port + LINEFEED + LINEFEED;
		}

		static private function encodeUTFBytes(data:String):String {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(data);
			bytes.position = 0;
			return Base64.encode(bytes);
		}
	}
}
