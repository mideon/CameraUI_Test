package
{
	import com.freshplanet.ui.ScrollableContainer;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.MouseEvent;
	import flash.events.PermissionEvent;
	import flash.events.StageOrientationEvent;
	import flash.media.CameraUI;
	import flash.media.MediaType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mideon.app.proxies.camera.events.CameraEvents;
	
	public class cameraUI_Test extends Sprite
	{
		public static var indent:Number = 0;
		
		private var _scrollableContainer:ScrollableContainer = null;

		private var rotateDefaultBtn:Button;

		private var rotateLandscape:Button;

		private var console:TextField;

		private var callCameraBtn:Button;

		private var deviceCamera:CameraUI;
		
		public function cameraUI_Test()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			init();
		}
		
		private function drawTriangle():Sprite {
			var triangle:Sprite = new Sprite();
			triangle.graphics.lineStyle(2, 0x00ff00);
			triangle.graphics.moveTo((stage.stageWidth >> 1), (stage.stageHeight * 0.25));
			triangle.graphics.lineTo((stage.stageWidth * 0.75), (stage.stageHeight * 0.75));
			triangle.graphics.lineTo((stage.stageWidth * 0.25), (stage.stageHeight * 0.75));
			triangle.graphics.lineTo((stage.stageWidth >> 1), (stage.stageHeight * 0.25));
			
			return triangle;
		}
		
		private function init():void {
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChangedHandler);
			addChild(drawTriangle());
			rotateDefaultBtn = new Button("Rotate Default");
			rotateDefaultBtn.addEventListener(MouseEvent.CLICK, onRotateDefaultHanlder);
			rotateDefaultBtn.x = 100;
			rotateDefaultBtn.y = 10;
			addChild(rotateDefaultBtn);
			
			rotateLandscape = new Button("Rotate Landscape");
			rotateLandscape.addEventListener(MouseEvent.CLICK, onRotateLandscapeHanlder);
			rotateLandscape.x = 100;
			rotateLandscape.y = rotateDefaultBtn.y + rotateDefaultBtn.height + 10;
			addChild(rotateLandscape);
			
			callCameraBtn = new Button("Camera");
			callCameraBtn.x = 100;
			callCameraBtn.y = rotateLandscape.y + rotateLandscape.height + 10;
			callCameraBtn.addEventListener(MouseEvent.CLICK, onClickCallCameraHandler);
			addChild(callCameraBtn);
			
			console = new TextField();
			console.x = 20;
			console.defaultTextFormat = new TextFormat(null, 24);
			console.width = 400;
			console.height = 200;
			console.y = callCameraBtn.y + callCameraBtn.height + 10;
			addChild(console);
		}			
		
		protected function onClickCallCameraHandler(event:MouseEvent):void
		{
			deviceCamera = new CameraUI();
			
			if(CameraUI.isSupported) {
				deviceCamera.addEventListener(PermissionEvent.PERMISSION_STATUS, onPermissionStatus);
				deviceCamera.requestPermission();
			} else {
				openDeviceCamera();
			}
		}
		
		protected function onPermissionStatus(event:PermissionEvent):void
		{
			deviceCamera.removeEventListener(PermissionEvent.PERMISSION_STATUS, onPermissionStatus);
			openDeviceCamera();
		}
		
		private function openDeviceCamera():void
		{
			deviceCamera.addEventListener(MediaEvent.COMPLETE, onCompleteHandler);
			deviceCamera.addEventListener(ErrorEvent.ERROR, onErrorHandler);
			deviceCamera.addEventListener(Event.CANCEL, onCancel);
			deviceCamera.launch(MediaType.IMAGE);
		}
		
		protected function onCompleteHandler(event:MediaEvent):void
		{			
			log("\nCamera ok");
			log("Current orientation: " + stage.orientation);
		}
		
		protected function onCancel(event:Event):void
		{
			log("\nCamera Canceled");
			log("Current orientation: " + stage.orientation);
		}
		
		protected function onErrorHandler(event:ErrorEvent):void
		{
			log("Camera call error");
		}
		
		protected function onOrientationChangedHandler(event:StageOrientationEvent):void
		{
			log("\nOrientation Handler");
			log("Orientation: " + event.afterOrientation);
		}
		
		
		private function log(msg:String):void {
			console.appendText(msg + "\n");
			trace(msg);
		}
		
		protected function onRotateLandscapeHanlder(event:MouseEvent):void
		{
			stage.setOrientation(StageOrientation.ROTATED_RIGHT);
		}
		
		protected function onRotateDefaultHanlder(event:MouseEvent):void
		{
			stage.setOrientation(StageOrientation.DEFAULT);
		}
	}
}
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class Button extends Sprite {
	public function Button(lbl_txt:String) {
		super();
		var w:uint = 400;
		var h:uint = 80;
		graphics.beginFill(0xcccccc);
		graphics.drawRect(0, 0, w, h);
		graphics.endFill();
		
		var txt:TextField = new TextField();
		txt.autoSize = TextFieldAutoSize.LEFT;
		txt.defaultTextFormat = new TextFormat(null, 32);
		txt.mouseEnabled = false;
		txt.text = lbl_txt;
		addChild(txt);
		txt.x = (w - (txt.textWidth + 4) ) >> 1;
		txt.y = (h - (txt.textHeight + 4)) >> 1;
	}
}