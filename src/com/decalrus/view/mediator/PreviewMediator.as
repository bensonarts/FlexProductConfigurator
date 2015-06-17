package com.decalrus.view.mediator
{
	import com.decalrus.event.EventList;
	import com.decalrus.event.PreviewEvent;
	import com.decalrus.model.DecalrusModel;
	import com.decalrus.model.vo.FontVO;
	import com.decalrus.view.component.PreviewComponent;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class PreviewMediator extends Mediator
	{
		[Inject]
		public var view:PreviewComponent;
		
		[Inject]
		public var model:DecalrusModel;
		
		override public function onRegister():void
		{
			trace('PreviewMediator::onRegister');
			this.eventMap.mapListener(this.eventDispatcher, EventList.SHOW_PREVIEW, this.onShowPreview);
			this.eventMap.mapListener(this.view, PreviewComponent.ADD_CUSTOM_NAME, this.onAddCustomName);
			this.eventMap.mapListener(this.view, PreviewComponent.REMOVE_CUSTOM_NAME, this.onRemoveCustomName);
			this.eventMap.mapListener(this.view, PreviewComponent.FINISH_SELECTED, this.onFinishSelected);
			this.eventMap.mapListener(this.view, PreviewComponent.FONT_SELECTED, this.onFontSelected);
			this.eventMap.mapListener(this.view, PreviewComponent.REMOVE_TEMPLATE, this.onRemoveTemplate);
			this.eventMap.mapListener(this.view, PreviewComponent.UPDATE_CUSTOM_NAME, this.onUpdateCustomName);
			
			this.view.templates = this.model.templateCollection;
			this.view.previewCollection = this.model.previewCollection;
		}
		
		protected function onShowPreview(e:Event):void
		{
			trace('PreviewMediator::onShowPreview');
			this.view.previewCollection = this.model.previewCollection;
		}
		
		protected function onAddCustomName(e:Event):void
		{
			trace('PreviewMediator::onAddCustomName');
			this.model.hasCustomName = true;
			this.dispatch(new Event(EventList.ADD_CUSTOM_NAME));
		}
		
		protected function onRemoveCustomName(e:Event):void
		{
			trace('PreviewMediator::onRemoveCustomName');
			this.model.hasCustomName = false;
			this.dispatch(new Event(EventList.REMOVE_CUSTOM_NAME));
		}
		
		protected function onFinishSelected(e:Event):void
		{
			trace('PreviewMediator::onFinishSelected');
			this.model.selectedFinish = this.view.finishRbg.selectedValue as String;
		}
		
		protected function onFontSelected(e:Event):void
		{
			trace('PreviewMediator::onFontSelected');
			var fontVO:FontVO = this.view.customFontList.selectedItem as FontVO;
			this.model.customNameFont = fontVO.font;
		}
		
		protected function onRemoveTemplate(e:PreviewEvent):void
		{
			trace('PreviewMediator::onRemoveTemplate');
			this.model.previewCollection = this.view.previewCollection;
			this.dispatch(new Event(EventList.REMOVE_TEMPLATE_ART));
		}
		
		protected function onUpdateCustomName(e:Event):void
		{
			trace('PreviewMediator::onUpdateCustomName');
			this.model.customName = this.view.customNameInput.text;
		}
	}
}
