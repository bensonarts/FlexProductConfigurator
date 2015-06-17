package com.decalrus.controller
{
	import com.decalrus.event.MakeEvent;
	import com.decalrus.service.DecalrusService;
	
	import org.robotlegs.mvcs.Command;
	
	public class GetProductsByMakeCommand extends Command
	{
		[Inject]
		public var service:DecalrusService;
		
		[Inject]
		public var event:MakeEvent;
		
		override public function execute():void
		{
			trace('GetProdutsByMakeCommand::execute');
			this.service.getProductsByMakeAndCategory(event.vo.id, event.catId);
		}
	}
}