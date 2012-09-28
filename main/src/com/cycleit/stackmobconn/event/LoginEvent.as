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

	/**
	 * The LoginEvent class represents the event for login into StackMob REST services operations.
	 */
	public class LoginEvent extends Event {

		/**
		 *  The <code>LoginEvent.LOGIN</code> constant defines the value of the
		 *  <code>type</code> property of the event object for an <code>stackMobLogin</code> event.
		 *
		 *  <p>This event will only be dispatched when a succesful login occurs and there are one or more relevant listeners
		 *  attached to the dispatching object.</p>
		 *
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
		 *       event listener that handles the event. For example, if you use
		 *       <code>myButton.addEventListener()</code> to register an event listener,
		 *       myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
		 *       it is not always the Object listening for the event.
		 *       Use the <code>currentTarget</code> property to always access the
		 *       Object listening for the event.</td></tr>
		 *  </table>
		 *
		 *  @eventType stackMobLogin
		 *
		 *  @langversion 3.0
		 */
		static public const LOGIN:String = "stackMobLogin";

		/**
		 *  The <code>LoginEvent.LOGIN_ERROR</code> constant defines the value of the
		 *  <code>type</code> property of the event object for an <code>stackMobLoginError</code> event.
		 *
		 * <p>This event will only be dispatched when login fails and there are one or more relevant listeners
		 * attached to the dispatching object.</p>
		 *
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
		 *       event listener that handles the event. For example, if you use
		 *       <code>myButton.addEventListener()</code> to register an event listener,
		 *       myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
		 *       it is not always the Object listening for the event.
		 *       Use the <code>currentTarget</code> property to always access the
		 *       Object listening for the event.</td></tr>
		 *  </table>
		 *
		 *  @eventType stackMobLogin
		 *
		 *  @langversion 3.0
		 */
		static public const LOGIN_ERROR:String = "stackMobLoginError";

		/**
		 *  Constructor.
		 *
		 *  @param type The event type; indicates the action that caused the event.
		 *
		 *  @param bubbles Specifies whether the event can bubble up
		 *  the display list hierarchy.
		 *
		 *  @param cancelable Specifies whether the behavior
		 *  associated with the event can be prevented.
		 *
		 *  @langversion 3.0
		 */
		public function LoginEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		/**
		 * @private
		 */
		override public function clone():Event {
			return new LoginEvent(type, bubbles, cancelable);
		}
	}
}
