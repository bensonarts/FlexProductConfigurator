package com.decalrus
{
	import com.decalrus.controller.AddToCartCommand;
	import com.decalrus.controller.GetArtworkCommand;
	import com.decalrus.controller.GetCategoriesCommand;
	import com.decalrus.controller.GetManufacturersCommand;
	import com.decalrus.controller.GetProductsByMakeCommand;
	import com.decalrus.controller.GetProductsCommand;
	import com.decalrus.controller.GetTemplatesCommand;
	import com.decalrus.controller.ShowProductCommand;
	import com.decalrus.event.EventList;
	import com.decalrus.event.ObjectEvent;
	import com.decalrus.model.DecalrusModel;
	import com.decalrus.service.DecalrusService;
	import com.decalrus.view.BodyView;
	import com.decalrus.view.HeaderView;
	import com.decalrus.view.component.ArtworkComponent;
	import com.decalrus.view.component.CustomizeComponent;
	import com.decalrus.view.component.IntroComponent;
	import com.decalrus.view.component.ModelSelectComponent;
	import com.decalrus.view.component.PreviewComponent;
	import com.decalrus.view.component.ProductConfirmComponent;
	import com.decalrus.view.mediator.ArtworkMediator;
	import com.decalrus.view.mediator.BodyMediator;
	import com.decalrus.view.mediator.CustomizeMediator;
	import com.decalrus.view.mediator.HeaderMediator;
	import com.decalrus.view.mediator.IntroMediator;
	import com.decalrus.view.mediator.ModelSelectMediator;
	import com.decalrus.view.mediator.PreviewMediator;
	import com.decalrus.view.mediator.ProductConfirmMediator;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Context;

	public class ApplicationContext extends Context
	{
		public function ApplicationContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void
		{
			// Models
			this.injector.mapSingleton(DecalrusModel);
			
			// Services
			this.injector.mapSingleton(DecalrusService);
			
			// Events
			this.injector.mapSingleton(ObjectEvent);
			
			// Mediator/View Mappings
			this.mediatorMap.mapView(HeaderView, HeaderMediator);
			this.mediatorMap.mapView(BodyView, BodyMediator);
			this.mediatorMap.mapView(IntroComponent, IntroMediator);
			this.mediatorMap.mapView(ModelSelectComponent, ModelSelectMediator);
			this.mediatorMap.mapView(CustomizeComponent, CustomizeMediator);
			this.mediatorMap.mapView(PreviewComponent, PreviewMediator);
			this.mediatorMap.mapView(ProductConfirmComponent, ProductConfirmMediator);
			this.mediatorMap.mapView(ArtworkComponent, ArtworkMediator);
			
			// Controllers
			this.commandMap.mapEvent(EventList.GET_CATEGORY_DATA, GetCategoriesCommand);
			this.commandMap.mapEvent(EventList.GET_MANUFACTURERS, GetManufacturersCommand);
			this.commandMap.mapEvent(EventList.GET_PRODUCTS, GetProductsCommand);
			this.commandMap.mapEvent(EventList.GET_PRODUCTS_BY_MAKE, GetProductsByMakeCommand);
			this.commandMap.mapEvent(EventList.PRODUCT_SELECTED, ShowProductCommand);
			this.commandMap.mapEvent(EventList.GET_TEMPLATES, GetTemplatesCommand);
			this.commandMap.mapEvent(EventList.GET_ARTWORK, GetArtworkCommand);
			this.commandMap.mapEvent(EventList.ADD_TO_CART, AddToCartCommand);
			 
			// Get navigation data
			this.dispatchEvent(new Event(EventList.GET_CATEGORY_DATA));
		}
	}
}
