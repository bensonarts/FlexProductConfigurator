package com.ryan.geom 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class FreeTransformManager extends Sprite
	{
		public static const DEFAULT_MIN_SCALE:Number = 0.1;
		public static const DEFAULT_MAX_SCALE:Number = 10;
		public static const MOVE:int = 0;
		public static const SCALE:int = 1;
		public static const ROTATE:int = 2;
		public static const STAGE_MOUSE_UP:String = "stageMouseUp";
		
		public var startingX:Number = 0;
		public var startingY:Number = 0;
		
		protected var me:FreeTransformManager;
		protected var dispObj:DisplayObject;
		protected var _boundingRect:Sprite;
		protected var _border:Sprite;
		protected var _showInterestingStuff:Boolean;
		protected var _configs:Dictionary;
		protected var currConfig:Object;
		protected var stageListenersAdded:Boolean;
		
		protected var _moveHandler:Sprite;
		protected var _tlHandler:Sprite;
		protected var _trHandler:Sprite;
		protected var _blHandler:Sprite;
		protected var _brHandler:Sprite;
		protected var _brHandlerTrue:Sprite;
		protected var _tlrHandler:Sprite;
		protected var _trrHandler:Sprite;
		protected var _blrHandler:Sprite;
		protected var _brrHandler:Sprite;
		
		protected var handlerContainer:Sprite;
		protected var mouseAngle:Sprite;				//sprite containing the interesting stuff
		protected var trackPointsContainer:Sprite;
		protected var transformContainer:Sprite;
		
		protected var _localCenter:Point;
		
		protected var _storedX:Number = 0;
		protected var _storedY:Number = 0;
		protected var _storedRotation:Number = 0;
		protected var _storedScale:Number = 1;
		
		protected var mode:int = FreeTransformManager.MOVE;
		
		protected var mustReactivate:Boolean;
		protected var mIsDown:Boolean;
		protected var oriCP:Point;
		protected var oriCPCircle:TrackPoint;
		protected var oriX:Number;
		protected var oriY:Number;
		protected var oriAngle:Number;
		protected var oriDist:Number;
		protected var dX:Number;
		protected var dY:Number;
		protected var dAngle:Number;
		protected var iMatrix:Matrix;
		
		protected var angleOffset:Number;
		protected var scaleOffset:Number;
		protected var offsetX:Number;
		protected var offsetY:Number;
		
		protected var trackPoints:Array = [];
		
		/**
		 * Intializes the Freexform class. There should really be only one instance. There should be a singleton enforcer.
		 * 
		 * @param showInterestingStuff Show debug lines
		 * 
		 */		
		public function FreeTransformManager(showInterestingStuff:Boolean = false):void
		{
			this.me = this;
			this.iMatrix = new Matrix();
			this.iMatrix.identity();
			
			this._configs = new Dictionary(true);
			
			this.transformContainer = new Sprite();
			this.addChild(this.transformContainer);
			
			this._boundingRect = new Sprite();
			this.transformContainer.addChild(this._boundingRect);
			
			this.handlerContainer = new Sprite();
			this.addChild(this.handlerContainer);
			this._border = new Sprite();
			this.handlerContainer.addChild(this._border);
			
			this.buildHandles();
			
			this.mouseAngle = new Sprite();
			this.addChild(this.mouseAngle);
			
			this.trackPointsContainer = new Sprite();
			this.addChild(this.trackPointsContainer);
			
			// Add some default trackpoints
			this.trackPoints.push(this.newTrackPoint());
			this.trackPoints.push(this.newTrackPoint());
			this.trackPoints.push(this.newTrackPoint());
			
			this.showInterestingStuff = showInterestingStuff;
			this.me.addEventListener(MouseEvent.ROLL_OVER, this.onRollOver, false, 0, true);
			this.me.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut, false, 0, true);
			this.mustReactivate = true;
		}
		
		public function start():void
		{
			this._boundingRect.addEventListener(MouseEvent.MOUSE_DOWN, this.onDispObjMouseDown);
		}
		
		public function stop():void
		{
			this._boundingRect.removeEventListener(MouseEvent.MOUSE_DOWN, this.onDispObjMouseDown);
		}
		
		/**
		 * Adds an event listener to the display object to prepare it for free transform.
		 * 
		 * @param sourceSprite DisplayObject to register
		 * @param config Config options
		 * @param autoActivate Auto-focus when added
		 * 
		 */		
		public function registerSprite(sourceSprite:DisplayObject, config:Object = null, autoActivate:Boolean = false):void
		{
			trace('FreeTransformManager::registerSprite');
			sourceSprite.addEventListener(MouseEvent.MOUSE_DOWN, this._onSpriteFocus);
			if (autoActivate)
			{
				this.activateSprite(sourceSprite, config);
			}
		}
		
		/**
		 * Activates the free transform functions for the display object.
		 * 
		 * @param sourceSprite
		 * @param config
		 * 
		 */		
		public function activateSprite(sourceSprite:DisplayObject, config:Object = null):void
		{
			trace('FreeTransformManager::activateSprite');
			if (this.dispObj == sourceSprite)
			{
				return;
			}
			
			this.mustReactivate = false;
			
			if (config != null)
			{
				this._configs[sourceSprite] = config;
			}
			
			if (this._configs[sourceSprite] == undefined)
			{
				this._configs[sourceSprite] = { };
			}
			this.currConfig = _configs[sourceSprite] as Object;
			
			this.dispObj = sourceSprite;
			
			if (this.dispObj.stage)
			{
				this.init();
				return;
			}
			else
			{
				this.dispObj.addEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage);
			}
			
			this.init();
		}
		
		public function center():void
		{
			this.updateHandles();
		}
		
		/**
		 * Conforms to display object.
		 * 
		 */		
		public function updateAfterChange():void
		{
			this.conformToSprite();
		}
		
		/**
		 * If true, it will display the debug lines.
		 * 
		 * @param v
		 * 
		 */		
		public function set showInterestingStuff(v:Boolean):void
		{
			this._showInterestingStuff = v;
			
			if (this._showInterestingStuff)
			{
				this.mouseAngle.visible = true;
				this.trackPointsContainer.visible = true;
			}
			else
			{
				this.mouseAngle.visible = false;
				this.trackPointsContainer.visible = false;
			}
		}
		
		/**
		 * 
		 * @return
		 * 
		 */		
		public function get showInterestingStuff():Boolean
		{
			return this._showInterestingStuff;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get displayObjRotation():Number
		{
			return this.dispObj.rotation;
		}
		
		/**
		 * Hide the free transform controls.
		 * 
		 */		
		public function hideHandlers():void
		{
			this.handlerContainer.visible = false;
		}
		
		/**
		 * Show the free transform controls.
		 * 
		 */
		public function showHandlers():void
		{
			if (this.dispObj && this.dispObj.visible)
			{
				this.handlerContainer.visible = true;
			}
		}
		
		/**
		 * Manually set the size of the display object.
		 * 
		 * @param w width
		 * 
		 */		
		public function setSize(w:Number):void
		{
			this.oriCP = this.getRelativeCenterPoint();
			var s:Number = w / this._boundingRect.width;
			
			this._storedScale = s;
			this._applyStoredProperties();
		}
		
		/**
		 * Manually set the rotation of the display object.
		 * 
		 * @param r rotation
		 * 
		 */		
		public function setRotate(r:Number):void
		{
			this.oriCP = this.getRelativeCenterPoint();
			this._storedRotation = r;
			this._applyStoredProperties();
		}
		
		/**
		 * Manually sets the rotation of the display object. (Seems like a duplicate method)
		 * 
		 * @param r
		 * 
		 */		
		public function setRotateDeg(r:Number):void
		{
			this.setRotate(r * Math.PI / 180);
		}
		
		public function setScale(scale:Number):void
		{
			this.dispObj.scaleX = this.dispObj.scaleY = scale;
		}
		
		/**
		 * @deprecated
		 * @param obj
		 * @param w
		 * 
		 */		
		public function setObjectSize(obj:DisplayObject, w:Number):void 
		{
		}
		
		/**
		 * Get the minimum scale value.
		 * 
		 * @return 
		 * 
		 */		
		public function get minScale():Number
		{
			if (this.currConfig)
			{
				if (this.currConfig.minScale != undefined)
				{
					return this.currConfig.minScale;
				}
				else
				{
					if (this.currConfig.minW != undefined && this.currConfig.minH != undefined)
					{
						return Math.min(this.currConfig.minW / this._boundingRect.width, this.currConfig.minH / this._boundingRect.height);
					}
					else if (this.currConfig.minW != undefined)
					{
						return this.currConfig.minW / this._boundingRect.width;
					}
					else if (this.currConfig.minH != undefined)
					{
						return this.currConfig.minH / this._boundingRect.height;
					}
				}
			}
			return FreeTransformManager.DEFAULT_MIN_SCALE;
		}
		
		/**
		 * Get the maximum scale value.
		 * 
		 * @return 
		 * 
		 */		
		public function get maxScale():Number
		{
			if (this.currConfig)
			{
				if (this.currConfig.maxScale != undefined)
				{
					return this.currConfig.maxScale;
				}
				else
				{
					if (this.currConfig.maxW != undefined && this.currConfig.maxH != undefined)
					{
						return Math.max(this.currConfig.maxW / this._boundingRect.width, this.currConfig.maxH / this._boundingRect.height);
					}
					else if (this.currConfig.maxW != undefined)
					{
						return this.currConfig.maxW / this._boundingRect.width;
					}
					else if (this.currConfig.maxH != undefined)
					{
						return this.currConfig.maxH / this._boundingRect.height;
					}
				}
			}
			return FreeTransformManager.DEFAULT_MAX_SCALE;
		}
		
		/**
		 * Added the display object to the display list. Adds event listenters.
		 * 
		 */		
		protected function init():void
		{
			trace('FreeTransformManager::init');
			this.conformToSprite();
			
			this.startingX = this.dispObj.x;
			this.startingY = this.dispObj.y;
			
			// Bring the sprite to the top
			var oriParent:DisplayObjectContainer = dispObj.parent as DisplayObjectContainer;
			oriParent.addChild(this.dispObj);
			oriParent.addChild(this.me);
			
			this.updateHandles();
			this.showHandlers();
			
			if ( ! this.stageListenersAdded)
			{
				this.stageListenersAdded = true;
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onStageMouseMove);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, this.onStageMouseUp);
			}
			
			this.dispatchEvent(new FreeTransformEvent(FreeTransformEvent.ON_TRANSFORM, this.dispObj, this._storedX, this._storedY, this._storedRotation, this._storedScale));
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		protected function get localCenter():Point
		{
			return this._localCenter;
		}
		
		/**
		 * Conform free transform controls to current display object.
		 * 
		 */		
		protected function conformToSprite():void
		{
			var tempMatrix:Matrix = this.dispObj.transform.matrix;
			
			this._storedX = this.dispObj.x;
			this._storedY = this.dispObj.y;
			this._storedRotation = this.dispObj.rotation * (Math.PI / 180);
			this._storedRotation = 0;
			this._storedScale = this.dispObj.scaleX; //assume scaleX == scaleY
			
			this.dispObj.transform.matrix = new Matrix();
			
			// Draw a new bounding rect
			this._boundingRect.graphics.clear();
			this._boundingRect.graphics.beginFill(0xff0000, 0);
			this._boundingRect.graphics.drawRect(0, 0, this.dispObj.width, this.dispObj.height);
			this._boundingRect.graphics.endFill();
			
			// Get new LocalCenter
			this._localCenter = new Point(this.dispObj.width / 2, this.dispObj.height / 2);
			(trackPoints[1] as TrackPoint).update('localCenter', this.localCenter);
			
			this.transformContainer.transform.matrix = tempMatrix;
			this.dispObj.transform.matrix = tempMatrix;
			this.updateHandles();
		}
		
		/**
		 * Creates the the free transform controls.
		 * 
		 */		
		protected function buildHandles():void
		{
			// Scale handles
			this._tlHandler = this.genDefaultHandle();
			this._trHandler = this.genDefaultHandle();
			this._blHandler = this.genDefaultHandle();
			this._brHandler = this.genDefaultHandle();
			this.handlerContainer.addChild(this._tlHandler);
			this.handlerContainer.addChild(this._trHandler);
			this.handlerContainer.addChild(this._blHandler);
			this.handlerContainer.addChild(this._brHandler);
			this._tlHandler.addEventListener(MouseEvent.MOUSE_DOWN, this.onScaleHandlerDown);
			this._trHandler.addEventListener(MouseEvent.MOUSE_DOWN, this.onScaleHandlerDown);
			this._blHandler.addEventListener(MouseEvent.MOUSE_DOWN, this.onScaleHandlerDown);
			this._brHandler.addEventListener(MouseEvent.MOUSE_DOWN, this.onScaleHandlerDown);
			// Rotation handles
			this._tlrHandler = this.genDefaultRotationHandle(0);
			this._trrHandler = this.genDefaultRotationHandle(90);
			this._blrHandler = this.genDefaultRotationHandle(270);
			this._brrHandler = this.genDefaultRotationHandle(180);
			this.handlerContainer.addChild(this._tlrHandler);
			this.handlerContainer.addChild(this._trrHandler);
			this.handlerContainer.addChild(this._blrHandler);
			this.handlerContainer.addChild(this._brrHandler);
			this._tlrHandler.addEventListener(MouseEvent.MOUSE_DOWN, this.onRotationHandlerDown);
			this._trrHandler.addEventListener(MouseEvent.MOUSE_DOWN, this.onRotationHandlerDown);
			this._blrHandler.addEventListener(MouseEvent.MOUSE_DOWN, this.onRotationHandlerDown);
			this._brrHandler.addEventListener(MouseEvent.MOUSE_DOWN, this.onRotationHandlerDown);
		}
		
		/**
		 * Factory method to generate scale handles.
		 * 
		 * @return 
		 * 
		 */		
		protected function genDefaultHandle():Sprite
		{
			var tempSprite:Sprite = new Sprite();
			tempSprite.graphics.beginFill(0xfc8037, 1);
			tempSprite.graphics.drawRect(-5, -5, 10, 10);
			tempSprite.graphics.endFill();
			tempSprite.useHandCursor = true;
			
			return tempSprite;
		}
		
		/**
		 * Factory method to generate rotation handles.
		 * 
		 * @param r Rotation
		 * @return 
		 * 
		 */		
		protected function genDefaultRotationHandle(r:Number):Sprite
		{
			var handle:RotateHandle = new RotateHandle();
			handle.clip.rotation = r;
			switch (r)
			{
				case 0:
					handle.clip.x = -24;
					handle.clip.y = -24;
					break;
				case 90:
					handle.clip.x = 24;
					handle.clip.y = -24;
					break;
				case 180:
					handle.clip.x = 24;
					handle.clip.y = 24;
					break;
				case 270:
					handle.clip.x = -28;
					handle.clip.y = 24;
					break;
				default:
					break;
			}
			return handle;
		}
		
		/**
		 * Orients the free transform controls to the matrix of the current display object.
		 * 
		 */		
		protected function updateHandles():void
		{
			var tempPoint:Point;
			
			this._border.graphics.clear();
			this._border.graphics.lineStyle(2, 0xfc8037, 1, true);
			
			//top left
			tempPoint = me.globalToLocal(this.transformContainer.localToGlobal(new Point(0, 0)));
			this._tlHandler.x = tempPoint.x;
			this._tlHandler.y = tempPoint.y;
			this._tlHandler.rotation = this._storedRotation / (Math.PI / 180);
			this._tlrHandler.x = tempPoint.x;
			this._tlrHandler.y = tempPoint.y;
			this._tlrHandler.rotation = this._storedRotation / (Math.PI / 180);
			this._border.graphics.moveTo(tempPoint.x, tempPoint.y);
			
			//top right
			tempPoint = me.globalToLocal(this.transformContainer.localToGlobal(new Point(this._boundingRect.width, 0)));
			this._trHandler.x = tempPoint.x;
			this._trHandler.y = tempPoint.y;
			this._trHandler.rotation = this._storedRotation / (Math.PI / 180);
			this._trrHandler.x = tempPoint.x;
			this._trrHandler.y = tempPoint.y;
			this._trrHandler.rotation = this._storedRotation / (Math.PI / 180);
			this._border.graphics.lineTo(tempPoint.x, tempPoint.y);
			
			//bottom right
			tempPoint = me.globalToLocal(this.transformContainer.localToGlobal(new Point(this._boundingRect.width, this._boundingRect.height)));
			this._brHandler.x = tempPoint.x;
			this._brHandler.y = tempPoint.y;
			this._brHandler.rotation = this._storedRotation / (Math.PI / 180);
			this._brrHandler.x = tempPoint.x;
			this._brrHandler.y = tempPoint.y;
			this._brrHandler.rotation = this._storedRotation / (Math.PI / 180);
			this._border.graphics.lineTo(tempPoint.x, tempPoint.y);
			
			//bottom left
			tempPoint = me.globalToLocal(transformContainer.localToGlobal(new Point(0, this._boundingRect.height)));
			this._blHandler.x = tempPoint.x;
			this._blHandler.y = tempPoint.y;
			this._blHandler.rotation = this._storedRotation / (Math.PI / 180);
			this._blrHandler.x = tempPoint.x;
			this._blrHandler.y = tempPoint.y;
			this._blrHandler.rotation = this._storedRotation / (Math.PI / 180);
			this._border.graphics.lineTo(tempPoint.x, tempPoint.y);
			
			//top left
			tempPoint = this.me.globalToLocal(this.transformContainer.localToGlobal(new Point(0, 0)));
			this._border.graphics.lineTo(tempPoint.x, tempPoint.y);
		}
		
		/**
		 * Display object mouse down event handler.
		 * 
		 * @param evt
		 * 
		 */		
		protected function onDispObjMouseDown(evt:MouseEvent):void
		{
			if (this.dispObj && this.dispObj.visible && this.stage)
			{
				if (this.mustReactivate)
				{
					this.activateSprite(this.dispObj);
				}
				
				this.mode = FreeTransformManager.MOVE;
				this.mIsDown = true;
				
				this.showHandlers();
				
				this.oriX = this.stage.mouseX;
				this.oriY = this.stage.mouseY;
				this.offsetX = this._storedX;
				this.offsetY = this._storedY;
				this.oriCP = this.getRelativeCenterPoint();
				(trackPoints[2] as TrackPoint).update('oriCP', this.oriCP);
				this.dispObj.alpha = 0.5;
			}
		}
		
		/**
		 * Display object roll over event handler.
		 * 
		 * @param evt
		 * 
		 */		
		protected function onRollOver(evt:MouseEvent):void
		{
			this.handlerContainer.alpha = 1;
			this.transformContainer.alpha = 1;
		}
		
		/**
		 * Display object roll out event handler.
		 * 
		 * @param evt
		 * 
		 */		
		protected function onRollOut(evt:MouseEvent):void
		{
			this.handlerContainer.alpha = 0.5;
			this.transformContainer.alpha = 0;
		}
		
		/**
		 * Scale handler mouse down event handler.
		 * 
		 * @param evt
		 * 
		 */		
		protected function onScaleHandlerDown(e:MouseEvent):void
		{
			this.dispObj.alpha = 0.5;
			this.mode = FreeTransformManager.SCALE;
			this.mIsDown = true;
			var currHandler:Sprite = e.target as Sprite;
			var handlerCenter:Point = this.me.globalToLocal(currHandler.localToGlobal(new Point(0, 0)));
			this.oriX = handlerCenter.x;
			this.oriY = handlerCenter.y;
			
			this.oriCP = this.getRelativeCenterPoint();
			(trackPoints[2] as TrackPoint).update('oriCP', this.oriCP);
			
			this.oriAngle = this.getAngleFromMouseCoord(this.oriX, this.oriY, this.oriCP);
			
			this.oriDist = Math.sqrt(Math.pow(this.oriX - this.oriCP.x, 2) + Math.pow(this.oriY - this.oriCP.y, 2));
			this.scaleOffset = this._storedScale;
		}
		
		/**
		 * Rotation handler mouse down event.
		 * 
		 * @param e
		 * 
		 */		
		protected function onRotationHandlerDown(e:MouseEvent):void
		{
			this.dispObj.alpha = 0.5;
			this.mode = FreeTransformManager.ROTATE;
			
			this.mIsDown = true;
			var currHandler:Sprite = e.target as Sprite;
			var handlerCenter:Point = this.me.globalToLocal(currHandler.localToGlobal(new Point(0, 0)));
			this.oriX = handlerCenter.x;
			this.oriY = handlerCenter.y;
			
			this.oriCP = this.getRelativeCenterPoint();
			(trackPoints[2] as TrackPoint).update('oriCP', this.oriCP);
			
			this.oriAngle = this.getAngleFromMouseCoord(this.oriX, this.oriY, this.oriCP);
			
			this.oriDist = Math.sqrt(Math.pow(this.oriX - this.oriCP.x, 2) + Math.pow(this.oriY - this.oriCP.y, 2));
			this.angleOffset = this._storedRotation;
		}
		
		/**
		 * Stage mouse move event handler.
		 * 
		 * @param evt
		 * 
		 */		
		protected function onStageMouseMove(evt:MouseEvent):void 
		{
			if (this.mIsDown)
			{
				var currX:Number;
				var currY:Number;
				
				switch (this.mode)
				{
					case FreeTransformManager.MOVE:
						currX = this.stage.mouseX;
						currY = this.stage.mouseY;
						this.dX = currX - this.oriX;
						this.dY = currY - this.oriY;
						this.onTranslate(this.dX, this.dY);
						break;
					case FreeTransformManager.SCALE:
						currX = this.me.mouseX;
						currY = this.me.mouseY;
						
						var newDist:Number = Math.sqrt(Math.pow(currX - this.oriCP.x, 2) + Math.pow(currY - this.oriCP.y, 2));
						var percentage:Number = newDist / this.oriDist;
						
						this.onTransformScale(percentage);
						
						this.clear();
						this.drawLine(this.oriCP.x, this.oriCP.y, currX, currY, 0x110000);
						this.drawLine(this.oriCP.x, this.oriCP.y, this.oriX, this.oriY, 0x001100);
						break;
					case FreeTransformManager.ROTATE:
						currX = this.me.mouseX;
						currY = this.me.mouseY;
						var currAngle:Number = this.getAngleFromMouseCoord(currX, currY, this.oriCP);
						this.dAngle = currAngle - this.oriAngle;
						
						this.onTransformRotation(this.dAngle);
						
						this.clear();
						this.drawLine(this.oriCP.x, this.oriCP.y, currX, currY, 0x110000);
						this.drawLine(this.oriCP.x, this.oriCP.y, this.oriX, this.oriY, 0x001100);
						break;
					default:
						break;
				}
			}
		}
		
		/**
		 * Returns the value of the angle from mouse coordinates.
		 * 
		 * @param mx
		 * @param my
		 * @param center
		 * @return 
		 * 
		 */		
		protected function getAngleFromMouseCoord(mx:Number, my:Number, center:Point):Number
		{
			var relX:Number = mx - center.x;
			var relY:Number = my - center.y;
			var angle:Number;
			var quad:int; //0: top left, 1:top right, 2:bottom right, 3:bottom left
			
			//flip Y
			relY = -relY;
			if (relX == 0 || relY == 0)
			{			
				if (this.currConfig.prevQuad != undefined)
				{
					quad = this.currConfig.prevQuad;
				}
				else 
				{
					quad = 0; //default to first quadrant
				}
			}
			
			if (relX > 0 && relY > 0) 
			{
				quad = 0;
			}
			else if (relX > 0 && relY < 0)
			{
				quad = 1;
			}
			else if (relX < 0 && relY < 0)
			{
				quad = 2;
			}
			else if (relX < 0 && relY > 0)
			{
				quad = 3;
			}
			
			this.currConfig.prevQuad = quad;
			
			relX = Math.abs(relX);
			relY = Math.abs(relY);
			
			angle = Math.atan(relY / relX);
			switch (quad)
			{
				case 0:
					angle = (Math.PI / 2) - angle;
					break;
				case 1:
					angle = angle + (Math.PI / 2);
					break;
				case 2:
					angle = (Math.PI / 2) - angle + Math.PI;
					break;
				case 3:
					angle = angle + (3 * Math.PI / 2);
					break;
				default:
					break;
			}
			
			return angle;
		}
		
		/**
		 * Stage mouse up event handler.
		 * 
		 * @param evt
		 * 
		 */		
		protected function onStageMouseUp(evt:MouseEvent):void
		{
			this.mIsDown = false;
			this.clear();
			this.dispatchEvent(new Event(FreeTransformManager.STAGE_MOUSE_UP));
			this.dispObj.alpha = 1;
		}
		
		/**
		 * Handles simply moving the object. Dispatches the FreeTransformEvent with stored values.
		 * 
		 * @param dX
		 * @param dY
		 * 
		 */		
		protected function onTranslate(dX:Number, dY:Number):void
		{
			this._storedX = dX + this.offsetX;
			this._storedY = dY + this.offsetY;
			
			var matrix:Matrix = this.dispObj.transform.matrix;
			matrix.tx = this._storedX;
			matrix.ty = this._storedY;
			
			this.dispObj.transform.matrix = matrix;
			this.transformContainer.transform.matrix = matrix;
			this.updateHandles();
			
			this.dispatchEvent(new FreeTransformEvent(FreeTransformEvent.ON_TRANSFORM, this.dispObj, this._storedX, this._storedY, this._storedRotation, this._storedScale));
		}
		
		/**
		 * Handles scaling of the object. Dispatches the FreeTransformEvent with stored values.
		 * 
		 * @param scale
		 * 
		 */		
		protected function onTransformScale(scale:Number):void
		{
			this._storedScale = scale * this.scaleOffset;
			
			this._applyStoredProperties(); 
			this.dispatchEvent(new FreeTransformEvent(FreeTransformEvent.ON_TRANSFORM, this.dispObj, this._storedX, this._storedY, this._storedRotation, this._storedScale));
		}
		
		/**
		 * Handles rotation of the object. Dispatches the FreeTransformEvent with stored values.
		 * 
		 * @param scale
		 * 
		 */	
		protected function onTransformRotation(angle:Number):void
		{
			this._storedRotation = angle + this.angleOffset;
			
			this._applyStoredProperties(); 
			this.dispatchEvent(new FreeTransformEvent(FreeTransformEvent.ON_TRANSFORM, this.dispObj, this._storedX, this._storedY, this._storedRotation, this._storedScale));
		}
		
		/**
		 * Updates storage variables with display object's positioning properties.
		 * 
		 */		
		protected function _applyStoredProperties():void
		{
			if (this._storedRotation < -Math.PI)
			{
				this._storedRotation = (2 * Math.PI) + this._storedRotation;
			}
			else if (this._storedRotation > Math.PI)
			{
				this._storedRotation = this._storedRotation - (2 * Math.PI);
			}
			
			// Constrain Scale by config
			if (this._storedScale < this.minScale)
			{
				this._storedScale = this.minScale;
			}
			
			if (this._storedScale > this.maxScale)
			{
				this._storedScale = this.maxScale;
			}
			
			var matrix:Matrix = new Matrix();
			matrix.rotate(this._storedRotation);
			matrix.scale(this._storedScale, this._storedScale);
			
			var transedP:Point = matrix.transformPoint(this.localCenter);
			(trackPoints[0] as TrackPoint).update('transedP', transedP);
			matrix.translate(-transedP.x, -transedP.y);
			
			// return to original postion
			matrix.translate(this.oriCP.x, this.oriCP.y);
			this._storedX = matrix.tx;
			this._storedY = matrix.ty;
			
			this.dispObj.transform.matrix = matrix;
			this.transformContainer.transform.matrix = matrix;
			this.updateHandles();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		protected function getRelativeCenterPoint():Point
		{
			return this.me.globalToLocal(this.dispObj.localToGlobal(this._localCenter));
		}
		
		/**
		 * 
		 * 
		 */		
		protected function clear():void
		{
			this.mouseAngle.graphics.clear();
		}
		
		/**
		 * 
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @param color
		 * 
		 */		
		protected function drawLine(x1:Number, y1:Number, x2:Number, y2:Number, color:uint):void
		{
			this.mouseAngle.graphics.lineStyle(3, color, 0.6, true);
			this.mouseAngle.graphics.moveTo(x1, y1);
			this.mouseAngle.graphics.lineTo(x2, y2);
		}
		
		/**
		 * 
		 * @param label
		 * @param point
		 * @return 
		 * 
		 */		
		protected function newTrackPoint(label:String = '', point:Point = null):TrackPoint
		{
			var tempTP:TrackPoint = new TrackPoint(label, point);
			this.trackPointsContainer.addChild(tempTP);
			return tempTP;
		}
		
		private function _onSpriteFocus(evt:MouseEvent):void
		{
			this.activateSprite(evt.target as DisplayObject, null);
			this.onDispObjMouseDown(evt);
		}
		
		private function _onAddedToStage(e:Event):void
		{
			this.dispObj.removeEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage);
			this.init();
		}
		
	}
}
