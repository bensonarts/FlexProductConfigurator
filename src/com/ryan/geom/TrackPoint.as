package com.ryan.geom
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class TrackPoint extends MovieClip
	{
		public var _label:TextField;
		
		public function TrackPoint(label:String = '', p:Point = null):void
		{
			graphics.beginFill(0x000000, 1);
			graphics.drawCircle(0, 0, 3);
			
			this._label = new TextField();
			this._label.textColor = 0x000000;
			this._label.autoSize = TextFieldAutoSize.LEFT;
			this._label.x = 8;
			this._label.y = 11;
			addChild(this._label);
			
			update(label, p);
		}
		
		public function set label(s:String):void
		{
			this._label.text = s;
			this._label.mouseEnabled = false;
		}
		
		public function set pos(point:Point):void
		{
			x = point.x;
			y = point.y;
		}
		
		public function update(label:String = '', p:Point = null):void
		{
			if (label != '') this.label = label;
			if (p != null) this.pos = p;
		}
	}
}
