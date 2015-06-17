package com.decalrus.model.vo
{

	[Bindable]
	[RemoteClass(alias="com.decalrus.model.vo.TemplateVO")]
	public class TemplateVO
	{
		public var id:int;
		public var name:String;
		public var modelId:int;
		public var artworkUrl:String;
		public var thumbnailUrl:String;
		public var previewUrl:String;
	}
}
