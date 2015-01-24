package page;
import flambe.asset.AssetPack;
import flambe.Component;
import flambe.display.Font;
import flambe.Disposer;
import flambe.Entity;
import flambe.input.KeyboardEvent;
import flambe.input.MouseEvent;
import flambe.input.PointerEvent;
import flambe.System;
import urgame.Game;
import urgame.Kernel;

/**
 * ...
 * @author ragbit
 */
class GamePage_Stage_1 extends GamePage
{
	public function new( l_parent : Entity ) 
	{
		super( l_parent );
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		
		
		Float a = Global.getPage1X();
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