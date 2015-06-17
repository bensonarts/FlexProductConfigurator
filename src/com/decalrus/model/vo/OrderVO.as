package com.decalrus.model.vo
{
	[Bindable]
	public class OrderVO
	{
		public var modelId:int;
		public var price:int;
		[ArrayElementType("com.decalrus.model.vo.PreviewVO")]
		public var previews:Array;
		public var customizedName:int = 0;
		public var customizedNameFont:String;
		public var customizedNameStr:String;
		public var finish:String;
	}
}
