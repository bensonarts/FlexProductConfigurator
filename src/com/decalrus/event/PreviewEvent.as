package com.decalrus.event
{
	import com.decalrus.model.vo.PreviewVO;
	
	import flash.events.Event;
	
	public class PreviewEvent extends Event
	{
		private var _vo:PreviewVO;
		
		public function PreviewEvent(type:String, vo:PreviewVO, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._vo = vo;
		}
		
		public function get vo():PreviewVO
		{
			return this._vo;
		}
		
		override public function clone():Event
		{
			return new PreviewEvent(type, vo, bubbles, cancelable);
		}
	}
}
