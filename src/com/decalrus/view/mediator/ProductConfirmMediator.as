package com.decalrus.view.mediator
{
	import com.decalrus.event.EventList;
	import com.decalrus.model.DecalrusModel;
	import com.decalrus.view.component.ProductConfirmComponent;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ProductConfirmMediator extends Mediator
	{
		[Inject]
		public var view:ProductConfirmComponent;
		
		[Inject]
		public var model:DecalrusModel;
		
		override public function onRegister():void
		{
			trace('ProductConfirmMediator::onRegister');
			this.eventMap.mapListener(this.eventDispatcher, EventList.PRODUCT_SELECTED_READY, this.onProductSelectedReady);
			this.eventMap.mapListener(this.view, ProductConfirmComponent.CONFIRM, this.onProductConfirm);
			this.eventMap.mapListener(this.view, ProductConfirmComponent.CANCEL, this.onProductCancel);
			
			this.view.dataProvider = this.model.selectedModel;
		}
		
		protected function onProductSelectedReady(e:Event):void
		{
			trace('ProductConfirmMediator::onProductSelectedReady');
			this.view.dataProvider = this.model.selectedModel;
		}
		
		protected function onProductConfirm(e:Event):void
		{
			trace('ProductConfirmMediator::onProductConfirm');
			this.model.previewCollection = new ArrayCollection();
			this.dispatch(new Event(EventList.PRODUCT_CONFIRM));
		}
		
		protected function onProductCancel(e:Event):void
		{
			trace('ProductConfirmMediator::onProductCancel');
			this.dispatch(new Event(EventList.PRODUCT_CANCEL));
		}
	}
}