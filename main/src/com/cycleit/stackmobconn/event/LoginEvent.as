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
