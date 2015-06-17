package com.decalrus.model
{
	import com.decalrus.model.vo.ModelVO;

	import mx.collections.ArrayCollection;

	import org.robotlegs.mvcs.Actor;

	public class DecalrusModel extends Actor
	{
        private var _uuid:String;
		private var _categories:ArrayCollection;
		private var _makeCollection:ArrayCollection;
		private var _modelCollection:ArrayCollection;
		private var _selectedModel:ModelVO;
		private var _templateCollection:ArrayCollection;
		private var _artworkCollection:ArrayCollection;
		private var _previewCollection:ArrayCollection;
		private var _currentPrice:Number;
		private var _hasCustomName:Boolean = false;
		private var _selectedFinish:String = 'matte';
		private var _customName:String;
		private var _customNameFont:String;

		public function DecalrusModel()
		{
		}

        public function get uuid():String
        {
            return this._uuid;
        }

        public function set uuid(value:String):void
        {
            this._uuid = value;
        }

		public function get categories():ArrayCollection
		{
			return this._categories;
		}

		public function set categories(value:ArrayCollection):void
		{
			this._categories = value;
		}

		public function get makeCollection():ArrayCollection
		{
			return this._makeCollection;
		}

		public function set makeCollection(value:ArrayCollection):void
		{
			this._makeCollection = value;
		}

		public function get modelCollection():ArrayCollection
		{
			return this._modelCollection;
		}

		public function set modelCollection(value:ArrayCollection):void
		{
			this._modelCollection = value;
		}

		public function get selectedModel():ModelVO
		{
			return this._selectedModel;
		}

		public function set selectedModel(value:ModelVO):void
		{
			this._selectedModel = value;
		}

		public function get templateCollection():ArrayCollection
		{
			return this._templateCollection;
		}

		public function set templateCollection(value:ArrayCollection):void
		{
			this._templateCollection = value;
		}

		public function get artworkCollection():ArrayCollection
		{
			return this._artworkCollection;
		}

		public function set artworkCollection(value:ArrayCollection):void
		{
			this._artworkCollection = value;
		}

		public function get currentPrice():Number
		{
			return this._currentPrice;
		}

		public function set currentPrice(value:Number):void
		{
			this._currentPrice = value;
		}

		public function get previewCollection():ArrayCollection
		{
			return this._previewCollection;
		}

		public function set previewCollection(value:ArrayCollection):void
		{
			this._previewCollection = value;
		}

		public function get hasCustomName():Boolean
		{
			return this._hasCustomName;
		}

		public function set hasCustomName(value:Boolean):void
		{
			this._hasCustomName = value;
		}

		public function get selectedFinish():String
		{
			return this._selectedFinish;
		}

		public function set selectedFinish(value:String):void
		{
			this._selectedFinish = value;
		}

		public function get customName():String
		{
			return this._customName;
		}

		public function set customName(value:String):void
		{
			this._customName = value;
		}

		public function get customNameFont():String
		{
			return this._customNameFont;
		}

		public function set customNameFont(value:String):void
		{
			this._customNameFont = value;
		}

		public function resetProduct():void
		{
			trace('DecalrusModel::resetProduct');
			this.previewCollection = new ArrayCollection();
			this.templateCollection = new ArrayCollection();
			this.selectedModel = null;
			this.currentPrice = 0;
			this.customName = '';
			this.customNameFont = '';
			this.selectedFinish = 'matte';
		}

	}
}
