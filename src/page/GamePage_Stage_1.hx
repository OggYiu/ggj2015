package page ;
import flambe.animation.Ease;
import flambe.asset.AssetPack;
import flambe.Component;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.display.Texture;
import flambe.Disposer;
import flambe.Entity;
import flambe.input.KeyboardEvent;
import flambe.input.MouseEvent;
import flambe.input.PointerEvent;
import flambe.math.Rectangle;
import flambe.script.AnimateTo;
import flambe.script.Parallel;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.System;
import flambe.util.PackageLog;
import gui.GUI_Button;
import urgame.Game;
import urgame.Kernel;
import urgame.RectSprite;

/**
 * ...
 * @author ragbit
 */
class GamePage_Stage_1 extends GamePage
{
	private var MoveSpeed : Float = 350;
	
	private var won_ : Bool = false;
	private var controllableTarget : ImageSprite = null;
	private var backgroupGalaxy : ImageSprite = null;
	private var backgroupCubes : ImageSprite = null;
	private var blackhole : ImageSprite = null;
	private var blackholeEntity : Entity = null;
	private var controllableTargetEntity : Entity = null;
	
	private var backgroupBrick1 : ImageSprite = null;
	private var backgroupBrick2 : ImageSprite = null;
	private var backgroupBrick3 : ImageSprite = null;
	
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
		
		var backgroupRight = new ImageSprite(pack.getTexture("2/2_right"));
		backgroupRight.centerAnchor();
		backgroupRight.x._ = x2() + backgroupRight.getNaturalWidth() / 2;
		backgroupRight.y._ = y2() + backgroupRight.getNaturalHeight() / 2;
		this.entityLayer.addChild(new Entity().add(backgroupRight));
		
		backgroupGalaxy = new ImageSprite(pack.getTexture("2/2_galaxy"));
		backgroupGalaxy.centerAnchor();
		backgroupGalaxy.x._ = x1() + backgroupGalaxy.getNaturalWidth() / 2;
		backgroupGalaxy.y._ = y1() + backgroupGalaxy.getNaturalHeight() / 2 + 50;
		this.entityLayer.addChild(new Entity().add(backgroupGalaxy));
		
		backgroupCubes = new ImageSprite(pack.getTexture("2/2_cubes"));
		backgroupCubes.x._ = x1();
		backgroupCubes.y._ = y1();
		this.entityLayer.addChild(new Entity().add(backgroupCubes));
		
		backgroupBrick1 = new ImageSprite(pack.getTexture("2/2_brick1"));
		backgroupBrick1.centerAnchor();
		backgroupBrick1.x._ = x1() + 100;
		backgroupBrick1.y._ = y1() + 100;
		this.entityLayer.addChild(new Entity().add(backgroupBrick1));
		
		
		blackholeEntity = new Entity();
		
		blackhole = new ImageSprite(pack.getTexture("2/2_hole"));
		blackhole.centerAnchor();
		blackhole.x._ = x1() + 270;
		blackhole.y._ = y1() + 410;
		blackhole.setScaleXY(0.8, 0.8);
		blackhole.alpha._ = 0.9;
		
		blackholeEntity.add(blackhole);
		var script : Script = new Script();
			script.run(
				new Repeat(
				new Sequence(
				[
					new Parallel( [
					new AnimateTo( blackhole.scaleX, blackhole.scaleX._ * 1.01, 0.8, Ease.circIn ),
					new AnimateTo( blackhole.scaleY, blackhole.scaleY._ * 1.01, 0.8, Ease.circIn )]),
					
					new Parallel( [
					new AnimateTo( blackhole.scaleX, blackhole.scaleX._ / 1.01, 0.8, Ease.circIn ),
					new AnimateTo( blackhole.scaleY, blackhole.scaleY._ / 1.01, 0.8, Ease.circIn )])
				])
				));
		blackholeEntity.add(script);
		this.entityLayer.addChild(blackholeEntity);
		
		initControllableTarget("2/2_egggface", 300, 200);
		
		createButton("2/2_left_button2", "2/2_button_black", false, 295, 245, buttonClickRotateClockwise);
		
		createButton("2/2_left_button1", "2/2_button_black", false, 205, 210, buttonClickScale);
		
		createButton("2/2_left_button3", "2/2_button_black", false, 290, 375, buttonClickMoveDown);
		
