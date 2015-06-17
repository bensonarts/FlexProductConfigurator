package com.decalrus.view.component.custom
{
	import com.decalrus.config.DecalrusConfig;
	import com.decalrus.model.vo.SkinVO;
	import com.decalrus.model.vo.TemplateVO;
	import com.decalrus.util.SpriteUtil;
	import com.ryan.geom.FreeTransformManager;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;

	public class ProductConfigurator extends Sprite
	{
		public static const IMAGE_READY:String = "imageReady";
		public static const IMAGE_TOO_SMALL:String = "imageTooSmall";

		[ArrayElementType("com.decalrus.model.vo.TemplateVO")]
		public var templates:ArrayCollection;

		[ArrayElementType("com.decalrus.model.vo.SkinVO")]
		public var artworkCollection:ArrayCollection = new ArrayCollection();

		public var hasImage:Boolean = false;

		protected var transformManager:FreeTransformManager;
		protected var currentSprite:Sprite;

		private var _currentTemplate:TemplateVO;
		private var _currentArtworkUrl:String;
		private var _isUserUpload:Boolean = false;

		public function ProductConfigurator()
		{
			this.transformManager = new FreeTransformManager(false);
			this.transformManager.addEventListener(FreeTransformManager.STAGE_MOUSE_UP, this.onStageMouseUp);
		}

		public function get currentTemplate():TemplateVO
		{
			return this._currentTemplate;
		}

		public function set currentTemplate(value:TemplateVO):void
		{
			this.hasImage = false;
			this._currentTemplate = value;
			this.transformManager.stop();
			// Check to see if artwork exists
			try
			{
				this.transformManager.hideHandlers();
				for (var k:int = 0; k < this.artworkCollection.length; k++)
				{
					var skinVO:SkinVO = this.artworkCollection.getItemAt(k) as SkinVO;
					skinVO.sprite.visible = false;
				}

				for (var i:int = this.artworkCollection.length - 1; i > -1; i--)
				{
					var vo:SkinVO = this.artworkCollection.getItemAt(i) as SkinVO;
					if (value.id == vo.template.id && value.modelId == vo.template.modelId)
					{
						// Show image
						if (vo.sprite)
						{
							vo.sprite.visible = true;
							vo.sprite.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
							vo.sprite.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
							this.hasImage = true;
							this.currentSprite = vo.sprite;
							this.dispatchEvent(new Event(ProductConfigurator.IMAGE_READY));
							this.transformManager.start();
							break;
						}
						break;
					}
				}
			}
			catch (e:Error)
			{
				trace(e.message);
			}
		}

		public function get currentArtworkUrl():String
		{
			return this._currentArtworkUrl;
		}

		public function hideHandlers():void
		{
			this.transformManager.hideHandlers();
		}

		public function showHandlers():void
		{
			this.transformManager.showHandlers();
		}

		public function reset():void
		{
			trace('ProductConfigurator::reset');
			try
			{
				SpriteUtil.removeChildren(this);
				this.artworkCollection = new ArrayCollection();
				this.transformManager.hideHandlers();
				this.transformManager.stop();
			}
			catch (e:Error)
			{
				trace(e.message);
			}
		}

		public function loadArtwork(url:String, userUpload:Boolean = false):void
		{
			trace('ProductConfigurator::loadArtwork');
			CursorManager.setBusyCursor();
			this._isUserUpload = userUpload;
			// Remove existing artwork if the selected template is the same
			for (var i:int = 0; i < this.templates.length; i++)
			{
				var template:TemplateVO = this.templates.getItemAt(i) as TemplateVO;
				if (template.id == this.currentTemplate.id)
				{
					this.removeArtwork(template.id);
				}
			}

			this._currentArtworkUrl = url;
            trace('loaded artwork: ' + url);

			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this._onImageLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this._onImageIoError);
			loader.load(new URLRequest(url));
		}

		public function setToOriginal():void
		{
			// TODO FIXME
			var stage:Stage = FlexGlobals.topLevelApplication.stage;

			this.transformManager.setRotateDeg(0);
			this.transformManager.setScale(1);

			this.currentSprite.x = (stage.stageWidth / 2) - (this.currentSprite.width / 2);
			this.currentSprite.y = (stage.stageHeight / 2) - (this.currentSprite.height / 2) - 50;

			this.transformManager.center();
		}

		public function removeArtwork(templateId:int):void
		{
			for (var i:int = 0; i < this.artworkCollection.length; i++)
			{
				var skinVO:SkinVO = this.artworkCollection.getItemAt(i) as SkinVO;
				if (templateId == skinVO.template.id)
				{
					this.artworkCollection.removeItemAt(i);
					this.removeChild(skinVO.sprite);
					break;
				}
			}
			this.hideHandlers();
			this.hasImage = false;
			this.transformManager.stop();
		}

		public function rotate(orientation:String):void
		{
			var deg:Number = this.transformManager.displayObjRotation;
			var remainder:Number = 0;

			switch (orientation)
			{
				case 'cw':
					deg += 90;
					remainder = deg % 90;
					deg -= remainder;
					this.transformManager.setRotateDeg(deg);
					break;
				case 'ccw':
					if (deg > 90 && deg <= 180)
					{
						deg = 90;
						this.transformManager.setRotateDeg(deg);
						return;
					}
					deg -= 90;
					remainder = deg % 90;
					deg -= remainder;
					this.transformManager.setRotateDeg(deg);
					break;
				default:
					break;
			}
		}

		protected function onStageMouseUp(e:Event):void
		{
			this.dispatchEvent(e);
		}

		private function _onImageLoaded(e:Event):void
		{
			trace('ProductConfigurator::_onImageLoaded');

			var loader:LoaderInfo = e.currentTarget as LoaderInfo;
			loader.removeEventListener(Event.COMPLETE, this._onImageLoaded);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, this._onImageIoError);
			var bitmap:Bitmap = loader.content as Bitmap;

			if (this._isUserUpload)
			{
				if (bitmap.width < DecalrusConfig.MIN_UPLOAD_WIDTH || bitmap.height < DecalrusConfig.MIN_UPLOAD_HEIGHT)
				{
					Alert.show
						("Uploaded image is too small. Please upload a file at least " +
							DecalrusConfig.MIN_UPLOAD_WIDTH + "x" +
							DecalrusConfig.MIN_UPLOAD_HEIGHT + ".",
							"Error");
					this.dispatchEvent(new Event(ProductConfigurator.IMAGE_TOO_SMALL));
					CursorManager.removeBusyCursor();
					return;
				}
			}

			this.hasImage = true;
			var sprite:Sprite = new Sprite();
			sprite.name = this._currentArtworkUrl;

			bitmap.smoothing = true;
			sprite.addChild(bitmap);
			this.addChild(sprite);

			var skinVO:SkinVO = new SkinVO();
			skinVO.template = this.currentTemplate;
			skinVO.artworkUrl = this._currentArtworkUrl;
			skinVO.sprite = sprite;
			this.artworkCollection.addItem(skinVO);

			var stage:Stage = FlexGlobals.topLevelApplication.stage;
			sprite.x = (stage.stageWidth / 2) - (bitmap.width / 2);
			sprite.y = (stage.stageHeight / 2) - (bitmap.height / 2) - 60;
			this.transformManager.registerSprite(sprite, { minScale:0.1, maxScale:1 }, true);

			if (bitmap.width > stage.stageWidth - 80)
			{
				this.transformManager.setSize(stage.stageWidth - 80);
			}

			this.dispatchEvent(new Event(ProductConfigurator.IMAGE_READY));

			this.currentSprite = sprite;
			this.transformManager.start();
			this._isUserUpload = false;
			CursorManager.removeBusyCursor();
		}

		private function _onImageIoError(e:IOErrorEvent):void
		{
			trace('ProductConfigurator::_onImageIoError');
			var loader:LoaderInfo = e.currentTarget as LoaderInfo;
			loader.removeEventListener(IOErrorEvent.IO_ERROR, this._onImageIoError);
			Alert.show("Unable to load artwork.");
			CursorManager.removeBusyCursor();
		}
	}
}
