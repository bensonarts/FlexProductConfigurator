package com.decalrus.model.vo
{
	[Bindable]
	[RemoteClass(alias="com.decalrus.model.vo.ArtworkVO")]
	public class ArtworkVO
	{
		public var id:int;
		public var type:String;
		public var artworkUrl:String;
		public var thumbnailUrl:String;
	}
}