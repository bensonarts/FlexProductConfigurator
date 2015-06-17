package com.decalrus.event
{
	import com.decalrus.model.vo.TemplateVO;
	
	import flash.events.Event;
	
	public class TemplateEvent extends Event
	{
		private var _vo:TemplateVO;
		
		public function TemplateEvent(type:String, vo:TemplateVO, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._vo = vo;
		}
		
		public function get vo():TemplateVO
		{
			return this._vo;
		}
		
		override public function clone():Event
		{
			return new TemplateEvent(type, vo, bubbles, cancelable);
		}
	}
}
