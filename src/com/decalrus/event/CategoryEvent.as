package com.decalrus.event
{
	import com.decalrus.model.vo.CategoryVO;
	
	import flash.events.Event;
	
	public class CategoryEvent extends Event
	{
		private var _vo:CategoryVO;
		
		public function CategoryEvent(type:String, vo:CategoryVO, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._vo = vo;
		}
		
		public function get vo():CategoryVO
		{
			return this._vo;
		}
		
		override public function clone():Event
		{
			return new CategoryEvent(type, this._vo, bubbles, cancelable);
		}
	}
}