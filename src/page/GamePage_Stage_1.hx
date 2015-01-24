package page;
import flambe.asset.AssetPack;
import flambe.Component;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.Texture;
import flambe.Disposer;
import flambe.Entity;
import flambe.input.KeyboardEvent;
import flambe.input.MouseEvent;
import flambe.input.PointerEvent;
import flambe.System;
import gui.GUI_Button;
import urgame.Game;
import urgame.Kernel;

/**
 * ...
 * @author ragbit
 */
class GamePage_Stage_1 extends GamePage
{
	private var controllableTarget : ImageSprite = null;
	
	public function new( l_parent : Entity ) 
	{
		super( l_parent );
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		
		initControllableTarget("plane", 300, 300);
		createButton("gui/start-normal", "gui/start-click", false, 200, 200, buttonClickRotateClockwise);
		createButton("gui/start-normal", "gui/start-click", false, 450, 200, buttonClickRotateAntiClockwise);
		createButton("gui/start-normal", "gui/start-click", false, 200, 400, buttonClickRotateScaleLarger);
		createButton("gui/start-normal", "gui/start-click", false, 450, 400, buttonClickRotateScaleSmaller);
	}
	
	private function initControllableTarget(imagePath : String, x : Float, y : Float)
	{
		controllableTarget = new ImageSprite(pack.getTexture(imagePath));
		controllableTarget.centerAnchor().x._ = x1() + x;
		controllableTarget.centerAnchor().y._ = y1() + y;
		controllableTarget.setScaleXY((Math.random() * 2) + 1.1, (Math.random() * 2) + 1.1);
		controllableTarget.setRotation(Math.random() * 360);
		this.entityLayer.addChild(new Entity().add(controllableTarget));
	}
	
	private function createButton(normalPath : String, clickPath : String, leftScreen : Bool, x : Float, y : Float, func : String -> Void)
	{
		var normalTexture : Texture = pack.getTexture(normalPath);
		var clickTexture : Texture = pack.getTexture(clickPath);		
		var button = new GUI_Button(normalTexture, clickTexture, func);
		
		if (leftScreen)
		{
			button.centerAnchor().x._ = x2() + x;
			button.centerAnchor().y._ = y2() + y;
		}
		else
		{
			button.centerAnchor().x._ = x2() + x;
			button.centerAnchor().y._ = y2() + y;
		}
		
		this.entityLayer.addChild(new Entity().add(button));
	}
	
	private function buttonClickRotateClockwise(parameter : String)
	{
		if (controllableTarget != null)
		{
			trace("dwhqjdbjwq");
			controllableTarget.setRotation(100);
		}
	}
	
	private function buttonClickRotateAntiClockwise(parameter : String)
	{
		if (controllableTarget != null)
		{
			controllableTarget.setRotation(-100);
		}
	}
	
	private function buttonClickRotateScaleLarger(parameter : String)
	{
		if (controllableTarget != null)
		{
			controllableTarget.setScaleXY(1.1, 1.1);
		}
	}
	
	private function buttonClickRotateScaleSmaller(parameter : String)
	{
		if (controllableTarget != null)
		{
			controllableTarget.setScaleXY(-1.1, -1.1);
		}
	}
	
	override public function onUpdate(dt:Float) 
	{
		super.onUpdate(dt);
	}
	
	override public function dispose() 
	{
		super.dispose();
	}
	
	override private function onKeyUp( e : KeyboardEvent ) : Void {
	}
	
	override private function onKeyDown( e : KeyboardEvent ) : Void {
	}
	
	override private function onMouseDown( e : PointerEvent ) : Void {
	}
	
	override private function onMouseUp( e : PointerEvent ) : Void {
	}
	
	override private function onMouseMove( e : PointerEvent ) : Void {
	}
}