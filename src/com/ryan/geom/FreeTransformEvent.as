package com.ryan.geom
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * FreeTransformEvent
	 * 
	 * @author Ryan
	 */
	public class FreeTransformEvent extends Event
	{
		public static const ON_TRANSFORM:String = "ontransform";		
		public var targetObject:DisplayObject;
		public var x:Number;
		public var y:Number;
		public var _rotation:Number;
		public var scale:Number;

		public function FreeTransformEvent(type:String, targetObject:DisplayObject, x:Number, y:Number, rotation:Number, scale:Number, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.targetObject = targetObject;
			this.x = x;
			this.y = y;
			this._rotation = rotation;
			this.scale = scale;
		}
		
		public function get rotation():Number
		{
			return _rotation;
		}
		
		public function get rotationInDeg():Number
		{
			return _rotation / (Math.PI / 180);
		}
		
		override public function clone():Event
		{
			return new FreeTransformEvent(this.type, this.targetObject, this.x, this.y, this._rotation, this.scale);
		}
	}
}
