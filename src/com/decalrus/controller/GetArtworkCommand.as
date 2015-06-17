package com.decalrus.controller
{
	import com.decalrus.event.ObjectEvent;
	import com.decalrus.service.DecalrusService;
	
	import org.robotlegs.mvcs.Command;
	
	public class GetArtworkCommand extends Command
	{
		[Inject]
		public var service:DecalrusService;
		
		[Inject]
		public var event:ObjectEvent;
		
		override public function execute():void
		{
			trace('GetArtworkCommand::execute');
			var type:String = this.event.object as String;
			this.service.getArtwork(type);
		}
	}
}