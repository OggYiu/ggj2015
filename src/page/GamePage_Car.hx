package page ;

import components.CollisionBox;
import components.GameEntity;
import flambe.animation.Ease;
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
import flambe.script.CallFunction;
import flambe.script.Repeat;
import format.tools.Image;
import hxcollision.CollisionData;
import hxcollision.math.Matrix;
import hxcollision.math.Vector;
import urgame.Game;
import urgame.Global;

import flambe.script.AnimateTo;
import flambe.script.Parallel;
import flambe.script.Script;
import flambe.script.Sequence;

class GamePage_Car extends GamePage
{
	private var disappearBackground : ImageSprite = null;
	
	private var disappeared : Bool = false;
	
	private static var DRAW_DEBUG_BOX : Bool = false;
	private static var ROT_SPEED : Float = 100;
	private static var MOVE_SPEED : Float = 100;
	private static var MAX_SPEED : Float = 1000;

	//private static var controllerStartX : Float = 100;
	//private static var controllerStartY : Float = 100;
	private static var bound1 : Float = 233;
	private static var bound2 : Float = 373;
				
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
	private var countDown_ : Float  = 0;
	private var won_ : Bool = false;
	private var gameStarted_ : Bool = false;
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
		
		//var fpsMeterEntity = new Entity().add(new TextSprite(this.font)).add(new FpsDisplay());
		//this.overlay.addChild( fpsMeterEntity );
	}
	
	private function initLScreen() : Void {
		//this.disposer_ = new Disposer();
		//this.owner.add( this.disposer_ );
		
		{
			var e : Entity = new Entity();
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "3/3_background" ) );
			e.add( image );
			
			image.x._ = x1();
			image.y._ = y1();
			
			this.entityLayer.addChild( e );
			
		}
		
		{
			var e : Entity = new Entity();
			
			this.car_ = new GameEntity();
			e.add( this.car_ );
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "3/3_car" ) );
			e.add( image );
			image.x._ = x1() + this.pageWidth() - image.getNaturalWidth() * 2.0;
			image.y._ = y1() + this.pageHeight() - image.getNaturalHeight() * 2.0;
			
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
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "3/bloodHead" ) );
			e.add( image );
			image.x._ = x1() + image.getNaturalWidth() + Math.random() * ( this.pageWidth() - image.getNaturalWidth() );
			image.y._ = y1() + image.getNaturalHeight() + Math.random() * ( this.pageHeight() - image.getNaturalHeight() );
			
			{
				var e1 : Entity = new Entity();
				var imageBody : ImageSprite = new ImageSprite( this.pack.getTexture( "3/3_blood" ) );
				e1.add( imageBody );
				imageBody.x._ = image.x._ - 50;
				imageBody.y._ = image.y._ - 76;
				this.entityLayer.addChild( e1 );
			}
			
			var collisionBox : CollisionBox = new CollisionBox();
			collisionBox.createCircle( image.getNaturalWidth() / 2 );
			this.disposer.add( collisionBox.collide.connect( function( collisionBox : CollisionBox, data : CollisionData ) {
				if ( won_ ) {
					return;
				}
				
				if ( !gameStarted_ ) {
					return;
				}
				
				if ( collisionBox.owner == null ) {
					return;
				}
				
				if ( countDown_ <= 1 ) {
					return;
				}
				
				if ( this.car_.owner == null ) {
					return;
				}
				
				if ( collisionBox.owner == this.car_.owner ) {
					//trace( "coll" );
					gameWin();
				}
			} ) );
			e.add( collisionBox );
			
			var script : Script = new Script();
			script.run(
				new Repeat(
				new Sequence(
				[
					new Parallel( [
					new AnimateTo( image.scaleX, image.scaleX._ * 1.03, 0.8, Ease.circIn ),
					new AnimateTo( image.scaleY, image.scaleY._ * 1.03, 0.8, Ease.circIn )]),
					
					new Parallel( [
					new AnimateTo( image.scaleX, image.scaleX._ / 1.03, 0.8, Ease.circIn ),
					new AnimateTo( image.scaleY, image.scaleY._ / 1.03, 0.8, Ease.circIn )])
				])
				));
			e.add(script);
				
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
		if ( !won_ ) {
			Game.instance().gotoNextPage();	
			won_ = true;
		}
	}
	
	private function initRScreen() : Void 
	{	
		var background = new ImageSprite(pack.getTexture("3/3_right_background"));
		background.x._ = x2();
		background.y._ = y2();
		this.entityLayer.addChild(new Entity().add(background));
		
		// circle button
		var startX : Float = 165;
		var startY : Float = 300;
		
		{
			{
				var e : Entity = new Entity();
				
				/*
				var circleButtonBase : ImageSprite = new ImageSprite( this.pack.getTexture( "circleButtonBase" ) );
				circleButtonBase.centerAnchor();
				e.add( circleButtonBase );
				this.entityLayer.addChild( e );
				circleButtonBase.x._ = x2() + startX;
				circleButtonBase.y._ = y2() + startY;
				*/
				
				
				var e : Entity = new Entity();
				circleButton_ = new ImageSprite( this.pack.getTexture( "3/3_right_knob" ) );
				e.add( circleButton_ );
				this.entityLayer.addChild( e );
				circleButton_.centerAnchor();
				circleButton_.x._ = x2() + startX;
				circleButton_.y._ = y2() + startY;
				
				function onRot( e : PointerEvent ) {
					var p1x : Float = x2() + startX;
					var p1y : Float = y2() + startY;
					var p2x : Float = e.viewX;
					var p2y : Float = e.viewY;
					var deltaX : Float = p2x - p1x;
					var deltaY : Float = p2y - p1y;
					var angleInDegrees : Float = ( Math.atan2(deltaY, deltaX) * 180 / Math.PI ) + 90;
					//trace( "angleInDegrees: " + angleInDegrees );
					this.car_.rotate = circleButton_.rotation._ = angleInDegrees;
				}
				
				//this.disposer.add( circleButtonBase.pointerDown.connect( onRot ) );
				//this.disposer.add( circleButtonBase.pointerMove.connect( onRot ) );
				this.disposer.add( circleButton_.pointerDown.connect( onRot ) );
				this.disposer.add( circleButton_.pointerMove.connect( onRot ) );
			}
		}
		
		// controller button
		{
			/*
			{
				this.entityLayer.addChild( new Entity().add( controller1 = new ImageSprite( this.pack.getTexture( "controller1" ) ) ) );
				controller1.centerAnchor();
				controller1.x._ = x2() + this.pageWidth() / 2 + controllerStartX;
				controller1.y._ = y2() + this.pageHeight() / 2 + controllerStartY;
			}
			*/
			
			{
				var text : TextSprite;
				this.overlay.addChild( new Entity().add( text = new TextSprite( this.font, "" ) ) );
				this.entityLayer.addChild( new Entity().add( controller1Button = new ImageSprite( this.pack.getTexture( "3/3_right_roller" ) ) ) );
				//controller1Button.centerAnchor();
				controller1Button.x._ = 896.5;
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
		
		disappearBackground = new ImageSprite(pack.getTexture("3/3_right_left"));
		disappearBackground.x._ = x2();
		disappearBackground.y._ = y2();
		this.entityLayer.addChild(new Entity().add(disappearBackground));
	}
	
	private function addObstacle( l_number : Int ) : Void {
		var names : Array<String> = [	"3/soilderHead",
										"3/tigerHead" ];
		var bodyNames : Array<String> = [	"3/3_soilder_withsword",
											"3/3_tiger" ];
		for ( i in 0 ... l_number ) {
			var e : Entity = new Entity();
			
			var ge : GameEntity = new GameEntity();
			e.add( ge );
			
			var randIndex : Int = Math.round( Math.random() * ( names.length - 1 ) );
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( names[randIndex] ) );
			e.add( image );
			
			image.x._ = x1() + image.getNaturalWidth() + Math.random() * ( this.pageWidth() - image.getNaturalWidth() );
			image.y._ = y1() + image.getNaturalHeight() + Math.random() * ( this.pageHeight() - image.getNaturalHeight() );
			
			{
				var e1 : Entity = new Entity();
				var imageBody : ImageSprite = new ImageSprite( this.pack.getTexture( bodyNames[randIndex] ) );
				e1.add( imageBody );
				if ( randIndex == 0 ) {
					imageBody.x._ = image.x._ - 80;
					imageBody.y._ = image.y._ - 120;
				} else if ( randIndex == 1 ) {
					imageBody.x._ = image.x._ - 30;
					imageBody.y._ = image.y._ - 30;
				}
				this.entityLayer.addChild( e1 );
			}
			var collisionBox : CollisionBox = new CollisionBox();
			//collisionBox.createRect( image.getNaturalWidth(), image.getNaturalHeight() );
			collisionBox.createCircle( image.getNaturalWidth() / 2 );
			collisionBox.isStatic = true;
			this.disposer.add( collisionBox.collide.connect( function( other : CollisionBox, collisionData : CollisionData ) {
				if ( won_ ) {
					return;
				}
				
				if ( !gameStarted_ ) {
					return;
				}
				
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
		gameStarted_ = true;
		
		countDown_ += dt;
		super.onUpdate(dt);
		
		if (countDown_ > 2 && disappeared == false)
		{	
			var script : Script = new Script();
			script.run(				
				new Sequence(
				[
					//disappearBackground.alpha.animateTo(0, 0.5),
					
					new AnimateTo( disappearBackground.alpha, 0, 0.5, Ease.circIn ),
					new CallFunction(function()
					{
						disappearBackground.owner.dispose();
					})
				]));
			disappearBackground.owner.add(script);
			disappeared = true;
		}
		
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