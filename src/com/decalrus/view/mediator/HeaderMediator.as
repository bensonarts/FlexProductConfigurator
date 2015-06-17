package com.decalrus.view.mediator
{
	import com.decalrus.event.CategoryEvent;
	import com.decalrus.event.CustomOrderEvent;
	import com.decalrus.event.EventList;
	import com.decalrus.event.MakeEvent;
	import com.decalrus.model.DecalrusModel;
	import com.decalrus.model.vo.CustomOrderSkinVO;
	import com.decalrus.model.vo.CustomOrderVO;
	import com.decalrus.model.vo.PreviewVO;
	import com.decalrus.view.HeaderView;
	import com.decalrus.view.component.helper.PopupPanel;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.graphics.codec.JPEGEncoder;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.utils.Base64Encoder;
	
	import org.robotlegs.mvcs.Mediator;

	public class HeaderMediator extends Mediator
	{
		[Inject]
		public var view:HeaderView;

		[Inject]
		public var model:DecalrusModel;

		private var _popupPanel:PopupPanel;

		public function HeaderMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			trace('HeaderMediator::onRegister');
			this.eventMap.mapListener(this.eventDispatcher, EventList.CATEGORY_DATA_READY, this.onCategoryDataReady);
			this.eventMap.mapListener(this.eventDispatcher, EventList.PRODUCT_SELECTED, this.onProductSelected);
			this.eventMap.mapListener(this.eventDispatcher, EventList.PRODUCT_CANCEL, this.onProductCancel);
			this.eventMap.mapListener(this.eventDispatcher, EventList.PRODUCT_CONFIRM, this.onProductConfirmed);
			this.eventMap.mapListener(this.eventDispatcher, EventList.ADD_CUSTOM_NAME, this.onAddCustomName);
			this.eventMap.mapListener(this.eventDispatcher, EventList.REMOVE_CUSTOM_NAME, this.onRemoveCustomName);
			this.eventMap.mapListener(this.eventDispatcher, EventList.PREVIEW_CHANGE, this.onPreviewChange);
			this.eventMap.mapListener(this.eventDispatcher, EventList.REMOVE_TEMPLATE_ART, this.onRemoveTemplateArt);
			this.eventMap.mapListener(this.eventDispatcher, EventList.ADD_TO_CART_SUCCESS, this.onAddToCartSuccess);
			this.eventMap.mapListener(this.eventDispatcher, EventList.ADD_TO_CART_FAILURE, this.onAddToCartFailure);
			this.eventMap.mapListener(this.view, HeaderView.CATEGORY_SELECT, this.onTypeSelect);
			this.eventMap.mapListener(this.view, HeaderView.MAKE_SELECT, this.onMakeSelect);
			this.eventMap.mapListener(this.view, HeaderView.BACK_TO_PRODUCTS, this.onBackToProductsSelect);
			this.eventMap.mapListener(this.view, HeaderView.UPLOAD_PHOTO, this.onUploadPhoto);
			this.eventMap.mapListener(this.view, HeaderView.SHOW_ARTWORK, this.onShowArtwork);
			this.eventMap.mapListener(this.view, HeaderView.SHOW_PREVIEW, this.onShowPreview);
			this.eventMap.mapListener(this.view, HeaderView.BACK_TO_MANIPULATOR, this.onBackToManipulator);
			this.eventMap.mapListener(this.view, HeaderView.SAVE, this.onSave);
			this.eventMap.mapListener(this.view, HeaderView.ADD_TO_CART, this.onAddToCart);

			this.view.previewCollection = this.model.previewCollection;
		}

		protected function onCategoryDataReady(e:Event):void
		{
			trace('HeaderMediator::onCategoryDataReady');
			this.view.categories = this.model.categories;
		}

		protected function onTypeSelect(e:CategoryEvent):void
		{
			trace('HeaderMediator::onTypeSelect');
			this.dispatch(new CategoryEvent(EventList.GET_PRODUCTS, e.vo));
			this.dispatch(new Event(EventList.CATEGORY_SELECTED));
		}

		protected function onMakeSelect(e:MakeEvent):void
		{
			trace('HeaderMediator::onMakeSelect');
			this.dispatch(new MakeEvent(EventList.GET_PRODUCTS_BY_MAKE, e.vo, e.catId));
			this.dispatch(new Event(EventList.CATEGORY_SELECTED));
		}

		protected function onProductSelected(e:Event):void
		{
			trace('HeaderMediator::onProductSelected');
			this.model.currentPrice = this.model.selectedModel.basePrice;
			this.view.currentPrice = this.model.currentPrice;
		}

		protected function onProductConfirmed(e:Event):void
		{
			trace('HeaderMediator::onProductConfirmed');
			this.view.previewCollection = this.model.previewCollection;
			this.view.currentState = HeaderView.STATE_MANIPULATOR;
			this.view.currentPrice = this.model.currentPrice;
		}

		protected function onAddCustomName(e:Event):void
		{
			trace('HeaderMediator::onAddCustomName');
			this.model.hasCustomName = true;
		}

		protected function onRemoveCustomName(e:Event):void
		{
			trace('HeaderMediator::onRemoveCustomName');
			this.model.hasCustomName = false;
		}

		protected function onPreviewChange(e:Event):void
		{
			trace('HeaderMediator::onPreviewChange');
			this.view.previewCollection = this.model.previewCollection;
			this._updateAdditionalPrice();
		}

		protected function onRemoveTemplateArt(e:Event):void
		{
			trace('HeaderMediator::onRemoveTemplateArt');
			this.view.previewCollection = this.model.previewCollection;
			this._updateAdditionalPrice();
		}

		protected function onAddToCartSuccess(e:Event):void
		{
			trace('HeaderMediator::onAddToCartSuccess');
			CursorManager.removeBusyCursor();
			if (this._popupPanel)
			{
				PopUpManager.removePopUp(this._popupPanel);
			}
		}

		protected function onAddToCartFailure(e:Event):void
		{
			trace('HeaderMediator::onAddToCartFailure');
			CursorManager.removeBusyCursor();
			if (this._popupPanel)
			{
				PopUpManager.removePopUp(this._popupPanel);
			}
			// TODO Handle failures
		}

		protected function onProductCancel(e:Event):void
		{
			trace('HeaderMediator::onProductCancel');
			this.view.currentState = HeaderView.STATE_CATEGORY_SELECTION;
		}

		protected function onBackToProductsSelect(e:Event):void
		{
			trace('HeaderMediator::onBackToProductsSelect');
			this.view.currentState = HeaderView.STATE_CATEGORY_SELECTION;
			// Remove product and empty cart.
			this.model.resetProduct();
			this.dispatch(new Event(EventList.SHOW_TYPES));
		}

		protected function onUploadPhoto(e:Event):void
		{
			trace('HeaderMediator::onUploadPhoto');
			this.dispatch(new Event(EventList.UPLOAD_PHOTO));
		}

		protected function onShowArtwork(e:Event):void
		{
			trace('HeaderMediator::onShowArtwork');
			this.dispatch(new Event(EventList.SHOW_ARTWORK));
		}

		protected function onShowPreview(e:Event):void
		{
			trace('HeaderMediator::onShowPreview');
			this.dispatch(new Event(EventList.SHOW_PREVIEW));
		}

		protected function onBackToManipulator(e:Event):void
		{
			trace('HeaderMediator::onBackToManipulator');
			this.dispatch(new Event(EventList.BACK_TO_CONFIGURATOR));
		}

		protected function onSave(e:Event):void
		{
			trace('HeaderMediator::onSave');
			this.dispatch(new Event(EventList.SAVE));
		}

		protected function onAddToCart(e:Event):void
		{
			trace('HeaderMediator::onAddToCart');

			var vo:CustomOrderVO = new CustomOrderVO();
			vo.modelId = this.model.selectedModel.id;
			vo.totalPrice = this.model.currentPrice;
			if (this.model.hasCustomName)
			{
				vo.customName = this.model.customName;
				vo.customNameFont = this.model.customNameFont;
				if (vo.customName == null || vo.customName == "")
				{
					Alert.show("Please enter your name below.");
					return;
				}
				if (vo.customNameFont == null || vo.customNameFont == "")
				{
					vo.customNameFont = "style1";
				}
			}
			vo.finish = this.model.selectedFinish;

			CursorManager.setBusyCursor();
			this._popupPanel = new PopupPanel();
			this._popupPanel.title = 'Adding to Cart';
			this._popupPanel.message = 'Saving your order information. Please allow this process to complete as it can take some time.';
			PopUpManager.addPopUp(this._popupPanel, FlexGlobals.topLevelApplication as Sprite, true);
			PopUpManager.centerPopUp(this._popupPanel);

			var jpgEncoder:JPEGEncoder = new JPEGEncoder();
			var base64Encoder:Base64Encoder = new Base64Encoder();
			var skins:Array = [];
			for each (var previewVO:PreviewVO in this.model.previewCollection)
			{
				var skinVO:CustomOrderSkinVO = new CustomOrderSkinVO();
				skinVO.templateId = previewVO.templateId;
				skinVO.hiResUrl = previewVO.artworkUrl;
				var byteArray:ByteArray = jpgEncoder.encode(previewVO.bitmapData);
				base64Encoder.encodeBytes(byteArray);
				skinVO.bitmapData = base64Encoder.flush();
				skins.push(skinVO);
				base64Encoder.reset();
			}
			vo.templates = skins;

			this.dispatch(new CustomOrderEvent(EventList.ADD_TO_CART, vo));
		}

		private function _updateAdditionalPrice():void
		{
			// Adjust current price by determining the number of previews
			if (this.model.selectedModel && this.model.previewCollection && this.model.previewCollection.length > 0)
			{
				var total:int = this.model.previewCollection.length - 1;
				var accumulatedTotal:Number = total * this.model.selectedModel.additionalPrice;
				this.model.currentPrice = this.model.selectedModel.basePrice + accumulatedTotal;
				this.view.currentPrice = this.model.currentPrice;
			}
		}
	}
}
