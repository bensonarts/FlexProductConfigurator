package com.decalrus.event
{
	import com.decalrus.model.vo.CustomOrderVO;
	
	import flash.events.Event;
	
	public class CustomOrderEvent extends Event
	{
		private var _vo:CustomOrderVO;
		
		public function CustomOrderEvent(type:String, vo:CustomOrderVO, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._vo = vo;
		}
		
		public function get vo():CustomOrderVO
		{
			return this._vo;
		}
		
		override public function clone():Event
		{
			return new CustomOrderEvent(type, vo, bubbles, cancelable);
		}
		
	}
}
