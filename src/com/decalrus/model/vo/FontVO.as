package com.decalrus.model.vo
{
	[Bindable]
	public class FontVO
	{
		public var font:String;
		public var text:String;
		
		public function FontVO(font:String, text:String)
		{
			this.font = font;
			this.text = text;
		}
	}
}
