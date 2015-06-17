package com.decalrus.view.mediator
{
	import com.decalrus.event.ArtworkEvent;
	import com.decalrus.model.DecalrusModel;
	import com.decalrus.view.component.ArtworkComponent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ArtworkMediator extends Mediator
	{
		[Inject]
		public var view:ArtworkComponent;
		
		[Inject]
		public var model:DecalrusModel;
		
		override public function onRegister():void
		{
			trace('ArtworkMediator::onRegister');
			this.eventMap.mapListener(this.view, ArtworkComponent.ARTWORK_SELECTED, this.onArtworkSelected);
		}
		
		protected function onArtworkSelected(e:ArtworkEvent):void
		{
			// TODO 
		}
	}
}