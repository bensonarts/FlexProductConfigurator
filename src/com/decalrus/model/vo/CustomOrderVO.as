package com.decalrus.model.vo
{
	[Bindable]
	[RemoteClass(alias="com.decalrus.model.vo.CustomOrderVO")]
	public class CustomOrderVO
	{
		public var id:int;
		public var uuid:String;
		public var totalPrice:Number;
		public var modelId:int;
		public var customName:String;
		public var customNameFont:String;
		public var finish:String;
		public var templates:Array;
		public var createdAt:String;
	}
}
