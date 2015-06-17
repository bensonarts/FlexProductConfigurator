package com.decalrus.model.vo
{
	[Bindable]
	[RemoteClass(alias="com.decalrus.model.vo.CustomOrderSkinVO")]
	public class CustomOrderSkinVO
	{
		public var id:int;
		public var templateId:int;
		public var customOrderId:int;
		public var artworkUrl:String;
		public var bitmapData:String;
		public var hiResUrl:String;
	}
}
