package com.decalrus.service
{
	import com.decalrus.event.EventList;
	import com.decalrus.model.DecalrusModel;
	import com.decalrus.model.vo.ArtworkVO;
	import com.decalrus.model.vo.CategoryVO;
	import com.decalrus.model.vo.CustomOrderSkinVO;
	import com.decalrus.model.vo.CustomOrderVO;
	import com.decalrus.model.vo.MakeVO;
	import com.decalrus.model.vo.ModelVO;
	import com.decalrus.model.vo.PreviewVO;
	import com.decalrus.model.vo.TemplateVO;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class DecalrusService extends AbstractRemoteService
	{
		[Inject]
		public var model:DecalrusModel;

		private var vo1:CategoryVO;
		private var vo2:ModelVO;
		private var vo3:TemplateVO;
		private var vo4:MakeVO;
		private var vo5:ArtworkVO;
		private var vo6:CustomOrderVO;
		private var vo7:CustomOrderSkinVO;
		private var vo8:PreviewVO;

		public function DecalrusService()
		{
			super('Decalrus_Service');
		}

		public function getCategories():void
		{
			trace('DecalrusService::getCategories');
			var token:AsyncToken = this.remoteObject.getCategories();
			token.addResponder(new Responder(this.onCategoriesSuccess, this.onCategoriesFault));
		}

		protected function onCategoriesSuccess(e:ResultEvent):void
		{
			trace('DecalrusService::onCategoriesSuccess');
            var result:Array = e.result as Array;
			this.model.categories = new ArrayCollection(result['categories'] as Array);
            this.model.uuid = result['uuid'];
			this.dispatch(new Event(EventList.CATEGORY_DATA_READY));
		}

		protected function onCategoriesFault(e:FaultEvent):void
		{
			trace('DecalrusService::onCategoriesFault');
			trace(e.fault.getStackTrace());
			Alert.show(e.fault.faultDetail);
		}

		public function getManufacturers(categoryId:int):void
		{
			trace('DecalrusService::getManufacturers');
			var token:AsyncToken = this.remoteObject.getManufacturers(categoryId);
			token.addResponder(new Responder(this.onGetManufacturersSuccess, this.onGetManufacturersFault));
		}

		protected function onGetManufacturersSuccess(e:ResultEvent):void
		{
			trace('DecalrusService::onGetManufacturersSuccess');
			this.model.makeCollection = new ArrayCollection(e.result as Array);
			this.dispatch(new Event(EventList.MANUFACTURER_DATA_READY));
		}

		protected function onGetManufacturersFault(e:FaultEvent):void
		{
			trace('DecalrusService::onGetManufacturersFault');
			trace(e.fault.getStackTrace());
			Alert.show(e.fault.faultDetail);
		}

		public function getProducts(categoryId:int):void
		{
			trace('DecalrusService::onGetProducts');
			var token:AsyncToken = this.remoteObject.getProducts(categoryId);
			token.addResponder(new Responder(this.onGetProductsSuccess, this.onGetProductsFault));
		}

		protected function onGetProductsSuccess(e:ResultEvent):void
		{
			trace('DecalrusService::onGetProductsSuccess');
			this.model.modelCollection = new ArrayCollection(e.result as Array);
			this.dispatch(new Event(EventList.PRODUCTS_READY));
		}

		protected function onGetProductsFault(e:FaultEvent):void
		{
			trace('DecalrusService::onGetProductsFault');
			trace(e.fault.getStackTrace());
			Alert.show(e.fault.faultDetail);
		}

		public function getProductsByMakeAndCategory(makeId:int, categoryId:int):void
		{
			trace('DecalrusService::onGetProductsByMakeAndCategory');
			var token:AsyncToken = this.remoteObject.getProductsByMakeAndCategory(makeId, categoryId);
			token.addResponder(new Responder(this.onGetProductsByMakeAndCategorySuccess, this.onGetProductsByMakeAndCategoryFault));
		}

		protected function onGetProductsByMakeAndCategorySuccess(e:ResultEvent):void
		{
			trace('DecalrusService::onGetProductsByMakeAndCategorySuccess');
			this.model.modelCollection = new ArrayCollection(e.result as Array);
			this.dispatch(new Event(EventList.PRODUCTS_READY));
		}

		protected function onGetProductsByMakeAndCategoryFault(e:FaultEvent):void
		{
			trace('DecalrusService::onGetProductsByMakeAndCategoryFault');
			trace(e.fault.getStackTrace());
			Alert.show(e.fault.faultDetail);
		}

		public function getTemplates(modelId:int):void
		{
			trace('DecalrusService::getTemplates');
			var token:AsyncToken = this.remoteObject.getTemplates(modelId);
			token.addResponder(new Responder(this.onGetTemplatesSuccess, this.onGetTemplatesFault));
		}

		protected function onGetTemplatesSuccess(e:ResultEvent):void
		{
			trace('DecalrusService::onGetTempaltesSuccess');
			this.model.templateCollection = new ArrayCollection(e.result as Array);
			this.dispatch(new Event(EventList.TEMPLATE_DATA_READY));
		}

		protected function onGetTemplatesFault(e:FaultEvent):void
		{
			trace('DecalrusService::onGetTemplatesFault');
			trace(e.fault.getStackTrace());
			Alert.show(e.fault.faultDetail);
		}

		public function getArtwork(type:String):void
		{
			trace('DecalrusService::getArtwork');
			var token:AsyncToken = this.remoteObject.getArtwork(type);
			token.addResponder(new Responder(this.onGetArtworkSuccess, this.onGetArtworkFault));
		}

		protected function onGetArtworkSuccess(e:ResultEvent):void
		{
			trace('DecalrusService::onGetArtworkSuccess');
			this.model.artworkCollection = new ArrayCollection(e.result as Array);
			this.dispatch(new Event(EventList.ARTWORK_DATA_READY));
		}

		protected function onGetArtworkFault(e:FaultEvent):void
		{
			trace('DecalrusService::onGetArtworkFault');
			trace(e.fault.getStackTrace());
			Alert.show(e.fault.faultDetail);
		}

		public function addToCart(vo:CustomOrderVO):void
		{
			trace('DecalrusService::addToCart');
			var token:AsyncToken = this.remoteObject.saveOrder(vo, this.model.uuid);
			token.addResponder(new Responder(this.onAddToCartSuccess, this.onAddToCartFault));
		}

		protected function onAddToCartSuccess(e:ResultEvent):void
		{
			trace('DecalrusService::onAddToCartSuccess');
			this.dispatch(new Event(EventList.ADD_TO_CART_SUCCESS));
			navigateToURL(new URLRequest(e.result as String), '_top');
		}

		protected function onAddToCartFault(e:FaultEvent):void
		{
			trace('DecalrusService::onAddToCartFault');
			trace(e.fault.getStackTrace());
			this.dispatch(new Event(EventList.ADD_TO_CART_FAILURE));
			Alert.show('An error occurred adding your order to the shopping cart.', 'Error Occurred');
		}
	}
}
