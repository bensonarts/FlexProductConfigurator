package com.decalrus.event
{
	import com.decalrus.model.vo.ArtworkVO;
	
	import flash.events.Event;
	
	public class ArtworkEvent extends Event
	{
		private var _vo:ArtworkVO;
		
		public function ArtworkEvent(type:String, vo:ArtworkVO, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._vo = vo;
		}
		
		public function get vo():ArtworkVO
		{
			return this._vo;
		}
		
		override public function clone():Event
		{
			return new ArtworkEvent(type, vo, bubbles, cancelable);
		}
	}
}