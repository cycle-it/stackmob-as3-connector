package com.cycleit.stackmobconn.event {

	import flash.events.Event;

	public class LoginEvent extends Event {

		static public const LOGIN:String = "stackMobLogin";

		static public const LOGIN_ERROR:String = "stackMobLoginError";

		public function LoginEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		override public function clone():Event {
			return new LoginEvent(type, bubbles, cancelable);
		}
	}
}
