package com.decalrus.util
{
	import flash.display.DisplayObjectContainer;

	public class SpriteUtil
	{
		/**
		 * Deletes all children of a sprite.
		 * 
		 * @param sprite
		 * 
		 */		
		public static function removeChildren(obj:DisplayObjectContainer):void
		{
			if (obj != null)
			{
				while (obj.numChildren > 0)
				{
					obj.removeChildAt(0);
				}
			}
		}
		
		/**
		 * Hides all children of a sprite.
		 * 
		 * @param sprite
		 * 
		 */	
		public static function hideChildren(obj:DisplayObjectContainer):void
		{
			if (obj != null)
			{
				while (obj.numChildren > 0)
				{
					obj.visible = false;
				}
			}
		}
	}
}
