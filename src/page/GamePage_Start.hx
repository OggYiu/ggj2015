package page ;

import components.GameEntity;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.input.KeyboardEvent;
import flambe.input.MouseEvent;
import flambe.input.PointerEvent;
import urgame.Global;

class GamePage_Start extends GamePage
{
	public function new(l_parent:Entity) 
	{
		super(l_parent);
	}
		
	override public function onAdded() 
	{
		super.onAdded();
		
		var backgroupRight = new ImageSprite(pack.getTexture("1/1_right"));
		backgroupRight.centerAnchor();
		backgroupRight.x._ = x2() + backgroupRight.getNaturalWidth() / 2;
		backgroupRight.y._ = y2() + backgroupRight.getNaturalHeight() / 2;
		this.entityLayer.addChild(new Entity().add(backgroupRight));
		
		var backgroupLeft = new ImageSprite(pack.getTexture("1/1_left"));
		backgroupLeft.x._ = x1();
		backgroupLeft.y._ = y1();
		this.entityLayer.addChild(new Entity().add(backgroupLeft));
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