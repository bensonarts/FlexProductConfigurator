package com.decalrus.controller
{
	import com.decalrus.event.CustomOrderEvent;
	import com.decalrus.service.DecalrusService;
	
	import org.robotlegs.mvcs.Command;
	
	public class AddToCartCommand extends Command
	{
		[Inject]
		public var service:DecalrusService;
		
		[Inject]
		public var event:CustomOrderEvent;
		
		override public function execute():void
		{
			trace('AddToCartCommand::execute');
			this.service.addToCart(this.event.vo);
		}
	}
}
