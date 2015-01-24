package page ;
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
	private var MoveSpeed : Float = 350;
	
	private var controllableTarget : ImageSprite = null;	
	private var RotateClockwise : Bool = false;
	private var RotateAntiClockwise : Bool = false;
	private var ScaleUpX : Bool = false;
	private var ScaleDownX : Bool = false;
	private var ScaleUpY : Bool = false;
	private var ScaleDownY : Bool = false;
	private var MoveUp : Bool = false;
	private var MoveDown : Bool = false;
	private var MoveLeft : Bool = false;
	private var MoveRight : Bool = false;
	
	public function new( l_parent : Entity ) 
	{
		super( l_parent );
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		
		initControllableTarget("plane", 300, 300);
		createButton("gui/start-normal", "gui/start-click", false, 200, 50, buttonClickRotateClockwise);
		createButton("gui/start-normal", "gui/start-click", false, 430, 50, buttonClickRotateAntiClockwise);
		createButton("gui/start-normal", "gui/start-click", false, 200, 150, buttonClickScaleUpX);
		createButton("gui/start-normal", "gui/start-click", false, 430, 150, buttonClickScaleDownX);
		createButton("gui/start-normal", "gui/start-click", false, 200, 250, buttonClickScaleUpY);
		createButton("gui/start-normal", "gui/start-click", false, 430, 250, buttonClickScaleDownY);
		createButton("gui/start-normal", "gui/start-click", false, 200, 350, buttonClickMoveUp);
		createButton("gui/start-normal", "gui/start-click", false, 430, 350, buttonClickMoveDown);
		createButton("gui/start-normal", "gui/start-click", false, 200, 450, buttonClickMoveLeft);
		createButton("gui/start-normal", "gui/start-click", false, 430, 450, buttonClickMoveRight);
	}
	
	private function initControllableTarget(imagePath : String, x : Float, y : Float)
	{
		controllableTarget = new ImageSprite(pack.getTexture(imagePath));
		controllableTarget.centerAnchor();
		controllableTarget.centerAnchor();
		controllableTarget.x._ = x1() + x;
		controllableTarget.y._ = y1() + y;
		controllableTarget.setScaleXY((Math.random() * 3) + 1.1, (Math.random() * 3) + 1.1);
		controllableTarget.setRotation(Math.random() * 360);
		this.entityLayer.addChild(new Entity().add(controllableTarget));
	}
	
	private function createButton(normalPath : String, clickPath : String, leftScreen : Bool, x : Float, y : Float, func : String -> Void)
	{
		var normalTexture : Texture = pack.getTexture(normalPath);
		var clickTexture : Texture = pack.getTexture(clickPath);		
		var button = new GUI_Button(normalTexture, clickTexture, func);
		
		button.centerAnchor();
		button.centerAnchor();
		
		if (leftScreen)
		{
			button.x._ = x1() + x;
			button.y._ = y1() + y;
		}
		else
		{
			button.x._ = x2() + x;
			button.y._ = y2() + y;
		}
		
		this.entityLayer.addChild(new Entity().add(button));
	}
	
	private function buttonClickMoveUp(parameter : String)
	{
		if (controllableTarget != null)
		{
			if (parameter == GUI_Button.DOWN)
			{
				MoveUp = true;
			}
			else
			{
				MoveUp = false;
			}
		}
	}
	
	private function buttonClickMoveDown(parameter : String)
	{
		if (controllableTarget != null)
		{
			if (parameter == GUI_Button.DOWN)
			{
				MoveDown = true;
			}
			else
			{
				MoveDown = false;
			}
		}
	}
	
	private function buttonClickMoveLeft(parameter : String)
	{
		if (controllableTarget != null)
		{
			if (parameter == GUI_Button.DOWN)
			{
				MoveLeft = true;
			}
			else
			{
				MoveLeft = false;
			}
		}
	}
	
	private function buttonClickMoveRight(parameter : String)
	{
		if (controllableTarget != null)
		{
			if (parameter == GUI_Button.DOWN)
			{
				MoveRight = true;
			}
			else
			{
				MoveRight = false;
			}
		}
	}
	
	private function buttonClickRotateClockwise(parameter : String)
	{
		if (controllableTarget != null)
		{
			if (parameter == GUI_Button.DOWN)
			{
				RotateClockwise = true;
			}
			else
			{
				RotateClockwise = false;
			}
		}
	}
	
	private function buttonClickRotateAntiClockwise(parameter : String)
	{
		if (controllableTarget != null)
		{
			if (parameter == GUI_Button.DOWN)
			{
				RotateAntiClockwise = true;
			}
			else
			{
				RotateAntiClockwise = false;
			}
		}
	}
	
	private function buttonClickScaleUpX(parameter : String)
	{
		if (controllableTarget != null)
		{
			if (parameter == GUI_Button.DOWN)
			{
				ScaleUpX = true;
			}
			else
			{
				ScaleUpX = false;
			}
		}
	}
	
	private function buttonClickScaleDownX(parameter : String)
	{
		if (controllableTarget != null)
		{
			if (parameter == GUI_Button.DOWN)
			{
				ScaleDownX = true;
			}
			else
			{
				ScaleDownX = false;
			}
		}
	}
	
	private function buttonClickScaleUpY(parameter : String)
	{
		if (controllableTarget != null)
		{
			if (parameter == GUI_Button.DOWN)
			{
				ScaleUpY = true;
			}
			else
			{
				ScaleUpY = false;
			}
		}
	}
	
	private function buttonClickScaleDownY(parameter : String)
	{
		if (controllableTarget != null)
		{
			if (parameter == GUI_Button.DOWN)
			{
				ScaleDownY = true;
			}
			else
			{
				ScaleDownY = false;
			}
		}
	}
	
	override public function onUpdate(dt:Float) 
	{
		super.onUpdate(dt);
		
		if (RotateClockwise)
		{
			controllableTarget.setRotation(controllableTarget.rotation._ + (100 * dt));
		}
		
		if (RotateAntiClockwise)
		{
			controllableTarget.setRotation(controllableTarget.rotation._ + (-100 * dt));
		}
		
		if (ScaleUpX)
		{
			if (controllableTarget.scaleX._ < 10
			&& (controllableTarget.x._ + ((controllableTarget.getNaturalWidth() * (controllableTarget.scaleX._ + (5 * dt))) / 2) < this.pageWidth() + x1())
			&& (controllableTarget.x._ - ((controllableTarget.getNaturalWidth() * (controllableTarget.scaleX._ + (5 * dt))) / 2) > x1()))
			{
				controllableTarget.setScaleXY(controllableTarget.scaleX._ + (5 * dt), controllableTarget.scaleY._);
			}
		}
		
		if (ScaleDownX)
		{
			if (controllableTarget.scaleX._ > 0.3)
			{
				controllableTarget.setScaleXY(controllableTarget.scaleX._ + ( -5 * dt), controllableTarget.scaleY._);
			}
		}
		
		if (ScaleUpY)
		{
			if (controllableTarget.scaleY._ < 10			
			&& (controllableTarget.y._ + ((controllableTarget.getNaturalHeight() * (controllableTarget.scaleY._ + (5 * dt))) / 2) < this.pageHeight() + y1())
			&& (controllableTarget.y._ - ((controllableTarget.getNaturalHeight() * (controllableTarget.scaleY._ + (5 * dt))) / 2) > y1()))
			{
				controllableTarget.setScaleXY(controllableTarget.scaleX._, controllableTarget.scaleY._ + (5 * dt));
			}
		}
		
		if (ScaleDownY)
		{
			if (controllableTarget.scaleY._ > 0.3)
			{
				controllableTarget.setScaleXY(controllableTarget.scaleX._, controllableTarget.scaleY._ + ( -5 * dt));
			}
		}
		
		if (MoveUp)
		{
			if (controllableTarget.y._ + (MoveSpeed * dt) + ((controllableTarget.getNaturalHeight() * controllableTarget.scaleY._) / 2) < this.pageHeight() + y1())
			{
				controllableTarget.y._ = controllableTarget.y._ + (MoveSpeed * dt);
			}
		}
		
		if (MoveDown)
		{
			if (controllableTarget.y._ - (MoveSpeed * dt) - ((controllableTarget.getNaturalHeight() * controllableTarget.scaleY._) / 2) > y1())
			{
				controllableTarget.y._ = controllableTarget.y._ + ( -MoveSpeed * dt);
			}
		}
		
		if (MoveRight)
		{
			if (controllableTarget.x._ + (MoveSpeed * dt) + ((controllableTarget.getNaturalWidth() * controllableTarget.scaleX._) / 2) < this.pageWidth() + x1())
			{
				controllableTarget.x._ = controllableTarget.x._ + (MoveSpeed * dt);
			}
		}
		
		if (MoveLeft)
		{
			if (controllableTarget.x._ - (MoveSpeed * dt) - ((controllableTarget.getNaturalWidth() * controllableTarget.scaleX._) / 2) > x1())
			{
				controllableTarget.x._ = controllableTarget.x._ + ( -MoveSpeed * dt);
			}
		}
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