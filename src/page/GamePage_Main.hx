package page;

import flambe.Component;
import flambe.display.FillSprite;
import flambe.Entity;
import flambe.input.KeyboardEvent;
import flambe.input.MouseEvent;
import flambe.input.PointerEvent;
import urgame.Global;

class GamePage_Main extends GamePage
{
	public function new(l_parent:Entity) 
	{
		super(l_parent);
		
		Console.log( "game page main" );
	}
		
	override public function onAdded() 
	{
		super.onAdded();
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