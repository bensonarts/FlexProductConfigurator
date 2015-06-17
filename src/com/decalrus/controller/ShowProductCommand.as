package com.decalrus.controller
{
	import com.decalrus.event.EventList;
	import com.decalrus.event.ModelEvent;
	import com.decalrus.model.DecalrusModel;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Command;
	
	public class ShowProductCommand extends Command
	{
		[Inject]
		public var event:ModelEvent;
		
		[Inject]
		public var model:DecalrusModel;
		
		override public function execute():void
		{
			trace('ShowProductCommand::execute');
			this.model.selectedModel = this.event.vo;
			this.dispatch(new Event(EventList.PRODUCT_SELECTED_READY));
		}
	}
}