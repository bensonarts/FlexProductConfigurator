package com.decalrus.controller
{
	import com.decalrus.event.CategoryEvent;
	import com.decalrus.service.DecalrusService;
	
	import org.robotlegs.mvcs.Command;
	
	public class GetManufacturersCommand extends Command
	{
		[Inject]
		public var service:DecalrusService;
		
		[Inject]
		public var event:CategoryEvent;
		
		override public function execute():void
		{
			trace('GetManufacturersCommand::execute');
			this.service.getManufacturers(this.event.vo.id);
		}
	}
}