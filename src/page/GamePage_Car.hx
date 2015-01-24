package page ;

import components.CollisionBox;
import components.GameEntity;
import flambe.Component;
import flambe.debug.FpsDisplay;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.Disposer;
import flambe.Entity;
import flambe.input.Key;
import flambe.input.KeyboardEvent;
import flambe.input.MouseEvent;
import flambe.input.PointerEvent;
import flambe.script.Repeat;
import hxcollision.CollisionData;
import hxcollision.math.Matrix;
import hxcollision.math.Vector;
import urgame.Game;
import urgame.Global;

class GamePage_Car extends GamePage
{
	private static var DRAW_DEBUG_BOX : Bool = true;
	private static var ROT_SPEED : Float = 100;
	private static var MOVE_SPEED : Float = 100;
	private static var MAX_SPEED : Float = 1000;

	private static var controllerStartX : Float = 100;
	private static var controllerStartY : Float = 100;
	private static var bound1 : Float = 223 + controllerStartX;
	private static var bound2 : Float = 433 + controllerStartY;
				
	private var car_ : GameEntity = null;
	private var cake_ : GameEntity = null;
	private var turnRight_ : Bool = false;
	private var turnLeft_ : Bool = false;
	private var moveForward_ : Bool = false;
	private var moveBackward_ : Bool = false;
	//private var turnVelocity_ : Float = 0;
	
	private var controller1 : ImageSprite = null;
	private var controller1Button : ImageSprite = null;
	
	private var circleButton_ : ImageSprite = null;
	//private var disposer_ : Disposer = null;
	
	public function new(l_parent:Entity) 
	{
		super(l_parent);
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		
		initRScreen();
		initLScreen();
		
		var fpsMeterEntity = new Entity().add(new TextSprite(this.font)).add(new FpsDisplay());
		this.overlay.addChild( fpsMeterEntity );
	}
	
	private function initLScreen() : Void {
		//this.disposer_ = new Disposer();
		//this.owner.add( this.disposer_ );
		
		{
			var e : Entity = new Entity();
			
			this.car_ = new GameEntity();
			e.add( this.car_ );
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "car" ) );
			e.add( image );
			image.x._ = x1() + this.pageWidth() / 2;
			image.y._ = y1() + this.pageHeight() / 2;
			
			var collisionBox : CollisionBox = new CollisionBox();
			//collisionBox.createRect( image.getNaturalWidth(), image.getNaturalHeight() );
			collisionBox.createCircle( image.getNaturalWidth() / 2 );
			e.add( collisionBox );
			
			if ( DRAW_DEBUG_BOX ) {
				var e1 : Entity = new Entity();
				e1.add( collisionBox.sprite );
				this.overlay.addChild( e1 );
			}
			
