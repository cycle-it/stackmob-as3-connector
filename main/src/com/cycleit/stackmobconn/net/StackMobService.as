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

	/**
	 *  Dispatched when a successful HTTP response occurs
	 *
	 *  @eventType flash.events.Event.COMPLETE
	 *
	 *  @langversion 3.0
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	/**
	 *  Dispatched when an error occurs
	 *
	 *  @eventType flash.events.IOErrorEvent.IO_ERROR
	 *
	 *  @langversion 3.0
	 */
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]
	/**
	 *  Dispatched when login occurs
	 *
	 *  @eventType com.cycleit.stackmobconn.event.LoginEvent
	 *
	 *  @langversion 3.0
	 */
	[Event(name = "stackMobLogin", type = "com.cycleit.stackmobconn.event.LoginEvent")]
	/**
	 *  Dispatched when login error occurs
	 *
	 *  @eventType com.cycleit.stackmobconn.event.LoginEvent
	 *
	 *  @langversion 3.0
	 */
	[Event(name = "stackMobLoginError", type = "com.cycleit.stackmobconn.event.LoginEvent")]
	/**
	 * StackMobService is a class that allows to connect to and consume StackMob REST services using its public API.
	 *
	 * For further reference check REST API reference at StackMob developer portal: https://developer.stackmob.com/tutorials/dashboard/REST-API-Reference
	 *
	 */
	public class StackMobService implements IEventDispatcher {

		/**
		 * StackMob SDK Development Version constant equals to <code>0</code>
		 */
		static public const DEVELOPMENT_VERSION:String = "0";

		/**
		 * StackMob SDK Production Version constant equals to <code>1</code>
		 */
		static public const PRODUCTION_VERSION:String = "1";

		/**
		 * StackMob ActionScript3 SDK versión
		 */
		static public const X_STACKMOB_AS3_USER_AGENT:String = "SM AS3 0.2.0";

		static private const ACCEPT_HEADER:String = "Accept";

		static private const ACCEPT_JSON:String = "application/vnd.stackmob+json; version=";

		static private const CONTENT_TYPE_HEADER:String = "Content-Type";

		static private const X_WWW_FORM_URLENCODED:String = "application/x-www-form-urlencoded";

		static private const APPLICATION_JSON:String = "application/json";

		static private const X_STACKMOB_API_KEY_HEADER:String = "X-StackMob-API-Key";

		static private const X_STACKMOB_USER_AGENT_HEADER:String = "X-StackMob-User-Agent";

		static private const STACKMOB_API_URL:String = "http://api.stackmob.com";

		static private const STACKMOB_LOGIN_URL:String = STACKMOB_API_URL + "/user/accessToken";

		static private const USERNAME:String = "username";

		static private const PASSWORD:String = "password";

		static private const TOKEN_TYPE:String = "token_type";

		static private const MAC_TOKEN_TYPE:String = "mac";

		private var _credentials:Object;

		/**
		 * Logged user credentials as specified at https://gist.github.com/f5e8dc879f506c9a0268
		 */
		public function get credentials():Object {
			return _credentials;
		}

		/**
		 * Result or error data in <code>json/object</code> format.
		 */
		public function get data():Object {
			return JSON.parse(_loader.data);
		}

		private var _XStackMobAPIKey:String;

		private var _stackMobVersion:String;

		private var _headers:Array;

		private var _loader:URLLoader;

		/**
		 *  Creates a new StackMobService instance.
		 *
		 *  @param XStackMobAPIKey Your Public development/production StackMob Key API.
		 *
		 *  @param stackMobVersion StackMob SDK Version @default 0.
		 *
		 *  @langversion 3.0
		 */
		public function StackMobService(XStackMobAPIKey:String, stackMobVersion:String = "0") {
			initializeService(XStackMobAPIKey, stackMobVersion);
		}

		/**
		 * @private
		 *
		 * Initializes the StackMobService
		 */
		private function initializeService(XStackMobAPIKey:String, stackMobVersion:String):void {
			_XStackMobAPIKey = XStackMobAPIKey;
			_stackMobVersion = stackMobVersion;
			_loader = new URLLoader();
			configureRequestHeaders();
		}

		/**
		 * @private
		 *
		 * Configures needed request headers:
		 *
		 * Accept: application/vnd.stackmob+json; version=0|1
		 * Content-type: application/x-www-form-urlencoded
		 * X-StackMob-API-Key: Public development or production key
		 * X-StackMob-User-Agent: Some string
		 */
		private function configureRequestHeaders():void {
			_headers = [];
			_headers[0] = new URLRequestHeader(ACCEPT_HEADER, ACCEPT_JSON + _stackMobVersion);
			_headers[1] = new URLRequestHeader(CONTENT_TYPE_HEADER, X_WWW_FORM_URLENCODED);
			_headers[2] = new URLRequestHeader(X_STACKMOB_API_KEY_HEADER, _XStackMobAPIKey);
			_headers[3] = new URLRequestHeader(X_STACKMOB_USER_AGENT_HEADER, X_STACKMOB_AS3_USER_AGENT);
		}

		/**
		 * Authenticates the user against StackMob REST API.
		 *
		 * <p>It'll check if the credentials are valid looking for provided <code>username</code> and <code>password</code> exist
		 * inside <code>users</code> schema.</p>
		 *
		 * <p>If a succesful login occurs, it will fire a <code>com.cycleit.stackmobconn.event.LoginEvent.LOGIN</code> event.</p>
		 * <p>In other case, it will fire a <code>com.cycleit.stackmobconn.event.LoginEvent.LOGIN_ERROR</code> event.</p>
		 *
		 * @param username Username
		 * @param password Password
		 *
		 * @see com.cycleit.stackmobconn.event.LoginEvent.LOGIN
		 * @see com.cycleit.stackmobconn.event.LoginEvent.LOGIN_ERROR
		 */
		public function login(username:String, password:String):void {
			var request:URLRequest = new URLRequest(STACKMOB_LOGIN_URL);
			request.method = URLRequestMethod.POST;
			var params:URLVariables = new URLVariables();
			params[USERNAME] = username;
			params[PASSWORD] = password;
			params[TOKEN_TYPE] = MAC_TOKEN_TYPE;
			request.data = params;
			request.requestHeaders = _headers;
			_loader.addEventListener(Event.COMPLETE, loginResultHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, loginErrorHandler);
			_loader.load(request);
		}

		/**
		 * @private
		 */
		private function loginResultHandler(event:Event):void {
			removeLoginHandlers();
			_credentials = JSON.parse(_loader.data);
			_loader.dispatchEvent(new LoginEvent(LoginEvent.LOGIN));
		}

		/**
		 * @private
		 */
		private function loginErrorHandler(event:Event):void {
			removeLoginHandlers();
			_loader.dispatchEvent(new LoginEvent(LoginEvent.LOGIN_ERROR));
		}

		/**
		 * @private
		 */
		private function removeLoginHandlers():void {
			_loader.removeEventListener(Event.COMPLETE, loginResultHandler);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, loginErrorHandler);
		}

		/**
		 * Retrieves objects.
		 *
		 * <p>Makes a GET request for retrieving info contained in the specified <code>domain</code> as a parameter (i.e. "<code>users</code>").</p>
		 *
		 * <p>It will fire a <code>flash.events.Event.COMPLETE</code> when there's a result available.
		 * The result, in <code>json</code> format, will be stored in the <code>data</code> attribute.</p>
		 *
		 * <p>In other case, it will fire a <code>flash.events.IOErrorEvent.IO_ERROR</code> event.
		 * The exact error will be stored in the <code>data</code></p>
		 *
		 * @param domain Domain/Schema that we want to request
		 * @param params Parameters for the request
		 *
		 * @see com.cycleit.stackmobconn.net.StackMobService#data()
		 * @see flash.events.Event.COMPLETE
		 * @see flash.events.IOErrorEvent.IO_ERROR
		 */
		public function get(domain:String, params:Object = null):void {
			call(URLRequestMethod.GET, domain, params);
		}

		/**
		 * Creates objects.
		 *
		 * <p>Makes a POST request for creating new objects in the specified <code>domain</code> as a parameter (i.e. "<code>users</code>").</p>
		 *
		 * <p>It will fire a <code>flash.events.Event.COMPLETE</code> when there's a result available.
		 * The result, in <code>json</code> format, will be stored in the <code>data</code> attribute.</p>
		 *
		 * <p>In other case, it will fire a <code>flash.events.IOErrorEvent.IO_ERROR</code> event.
		 * The exact error will be stored in the <code>data</code></p>
		 *
		 * @param domain Domain/Schema that we want to request
		 * @param params Parameters for the request
		 *
		 * @see com.cycleit.stackmobconn.net.StackMobService#data()
		 * @see flash.events.Event.COMPLETE
		 * @see flash.events.IOErrorEvent.IO_ERROR
		 */
		public function post(domain:String, params:Object = null):void {
			params = JSON.stringify(params);
			call(URLRequestMethod.POST, domain, params);
		}

		/**
		 * Updates objects.
		 *
		 * <p>Makes a PUT request for updating already existing objects in the specified <code>domain</code> as a parameter (i.e. "<code>users</code>").</p>
		 *
		 * <p>It will fire a <code>flash.events.Event.COMPLETE</code> when there's a result available.
		 * The result, in <code>json</code> format, will be stored in the <code>data</code> attribute.</p>
		 *
		 * <p>In other case, it will fire a <code>flash.events.IOErrorEvent.IO_ERROR</code> event.
		 * The exact error will be stored in the <code>data</code></p>
		 *
		 * @param domain Domain/Schema that we want to request
		 * @param params Parameters for the request
		 *
		 * @see com.cycleit.stackmobconn.net.StackMobService#data()
		 * @see flash.events.Event.COMPLETE
		 * @see flash.events.IOErrorEvent.IO_ERROR
		 */
		public function put(domain:String, params:Object = null):void {
			params = JSON.stringify(params);
			call(URLRequestMethod.PUT, domain, params);
		}

		/**
		 * Deletes objects.
		 *
		 * <p>Makes a DELETE request for deleting objects in the specified <code>domain</code> as a parameter (i.e. "<code>users</code>").</p>
		 *
		 * <p>It will fire a <code>flash.events.Event.COMPLETE</code> when there's a result available.
		 * The result, in <code>json</code> format, will be stored in the <code>data</code> attribute.</p>
		 *
		 * <p>In other case, it will fire a <code>flash.events.IOErrorEvent.IO_ERROR</code> event.
		 * The exact error will be stored in the <code>data</code></p>
		 *
		 * @param domain Domain/Schema that we want to request
		 * @param params Parameters for the request
		 *
		 * @see com.cycleit.stackmobconn.net.StackMobService#data()
		 * @see flash.events.Event.COMPLETE
		 * @see flash.events.IOErrorEvent.IO_ERROR
		 */
		public function del(domain:String, params:Object = null):void {
			call(URLRequestMethod.DELETE, domain, params);
		}

		/**
		 * @private
		 */
		private function call(method:String, domain:String, params:Object = null):void {
			var request:URLRequest = new URLRequest(STACKMOB_API_URL + "/" + domain);
			request.method = method;
			request.data = params;
			insertAuthorizationHeader(request.method, domain);
			request.requestHeaders = _headers;
			_loader.load(request);
		}

		/**
		 * @private
		 */
		private function insertAuthorizationHeader(method:String, domain:String):void {
			_headers[4] = new URLRequestHeader('Authorization',
											   StackMobUtils.generateAuthorization(method, _credentials.mac_key,
																				   _credentials.access_token,
																				   STACKMOB_API_URL, domain));
		}

		/**
		 * @private
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0,
										 useWeakReference:Boolean = false):void {
			_loader.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * @private
		 */
		public function dispatchEvent(event:Event):Boolean {
			return _loader.dispatchEvent(event);
		}

		/**
		 * @private
		 */
		public function hasEventListener(type:String):Boolean {
			return _loader.hasEventListener(type);
		}

		/**
		 * @private
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_loader.removeEventListener(type, listener, useCapture);
		}

		/**
		 * @private
		 */
		public function willTrigger(type:String):Boolean {
			return _loader.willTrigger(type);
		}
	}
}
