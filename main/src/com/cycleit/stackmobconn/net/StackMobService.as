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
package com.cycleit.stackmobconn.net {

	import com.cycleit.stackmobconn.event.LoginEvent;
	import com.cycleit.stackmobconn.util.StackMobUtils;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]
	[Event(name = "stackMobLogin", type = "com.cycleit.stackmobconn.event.LoginEvent")]
	[Event(name = "stackMobLoginError", type = "com.cycleit.stackmobconn.event.LoginEvent")]
	public class StackMobService implements IEventDispatcher {

		static public const ACCEPT_HEADER:String = "Accept";

		static public const ACCEPT_JSON:String = "application/vnd.stackmob+json; version=0";

		static public const CONTENT_TYPE_HEADER:String = "Content-Type";

		static public const X_WWW_FORM_URLENCODED:String = "application/x-www-form-urlencoded";

		static public const X_STACKMOB_API_KEY_HEADER:String = "X-StackMob-API-Key";

		static public const X_STACKMOB_USER_AGENT_HEADER:String = "X-StackMob-User-Agent";

		static public const STACKMOB_API_URL:String = "http://api.stackmob.com";

		static public const X_STACKMOB_AS3_USER_AGENT:String = "SM AS3 0.0.1";

		static public const STACKMOB_LOGIN_URL:String = STACKMOB_API_URL + "/user/accessToken";

		private var _credentials:Object;

		public function get credentials():Object {
			return _credentials;
		}

		public function get data():Object {
			return JSON.parse(_loader.data);
		}

		private var _XStackMobAPIKey:String;

		private var _headers:Array;

		private var _loader:URLLoader;

		public function StackMobService(XStackMobAPIKey:String) {
			_XStackMobAPIKey = XStackMobAPIKey;
			_loader = new URLLoader();
			configureRequestHeaders();
		}

		public function load(request:URLRequest):void {
			_loader.load(request);
		}

		private function configureRequestHeaders():void {
			_headers = [];
			_headers[0] = new URLRequestHeader(ACCEPT_HEADER, ACCEPT_JSON);
			_headers[1] = new URLRequestHeader(CONTENT_TYPE_HEADER, X_WWW_FORM_URLENCODED);
			_headers[2] = new URLRequestHeader(X_STACKMOB_API_KEY_HEADER, _XStackMobAPIKey);
			_headers[3] = new URLRequestHeader(X_STACKMOB_USER_AGENT_HEADER, X_STACKMOB_AS3_USER_AGENT);
		}

		public function login(username:String, password:String):void {
			var request:URLRequest = new URLRequest(STACKMOB_LOGIN_URL);
			request.method = URLRequestMethod.POST;
			var params:URLVariables = new URLVariables();
			params['username'] = username;
			params['password'] = password;
			params['token_type'] = 'mac';
			request.data = params;
			request.requestHeaders = _headers;
			_loader.addEventListener(Event.COMPLETE, loginResultHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, loginErrorHandler);
			_loader.load(request);
		}

		private function loginResultHandler(event:Event):void {
			_loader.removeEventListener(Event.COMPLETE, loginResultHandler);
			_credentials = JSON.parse(_loader.data);
			_loader.dispatchEvent(new LoginEvent(LoginEvent.LOGIN));
		}

		private function loginErrorHandler(event:Event):void {
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, loginErrorHandler);
			_loader.dispatchEvent(new LoginEvent(LoginEvent.LOGIN_ERROR));
		}

		public function get(domain:String, params:Object = null):void {
			call(URLRequestMethod.GET, domain, params);
		}

		public function post(domain:String, params:Object = null):void {
			call(URLRequestMethod.POST, domain, params);
		}

		public function put(domain:String, params:Object = null):void {
			call(URLRequestMethod.PUT, domain, params);
		}

		public function del(domain:String, params:Object = null):void {
			call(URLRequestMethod.DELETE, domain, params);
		}

		private function call(method:String, domain:String, params:Object = null):void {
			var request:URLRequest = new URLRequest(STACKMOB_API_URL + "/" + domain);
			request.method = method;
			request.data = params;
			insertAuthorizationHeader(request.method, domain);
			request.requestHeaders = _headers;
			_loader.load(request);
		}

		private function insertAuthorizationHeader(method:String, domain:String):void {
			_headers[4] = new URLRequestHeader('Authorization',
											   StackMobUtils.generateAuthorization(method, _credentials.mac_key,
																				   _credentials.access_token,
																				   STACKMOB_API_URL, domain));
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0,
										 useWeakReference:Boolean = false):void {
			_loader.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function dispatchEvent(event:Event):Boolean {
			return _loader.dispatchEvent(event);
		}

		public function hasEventListener(type:String):Boolean {
			return _loader.hasEventListener(type);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_loader.removeEventListener(type, listener, useCapture);
		}

		public function willTrigger(type:String):Boolean {
			return _loader.willTrigger(type);
		}
	}
}
