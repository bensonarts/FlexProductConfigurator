package com.decalrus.view.mediator
{
	import com.decalrus.event.EventList;
	import com.decalrus.event.ModelEvent;
	import com.decalrus.model.DecalrusModel;
	import com.decalrus.view.component.ModelSelectComponent;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ModelSelectMediator extends Mediator
	{
		[Inject]
		public var view:ModelSelectComponent;
		
		[Inject]
		public var model:DecalrusModel;
		
		override public function onRegister():void
		{
			trace('ModelSelectMediator::onRegister');
			this.eventMap.mapListener(this.eventDispatcher, EventList.PRODUCTS_READY, this.onProductsReady);
			this.eventMap.mapListener(this.view, ModelSelectComponent.PRODUCT_SELECTED, this.onProductSelect);
		}
		
		protected function onProductsReady(e:Event):void
		{
			trace('ModelSelectMediator::onProductsReady');
			this.view.dataProvider = this.model.modelCollection;
		}
		
		protected function onProductSelect(e:ModelEvent):void
		{
			trace('ModelSelectMediator::onProductSelect');
			this.dispatch(new ModelEvent(EventList.PRODUCT_SELECTED, e.vo));
		}
	}
}