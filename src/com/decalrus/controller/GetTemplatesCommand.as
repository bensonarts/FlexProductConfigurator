package com.decalrus.controller
{
	import com.decalrus.event.ModelEvent;
	import com.decalrus.service.DecalrusService;
	
	import org.robotlegs.mvcs.Command;
	
	public class GetTemplatesCommand extends Command
	{
		[Inject]
		public var service:DecalrusService;
		
		[Inject]
		public var event:ModelEvent;
		
		override public function execute():void
		{
			this.service.getTemplates(this.event.vo.id);
		}
	}
}