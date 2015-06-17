package com.decalrus.event
{
	import com.decalrus.model.vo.MakeVO;
	
	import flash.events.Event;
	
	public class MakeEvent extends Event
	{
		private var _vo:MakeVO;
		private var _catId:int = 0;
		
		public function MakeEvent(type:String, vo:MakeVO, catId:int = 0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._vo = vo;
			this._catId = catId;
		}
		
		public function get vo():MakeVO
		{
			return this._vo;
		}
		
		public function get catId():int
		{
			return this._catId;
		}
		
		override public function clone():Event
		{
			return new MakeEvent(type, vo, catId, bubbles, cancelable);
		}
	}
}