package page;

import components.GameEntity;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.input.Key;
import flambe.input.KeyboardEvent;
import flambe.input.MouseEvent;
import flambe.input.PointerEvent;
import hxcollision.math.Matrix;
import hxcollision.math.Vector;
import urgame.Global;

class GamePage_Car extends GamePage
{
	private static var ROT_SPEED : Float = 100;
	private static var MOVE_SPEED : Float = 100;
	
	private var car_ : GameEntity = null;
	private var turnRight_ : Bool = false;
	private var turnLeft_ : Bool = false;
	private var moveForward_ : Bool = false;
	private var moveBackward_ : Bool = false;
	
	public function new(l_parent:Entity) 
	{
		super(l_parent);
	}
		
	override public function onAdded() 
	{
		super.onAdded();
		
		{
			var e : Entity = new Entity();
			
			this.car_ = new GameEntity();
			e.add( this.car_ );
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "car" ) );
			e.add( image );
			
			image.x._ = x1() + this.pageWidth() / 2;
			image.y._ = y1() + this.pageHeight() / 2;
			this.entityLayer.addChild( e );
		}
	}
	
	override public function onUpdate(dt:Float) 
	{
		super.onUpdate(dt);
		
		if ( turnLeft_ ) {
			this.car_.sprite.rotation._ -= dt * ROT_SPEED;
		}
		
		if ( turnRight_ ) {
			this.car_.sprite.rotation._ += dt * ROT_SPEED;
		}
		
		if ( moveForward_ ) {
			var direction : Vector = new Vector( 1, 1 );
			
			var rotMat : Matrix = new Matrix();
			rotMat.rotate( Global.degToRad( this.car_.sprite.rotation._ ) );
			
			direction.transform( rotMat );
			
			this.car_.sprite.x._ += direction.x * dt * MOVE_SPEED;
			this.car_.sprite.y._ += direction.y * dt * MOVE_SPEED;
		}
		
		if ( moveBackward_ ) {
			
		}
	}
	
	override public function dispose() 
	{
		super.dispose();
	}
	
	override private function onKeyUp( e : KeyboardEvent ) : Void {
		if ( e.key == Key.A ) {
			turnLeft_ = false;
		}
		if ( e.key == Key.D ) {
			turnRight_ = false;
		}
		if ( e.key == Key.S ) {
			moveForward_ = false;
		}
		if ( e.key == Key.X ) {
			moveBackward_ = false;
		}
	}
	
	override private function onKeyDown( e : KeyboardEvent ) : Void {
		if ( e.key == Key.A ) {
			turnLeft_ = true;
		}
		if ( e.key == Key.D ) {
			turnRight_ = true;
		}
		if ( e.key == Key.S ) {
			moveForward_ = true;
		}
		if ( e.key == Key.X ) {
			moveBackward_ = true;
		}
	}
	
	override private function onMouseDown( e : PointerEvent ) : Void {
	}
	
	override private function onMouseUp( e : PointerEvent ) : Void {
	}
	
	override private function onMouseMove( e : PointerEvent ) : Void {
	}
}