			this.entityLayer.addChild( e );
		}
		
		{
			var e : Entity = new Entity();
			
			this.cake_ = new GameEntity();
			e.add( this.cake_ );
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "cake" ) );
			e.add( image );
			image.x._ = x1() + Math.random() * this.pageWidth();
			image.y._ = x1() + Math.random() * this.pageHeight();
			
			var collisionBox : CollisionBox = new CollisionBox();
			collisionBox.createCircle( image.getNaturalWidth() / 2 );
			this.disposer.add( collisionBox.collide.connect( function( collisionBox : CollisionBox, data : CollisionData ) {
				if ( collisionBox.owner == null ) {
					return;
				}
				
				if ( this.car_.owner == null ) {
					return;
				}
				
				if ( collisionBox.owner == this.car_.owner ) {
					gameWin();
				}
			} ) );
			e.add( collisionBox );
			
			if ( DRAW_DEBUG_BOX ) {
				var e1 : Entity = new Entity();
				e1.add( collisionBox.sprite );
				this.overlay.addChild( e1 );
			}
			
			this.entityLayer.addChild( e );
		}
		
		addObstacle( 10 );
	}
	
	private function gameWin() : Void {
		Game.instance().gotoNextPage();
	}
	
	private function initRScreen() : Void {
		// circle button
		var startX : Float = 150;
		var startY : Float = 150;
		
		{
			{
				var e : Entity = new Entity();
				var circleButtonBase : ImageSprite = new ImageSprite( this.pack.getTexture( "circleButtonBase" ) );
				circleButtonBase.centerAnchor();
				e.add( circleButtonBase );
				this.entityLayer.addChild( e );
				circleButtonBase.x._ = x2() + startX;
				circleButtonBase.y._ = y2() + startY;
				
				var e : Entity = new Entity();
				circleButton_ = new ImageSprite( this.pack.getTexture( "circleButton" ) );
				e.add( circleButton_ );
				this.entityLayer.addChild( e );
				circleButton_.centerAnchor();
				circleButton_.x._ = circleButtonBase.x._;
				circleButton_.y._ = circleButtonBase.y._;
				
				function onRot( e : PointerEvent ) {
					var p1x : Float = circleButtonBase.x._;
					var p1y : Float = circleButtonBase.y._;
					var p2x : Float = e.viewX;
					var p2y : Float = e.viewY;
					var deltaX : Float = p2x - p1x;
					var deltaY : Float = p2y - p1y;
					var angleInDegrees : Float = ( Math.atan2(deltaY, deltaX) * 180 / Math.PI ) + 90;
					//trace( "angleInDegrees: " + angleInDegrees );
					this.car_.rotate = circleButton_.rotation._ = angleInDegrees;
				}
				
				this.disposer.add( circleButtonBase.pointerDown.connect( onRot ) );
				this.disposer.add( circleButtonBase.pointerMove.connect( onRot ) );
				this.disposer.add( circleButton_.pointerDown.connect( onRot ) );
				this.disposer.add( circleButton_.pointerMove.connect( onRot ) );
			}
		}
		
		// controller button
		{
			
			{
				this.entityLayer.addChild( new Entity().add( controller1 = new ImageSprite( this.pack.getTexture( "controller1" ) ) ) );
				controller1.centerAnchor();
				controller1.x._ = x2() + this.pageWidth() / 2 + controllerStartX;
				controller1.y._ = y2() + this.pageHeight() / 2 + controllerStartY;
			}
			
			{
				var text : TextSprite;
				this.overlay.addChild( new Entity().add( text = new TextSprite( this.font, "" ) ) );
				this.entityLayer.addChild( new Entity().add( controller1Button = new ImageSprite( this.pack.getTexture( "controller1_button" ) ) ) );
				//controller1Button.centerAnchor();
				controller1Button.x._ = 826.5 + controllerStartX;
				controller1Button.y._ = bound1 + ( bound2 - bound1 ) / 2;
				text.x._ = controller1Button.x._;
				text.y._ = controller1Button.y._ + 250;
				text.text = "meter: " + Global.floatToStringPrecision( ( controller1Button.y._ - bound1 ) / ( bound2 - bound1 ) * 8, 2 );
				
				var lastTouchPos : Vector = new Vector();
				var touched : Bool = false;
				
				this.disposer.add( controller1Button.pointerDown.connect( function( e : PointerEvent ) {
					var mx : Float = e.viewX;
					var my : Float = e.viewY;
					
					//trace( "checking : " + mx + ", " + my + ", " + controller1Button.x._ + ", " + controller1Button.y._ + ", " + controller1Button.getNaturalWidth() + ", " + controller1Button.getNaturalHeight() );
					if (	mx >= controller1Button.x._ &&
							mx <= ( controller1Button.x._ + controller1Button.getNaturalWidth() ) &&
							my >= controller1Button.y._ &&
							my <= ( controller1Button.y._ + controller1Button.getNaturalHeight() ) ) {
					//trace( "controller1Button pointer down" );
						//lastTouchPos.x = e.viewX;
						lastTouchPos.y = e.viewY;
						touched = true;
					}
				} ) );
				
				this.disposer.add( controller1Button.pointerUp.connect( function( e : PointerEvent ) {
					touched = false;
				} ) );
				
				this.disposer.add( controller1Button.pointerMove.connect( function( e : PointerEvent ) {
					if ( touched ) {
					//trace( "controller1Button pointerMove" );
						var diff : Vector = new Vector( 0, 0 );
						//diff.x = e.viewX - lastTouchPos.x;
						diff.y = e.viewY - lastTouchPos.y;
						//controller1Button.x._ += diff.x;
						controller1Button.y._ += diff.y;
						
						if ( controller1Button.y._ >= bound2 ) {
							controller1Button.y._ = bound2;
						}
						
						if ( controller1Button.y._ <= bound1 ) {
							controller1Button.y._ = bound1;
						}
						//lastTouchPos.x = e.viewX;
						lastTouchPos.y = e.viewY;
						
						text.text = "meter: " + Global.floatToStringPrecision( ( controller1Button.y._ - bound1 ) / ( bound2 - bound1 ) * 8, 2 );
						//trace( "controller1Button pointerUp : " + lastTouchPos.x + ", " + lastTouchPos.y );
					}
				} ) );
			}
		}
	}
	
	private function addObstacle( l_number : Int ) : Void {
		for ( i in 0 ... l_number ) {
			var e : Entity = new Entity();
			
			var ge : GameEntity = new GameEntity();
			e.add( ge );
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "tree1" ) );
			e.add( image );
			
			image.x._ = Math.random() * ( x1() + this.pageWidth() );
			image.y._ = Math.random() * ( y1() + this.pageHeight() );
			
			var collisionBox : CollisionBox = new CollisionBox();
			//collisionBox.createRect( image.getNaturalWidth(), image.getNaturalHeight() );
			collisionBox.createCircle( image.getNaturalWidth() / 2 );
			collisionBox.isStatic = true;
			this.disposer.add( collisionBox.collide.connect( function( other : CollisionBox, collisionData : CollisionData ) {
				if ( other.isStatic ) {
					return;
				}
				
				if ( other.owner != null ) {
					var ge : GameEntity = other.owner.get( GameEntity );
					if ( ge != null ) {
						ge.x -= collisionData.separation.x;
						ge.y -= collisionData.separation.y;
					}
				}
			} ));
			e.add( collisionBox );
			
			if ( DRAW_DEBUG_BOX ) {
				var e1 : Entity = new Entity();
				e1.add( collisionBox.sprite );
				this.overlay.addChild( e1 );
			}
			
			this.entityLayer.addChild( e );
		}
	}
	
	override public function onUpdate(dt:Float) 
	{
		super.onUpdate(dt);
		
		//if ( turnLeft_ ) {
			//this.car_.rotate -= dt * ROT_SPEED;
		//}
		
		//if ( turnRight_ ) {
			//this.car_.rotate += dt * ROT_SPEED;
		//}
		
		//if ( moveForward_ || moveBackward_ ) {
		{
			var pivot : Vector = new Vector();
			var rad : Float = Global.degToRad( this.car_.sprite.rotation._ - 90 );
			var direction : Vector = new Vector(Math.cos(rad), Math.sin(rad));
			var tmp : Float = ( 4 - ( ( controller1Button.y._ - bound1 ) / ( bound2 - bound1 ) * 8 ) );
			this.car_.sprite.x._ += direction.x * dt * MOVE_SPEED * tmp;
			this.car_.sprite.y._ += direction.y * dt * MOVE_SPEED * tmp;
			
			var x1 : Float = x1();
			var y1 : Float = y1();
			var x2 : Float = x1 + this.pageWidth();
			var y2 : Float = y1 + this.pageHeight();
			
			if ( this.car_.sprite.x._ < x1 ) {
				this.car_.sprite.x._ = x1;
			}
			if ( this.car_.sprite.y._ < y1 ) {
				this.car_.sprite.y._ = y1;
			}
			if ( ( this.car_.sprite.x._ + this.car_.sprite.getNaturalWidth() * 0.25 ) >= x2 ) {
				this.car_.sprite.x._ = x2 - this.car_.sprite.getNaturalWidth() * 0.25;
			}
			if ( ( this.car_.sprite.y._ + ( this.car_.sprite.getNaturalHeight() * 0.25 ) ) >= y2 ) {
				this.car_.sprite.y._ = y2 - this.car_.sprite.getNaturalHeight() * 0.25;
			}
		}
		
			//this.car_.sprite.x._ += direction.x * dt * MOVE_SPEED * ( moveBackward_? -1 : 1 );
			//this.car_.sprite.y._ += direction.y * dt * MOVE_SPEED * ( moveBackward_? -1 : 1 );
			
			//this.car_.sprite.x._ += direction.x * dt * ( circleButton_.rotation._ / 300 ) * MOVE_SPEED;
			//this.car_.sprite.y._ += direction.y * dt * ( circleButton_.rotation._ / 300 ) * MOVE_SPEED;
			
		//}
	}
	public function rotateVector( vector : Vector, radians : Float) : Vector {
		var ca : Float = Math.cos(radians);
		var sa : Float = Math.sin(radians);
		var rx : Float = vector.x * ca - vector.y * sa;
		var ry : Float = vector.x * sa + vector.y * ca;
		vector.x = rx;
		vector.y = ry;
		
		return vector;
	}
	
	override public function dispose() : Void
	{
		super.dispose();
	}
	
	override private function onKeyUp( e : KeyboardEvent ) : Void {
			trace( "onKeyUp" );
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
			trace( "onKeyDown" );
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