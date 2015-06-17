package com.decalrus.model.vo
{
	[Bindable]
	[RemoteClass(alias="com.decalrus.model.vo.CategoryVO")]
	public class CategoryVO
	{
		public var id:int;
		public var name:String;
		public var image:String;
		
		[ArrayElementType("com.decalrus.model.vo.MakeVO")]
		public var makes:Array;
	}
}