package com.decalrus.view.mediator
{
	import com.decalrus.event.ArtworkEvent;
	import com.decalrus.event.EventList;
	import com.decalrus.event.ObjectEvent;
	import com.decalrus.model.DecalrusModel;
	import com.decalrus.view.BodyView;
	import com.decalrus.view.component.ArtworkComponent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class BodyMediator extends Mediator
	{
		[Inject]
		public var view:BodyView;
		
		[Inject]
		public var model:DecalrusModel;
		
		override public function onRegister():void
		{
			trace('BodyMediator::onRegister');
			this.eventMap.mapListener(this.eventDispatcher, EventList.CATEGORY_SELECTED, this.onTypeSelected);
			this.eventMap.mapListener(this.eventDispatcher, EventList.PRODUCT_SELECTED, this.onProductSelected);
			this.eventMap.mapListener(this.eventDispatcher, EventList.PRODUCT_CONFIRM, this.onProductConfirmed);
			this.eventMap.mapListener(this.eventDispatcher, EventList.PRODUCT_CANCEL, this.onProductCancel);
			this.eventMap.mapListener(this.eventDispatcher, EventList.SHOW_TYPES, this.onShowTypes);
			this.eventMap.mapListener(this.eventDispatcher, EventList.SHOW_ARTWORK, this.onShowArtwork);
			this.eventMap.mapListener(this.eventDispatcher, EventList.ARTWORK_DATA_READY, this.onArtworkDataReady);
			this.eventMap.mapListener(this.eventDispatcher, EventList.SHOW_PREVIEW, this.onShowPreview);
			this.eventMap.mapListener(this.eventDispatcher, EventList.BACK_TO_CONFIGURATOR, this.onGoBackToConfigurator);
			this.eventMap.mapListener(this.view, ArtworkComponent.TYPE_SELECTED, this.onArtworkTypeSelected);
			this.eventMap.mapListener(this.view, ArtworkComponent.ARTWORK_SELECTED, this.onArtworkSelected);
		}
		
		protected function onTypeSelected(e:Event):void
		{
			trace('BodyMediator::onTypeSelected');
			this.view.currentState = BodyView.STATE_PRODUCT_SELECT;
		}
		
		protected function onProductSelected(e:Event):void
		{
			trace('BodyMediator::onProductSelected');
			this.view.currentState = BodyView.STATE_PRODUCT_CONFIRM;
		}
		
		protected function onProductConfirmed(e:Event):void
		{
			trace('BodyMediator::onProductConfirmed');
			this.view.currentState = BodyView.STATE_CUSTOMIZE;
		}
		
		protected function onProductCancel(e:Event):void
		{
			trace('BodyMediator::onProductCancel');
			this.view.currentState = BodyView.STATE_PRODUCT_SELECT;
		}
		
		protected function onShowTypes(e:Event):void
		{
			trace('BodyMediator::onShowTypes');
			this.view.currentState = BodyView.STATE_TYPE_SELECT;
		}
		
		protected function onShowArtwork(e:Event):void
		{
			trace('BodyMediator::onShowArtwork');
			PopUpManager.addPopUp(this.view.artworkComponent, FlexGlobals.topLevelApplication as Sprite, true);
			PopUpManager.centerPopUp(this.view.artworkComponent);
		}
		
		protected function onArtworkTypeSelected(e:ObjectEvent):void
		{
			trace('BodyMediator::onTypeSelected');
			this.dispatch(new ObjectEvent(EventList.GET_ARTWORK, e.object));
		}
		
		protected function onArtworkDataReady(e:Event):void
		{
			trace('BodyMediator::onArtworkDataReady');
			this.view.artworkCollection = this.model.artworkCollection;
		}
		
		protected function onArtworkSelected(e:ArtworkEvent):void
		{
			trace('BodyMediator::onArtworkSelected');
			PopUpManager.removePopUp(this.view.artworkComponent);
			this.dispatch(new ArtworkEvent(EventList.ARTWORK_SELECTED, e.vo));
		}
		
		protected function onShowPreview(e:Event):void
		{
			trace('BodyMediator::onShowPreview');
			this.view.currentState = BodyView.STATE_PREVIEW;
		}
		
		protected function onGoBackToConfigurator(e:Event):void
		{
			trace('BodyMediator::onGoBackToConfigurator');
			this.view.currentState = BodyView.STATE_CUSTOMIZE;
		}
	}
}
