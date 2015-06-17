package com.decalrus.controller
{
	import com.decalrus.service.DecalrusService;
	
	import org.robotlegs.mvcs.Command;
	
	public class GetCategoriesCommand extends Command
	{
		[Inject]
		public var service:DecalrusService;
		
		override public function execute():void
		{
			trace('GetCategoriesCommand::execute');
			this.service.getCategories();
		}
	}
}