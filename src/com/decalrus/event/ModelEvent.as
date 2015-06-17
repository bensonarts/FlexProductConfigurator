package com.decalrus.event
{
	import com.decalrus.model.vo.ModelVO;
	
	import flash.events.Event;
	
	public class ModelEvent extends Event
	{
		private var _vo:ModelVO;
		
		public function ModelEvent(type:String, vo:ModelVO, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._vo = vo;
		}
		
		public function get vo():ModelVO
		{
			return this._vo;
		}
		
		override public function clone():Event
		{
			return new ModelEvent(type, vo, bubbles, cancelable);
		}
	}
}