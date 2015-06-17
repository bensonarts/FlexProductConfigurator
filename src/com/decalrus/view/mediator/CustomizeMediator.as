package com.decalrus.view.mediator
{
	import com.decalrus.event.ArtworkEvent;
	import com.decalrus.event.EventList;
	import com.decalrus.event.ModelEvent;
	import com.decalrus.model.DecalrusModel;
	import com.decalrus.view.component.CustomizeComponent;

	import flash.events.Event;

	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;

	import org.robotlegs.mvcs.Mediator;

	public class CustomizeMediator extends Mediator
	{
		[Inject]
		public var view:CustomizeComponent;

		[Inject]
		public var model:DecalrusModel;

		override public function onRegister():void
		{
			trace('CustomizeMediator::onRegister');
			this.eventMap.mapListener(this.eventDispatcher, EventList.TEMPLATE_DATA_READY, this.onTemplateDataReady);
			this.eventMap.mapListener(this.eventDispatcher, EventList.UPLOAD_PHOTO, this.onUploadPhoto);
			this.eventMap.mapListener(this.eventDispatcher, EventList.ARTWORK_SELECTED, this.onArtworkSelected);
			this.eventMap.mapListener(this.eventDispatcher, EventList.SHOW_PREVIEW, this.onShowPreview);
			this.eventMap.mapListener(this.view, CustomizeComponent.PREVIEW_CHANGE, this.onPreviewChange);

			if (this.view.selectedModel.id != this.model.selectedModel.id)
			{
				this.dispatch(new ModelEvent(EventList.GET_TEMPLATES, this.model.selectedModel));
				this.model.previewCollection = new ArrayCollection();
				this.view.reset();
			}

			this.view.selectedModel = this.model.selectedModel;
			this.view.previewCollection = this.model.previewCollection;
            this.view.uuid = this.model.uuid;
			this.view.init();
		}

		override public function onRemove():void
		{
			trace('CustomizeMediator::onRemove');
			this.view.stop();
		}

		protected function onTemplateDataReady(e:Event):void
		{
			trace('CustomizeMediator::onTemplateDataReady');
			this.view.templates = this.model.templateCollection;
		}

		protected function onUploadPhoto(e:Event):void
		{
			trace('CustomizeMediator::onUploadPhoto');
			this.view.promptFileUpload();
		}

		protected function onArtworkSelected(e:ArtworkEvent):void
		{
			trace('CustomizeMediator::onArtworkSelected');
			this.view.loadArtwork(e.vo.artworkUrl);
		}

		protected function onShowPreview(e:Event):void
		{
			trace('CustomizeMediator::onShowPreview');
		}

		protected function onPreviewChange(e:Event):void
		{
			trace('CustomizeMediator::onPreviewChange');
			this.model.previewCollection = this.view.previewCollection;
			this.dispatch(new Event(EventList.PREVIEW_CHANGE));
		}
	}
}
