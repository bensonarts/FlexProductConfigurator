package com.decalrus.view.mediator
{
	import com.decalrus.event.CategoryEvent;
	import com.decalrus.event.EventList;
	import com.decalrus.model.DecalrusModel;
	import com.decalrus.view.component.IntroComponent;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class IntroMediator extends Mediator
	{
		[Inject]
		public var view:IntroComponent;
		
		[Inject]
		public var model:DecalrusModel;
		
		override public function onRegister():void
		{
			trace('IntroMediator::onRegister');
			this.eventMap.mapListener(this.eventDispatcher, EventList.CATEGORY_DATA_READY, this.onCategoryDataReady);
			this.eventMap.mapListener(this.view, IntroComponent.TYPE_SELECT, this.onTypeSelect);
		}
		
		protected function onCategoryDataReady(e:Event):void
		{
			trace('IntroMediator::onCategoryDataReady');
			this.view.dataProvider = this.model.categories;
		}
		
		protected function onTypeSelect(e:CategoryEvent):void
		{
			trace('IntroMediator::onTypeSelect');
			this.eventDispatcher.dispatchEvent(new CategoryEvent(EventList.GET_PRODUCTS, e.vo));
			this.dispatch(new Event(EventList.CATEGORY_SELECTED));
		}
	}
}