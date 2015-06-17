package com.decalrus.event
{
	import flash.events.Event;
	
	public class ObjectEvent extends Event
	{
		private var _obj:Object;
		
		public function ObjectEvent(type:String, obj:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._obj = obj;
		}
		
		public function get object():Object
		{
			return this._obj;
		}
		
		override public function clone():Event
		{
			return new ObjectEvent(type, this._obj, bubbles, cancelable);
		}
	}
}