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

class GamePage_Main extends GamePage
{
	public function new(l_parent:Entity) 
	{
		super(l_parent);
		
		//Console.log( "game page main" );
	}
		
	override public function onAdded() 
	{
		super.onAdded();
		
		{
			var e : Entity = new Entity();
			var text : TextSprite = new TextSprite( this.font, "Game Page Main" );
			e.add( text );
			
			this.entityLayer.addChild( e );
		}
		
		{
			//Console.log( "game page main onadd" );
			
			var e : Entity = new Entity();
			var plane : ImageSprite = new ImageSprite( this.pack.getTexture( "plane" ) );
			e.add( plane );
			
			var ge1 : GameEntity = new GameEntity();
			e.add( ge1 );
			
			plane.x.animateTo( 200, 10 );
			plane.y.animateTo( 200, 10 );
			
			this.entityLayer.addChild( e );
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
		//Console.log( "on key up" );
	}
	
	override private function onKeyDown( e : KeyboardEvent ) : Void {
		//Console.log( "on key dow" );
	}
	
	override private function onMouseDown( e : PointerEvent ) : Void {
		//Console.log( "on mouse down" );
	}
	
	override private function onMouseUp( e : PointerEvent ) : Void {
		//Console.log( "on mouse up" );
	}
	
	override private function onMouseMove( e : PointerEvent ) : Void {
		//Console.log( "on mouse move" );
	}
}