		createButton("2/2_left_button4", "2/2_button_black", false, 365, 442, buttonClickConfirm);
		
		
		/*
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
		
		createButton("gui/start-normal", "gui/start-click", false, 200, 600, buttonClickConfirm);
		*/
	}
	
	private function initControllableTarget(imagePath : String, x : Float, y : Float)
	{
		controllableTargetEntity = new Entity();
		controllableTarget = new ImageSprite(pack.getTexture(imagePath));
		controllableTarget.centerAnchor();
		//controllableTarget.x._ = x1() + x + ((Math.random() - 0.5) * 100);
		
		controllableTarget.x._ = blackhole.x._;
		controllableTarget.y._ = y1() + y + ((Math.random() - 0.5) * 100);		
		
		controllableTarget.setScaleXY(0.5, 0.5);		
		controllableTarget.setScaleXY((Math.random() - 0.5) + 1, (Math.random() - 0.5) + 1);
		controllableTarget.setRotation(Math.random() * 360);
		controllableTargetEntity.add(controllableTarget);
		this.entityLayer.addChild(controllableTargetEntity);
	}
	
	private function createButton(normalPath : String, clickPath : String, leftScreen : Bool, x : Float, y : Float, func : String -> Void)
	{
		var normalTexture : Texture = pack.getTexture(normalPath);
		var clickTexture : Texture = pack.getTexture(clickPath);		
		var button = new GUI_Button(normalTexture, clickTexture, func);
		button.centerAnchor();
		button.setRotation(button.rotation._ - 5);
		
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
	
	private function buttonClickConfirm(parameter : String)
	{
		if (controllableTarget != null)
		{
			if (parameter == GUI_Button.DOWN)
			{	
				var a : Rectangle = Sprite.getBounds(blackholeEntity, null);
				
				/*
				var b = new RectSprite(Std.int(a.width), Std.int(a.height), 0xFF0000);
				b.centerAnchor();
				b.x._ = a.centerX;
				b.y._ = a.centerY;
				b.alpha._ = 0.5;
				this.entityLayer.addChild(new Entity().add(b));
				*/
				
				var c : Rectangle = Sprite.getBounds(controllableTargetEntity, null);
				
				/*
				var d = new RectSprite(Std.int(c.width), Std.int(c.height), 0xFF0000);
				d.centerAnchor();
				d.x._ = c.centerX;
				d.y._ = c.centerY;
				d.alpha._ = 0.5;
				this.entityLayer.addChild(new Entity().add(d));
				*/
				
				if (c.x >= a.x && c.x + c.width <= a.x + a.width &&
					c.y >= a.y && c.y + c.height <= a.y + a.height)
				{
					if ( !won_ ) {
						Game.instance().gotoNextPage();
						won_ = true;
					}
				}
			}
		}
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
	
	private function buttonClickScale(parameter : String)
	{
		if (controllableTarget != null)
		{
			if (parameter == GUI_Button.DOWN)
			{
				ScaleUpX = true;
				ScaleUpY = true;
			}
			else
			{
				ScaleUpX = false;
				ScaleUpY = false;
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
			if (controllableTarget.scaleX._ > 2)
			{
				controllableTarget.setScaleXY(0.2, 0.2);
			}
			
			if (controllableTarget.scaleX._ < 10
			&& (controllableTarget.x._ + ((controllableTarget.getNaturalWidth() * (controllableTarget.scaleX._ + (2 * dt))) / 2) < this.pageWidth() + x1())
			&& (controllableTarget.x._ - ((controllableTarget.getNaturalWidth() * (controllableTarget.scaleX._ + (2 * dt))) / 2) > x1()))
			{
				controllableTarget.setScaleXY(controllableTarget.scaleX._ + (2 * dt), controllableTarget.scaleY._);
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
			if (controllableTarget.scaleY._ > 2)
			{
				controllableTarget.setScaleXY(0.2, 0.2);
			}
			
			if (controllableTarget.scaleY._ < 10			
			&& (controllableTarget.y._ + ((controllableTarget.getNaturalHeight() * (controllableTarget.scaleY._ + (2 * dt))) / 2) < this.pageHeight() + y1())
			&& (controllableTarget.y._ - ((controllableTarget.getNaturalHeight() * (controllableTarget.scaleY._ + (2 * dt))) / 2) > y1()))
			{
				controllableTarget.setScaleXY(controllableTarget.scaleX._, controllableTarget.scaleY._ + (2 * dt));
			}
		}
		
		if (ScaleDownY)
		{
			if (controllableTarget.scaleY._ > 0.3)
			{
				controllableTarget.setScaleXY(controllableTarget.scaleX._, controllableTarget.scaleY._ + ( -5 * dt));
			}
		}
		
		if (MoveDown)
		{
			if (controllableTarget.y._ + ((controllableTarget.getNaturalHeight() * controllableTarget.scaleY._) / 2) >= (this.pageHeight() + y1()) * 0.97)
			{
				controllableTarget.y._ = y1() + ((controllableTarget.getNaturalHeight() * controllableTarget.scaleY._) / 2) - 50;
			}
			
			if (controllableTarget.y._ + (MoveSpeed * dt) + ((controllableTarget.getNaturalHeight() * controllableTarget.scaleY._) / 2) < this.pageHeight() + y1())
			{
				controllableTarget.y._ = controllableTarget.y._ + (MoveSpeed * dt);
			}
		}
		
		if (MoveUp)
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
		
		backgroupGalaxy.setRotation(backgroupGalaxy.rotation._ + (10 * dt));
		
		if (backgroupBrick1.x._ < pageWidth() + 70)
		{
			backgroupBrick1.x._ = backgroupBrick1.x._ + (50 * dt);
			backgroupBrick1.y._ = backgroupBrick1.y._ + (10 * dt);
		}
		else
		{
			backgroupBrick1.x._ = -15;
			backgroupBrick1.y._ = y1() + 100;
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