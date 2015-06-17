package com.decalrus.model.vo
{
	[Bindable]
	[RemoteClass(alias="com.decalrus.model.vo.ModelVO")]
	public class ModelVO
	{
		public var id:int;
		public var name:String;
		public var image:String;
		public var thumbnail:String;
		public var identifyImage:String;
		public var identifyThumbnail:String;
		public var identifyInstructions:String;
		public var makeId:int;
		public var categoryId:int;
		public var basePrice:Number;
		public var additionalPrice:Number;
		public var lbs:Number;
	}
}
