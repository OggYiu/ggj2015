package page;

import components.CollisionBox;
import components.GameEntity;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.input.Key;
import flambe.input.KeyboardEvent;
import flambe.input.MouseEvent;
import flambe.input.PointerEvent;
import hxcollision.math.Vector;
import urgame.Global;
import urgame.Projectile;

class GamePage_Battle extends GamePage
{
	private static var SPEED : Float = 1000;
	private var player1( default, default ) : GameEntity = null;
	private var player2( default, default ) : GameEntity = null;
	private var moveKeyUp1_ : Bool = false;
	private var moveKeyDown1_ : Bool = false;
	private var moveKeyUp2_ : Bool = false;
	private var moveKeyDown2_ : Bool = false;
	private var player1Hp_ : Int = 10;
	private var player2Hp_ : Int = 10;
	
	public function new(l_parent:Entity) 
	{
		super(l_parent);
	}
		
	override public function onAdded() 
	{
		super.onAdded();
		
		{
			var e : Entity = new Entity();

			
			var collisionBox : CollisionBox = new CollisionBox();
			collisionBox.createCircle( 0, 0, ( image.getNaturalWidth() / 5 ) * 2 );
			e.add( collisionBox );
			
			{
				var e1 : Entity = new Entity();
				e1.add( collisionBox.sprite );
				this.entityLayer.addChild( e1 );
			}
		}
		
		{
			this.player1 = new GameEntity();
			
			var e : Entity = new Entity();
			e.add( ( this.player1 = new GameEntity() ));
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "battle_player1" ) );
			e.add( image );
			
			this.player1.x = x1() + image.getNaturalWidth() / 2;
			this.player1.y = y1() + this.pageHeight() / 2;
			this.entityLayer.addChild( e );
			
			var collisionBox : CollisionBox = new CollisionBox();
			//collisionBox.createRect( 0, 0, image.getNaturalWidth(), image.getNaturalHeight() );
			collisionBox.createCircle( 0, 0, ( image.getNaturalWidth() / 5 ) * 2 );
			collisionBox.offsetX = -image.getNaturalWidth() / 2;
			collisionBox.offsetY = -image.getNaturalHeight() / 2;
			e.add( collisionBox );
			
			{
				var e1 : Entity = new Entity();
				e1.add( collisionBox.sprite );
				this.entityLayer.addChild( e1 );
			}
		}
		
		{
			this.player2 = new GameEntity();
			
			var e : Entity = new Entity();
			e.add( ( this.player2 = new GameEntity() ));
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "battle_player2" ) );
			e.add( image );
			
			this.player2.x = x2() + this.pageWidth() - image.getNaturalWidth() / 2;
			//this.player2.x = x2();	
			this.player2.y = y2() + this.pageHeight() / 2;
			this.entityLayer.addChild( e );
			
			
			var collisionBox : CollisionBox = new CollisionBox();
			//collisionBox.createRect( 0, 0, image.getNaturalWidth(), image.getNaturalHeight() );
			collisionBox.createCircle( 0, 0, ( image.getNaturalWidth() / 5 ) * 2 );
			collisionBox.offsetX = -image.getNaturalWidth() * 0.25;
			collisionBox.offsetY = -image.getNaturalHeight() / 2;
			e.add( collisionBox );
			
			{
				var e1 : Entity = new Entity();
				e1.add( collisionBox.sprite );
				this.entityLayer.addChild( e1 );
			}
		}
	}
	
	override public function onUpdate(dt:Float) 
	{
		super.onUpdate(dt);
		
		if ( moveKeyUp1_ ) {
			player1.y -= dt * SPEED;
		}
		if ( moveKeyDown1_ ) {
			player1.y += dt * SPEED;
		}
		
		if ( moveKeyUp2_ ) {
			player2.y -= dt * SPEED;
		}
		if ( moveKeyDown2_ ) {
			player2.y += dt * SPEED;
		}
	}
	
	override public function dispose() 
	{
		super.dispose();
	}
	
	override private function onKeyUp( e : KeyboardEvent ) : Void {
		if ( e.key == Key.A ) {
			moveKeyUp1_ = false;
		}
		if ( e.key == Key.Z ) {
			moveKeyDown1_ = false;
		}
		if ( e.key == Key.J ) {
			moveKeyUp2_ = false;
		}
		if ( e.key == Key.M ) {
			moveKeyDown2_ = false;
		}
	}
	
	override private function onKeyDown( e : KeyboardEvent ) : Void {
		if ( e.key == Key.A ) {
			moveKeyUp1_ = true;
		}
		if ( e.key == Key.Z ) {
			moveKeyDown1_ = true;
		}
		if ( e.key == Key.X ) {
			var e : Entity = new Entity();
			
			var projectile : Projectile = new Projectile();
			e.add( projectile );
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "ball1" ) );
			e.add( image );
			image.x._ = player1.x + image.getNaturalWidth();
			image.y._ = player1.y;
			image.x.animateTo( this.screenWidth + image.getNaturalWidth(), 2 );
			
			var collisionBox : CollisionBox = new CollisionBox();
			collisionBox.createCircle( 0, 0, image.getNaturalHeight() / 2 );
			//collisionBox.createRect( 0, 0, image.getNaturalWidth(), image.getNaturalHeight() / 2 );
			collisionBox.offsetX = image.getNaturalWidth() / 4;
			collisionBox.offsetY = -image.getNaturalHeight() / 2;
			collisionBox.collide.connect( function( box : CollisionBox ) {
				if ( box.owner != null ) {
					if ( box.owner.get( GameEntity ) == this.player2 ) {
						--player2Hp_;
						collisionBox.owner.dispose();
						if ( player2Hp_ <= 0 ) {
							gameEnd( this.player1 );
						}
					}
				}
			} );
			e.add( collisionBox );
			
			this.pack.getSound( "audio/lazer_shot" ).play();
			this.entityLayer.addChild( e );
			
			{
				var e1 : Entity = new Entity();
				e1.add( collisionBox.sprite );
				this.entityLayer.addChild( e1 );
			}
		}
		if ( e.key == Key.J ) {
			moveKeyUp2_ = true;
		}
		if ( e.key == Key.M ) {
			moveKeyDown2_ = true;
		}
		if ( e.key == Key.K ) {
			var e : Entity = new Entity();
			
			var projectile : Projectile = new Projectile();
			e.add( projectile );
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "ball2" ) );
			e.add( image );
			image.x._ = player2.x - image.getNaturalWidth();
			image.y._ = player2.y;
			image.x.animateTo( -image.getNaturalWidth(), 2 );
			
			var collisionBox : CollisionBox = new CollisionBox();
			collisionBox.createCircle( 0, 0, image.getNaturalHeight() / 2 );
			//collisionBox.createRect( 0, 0, image.getNaturalWidth(), image.getNaturalHeight() / 2 );
			collisionBox.offsetX = -image.getNaturalWidth() / 2;
			collisionBox.offsetY = -image.getNaturalHeight() / 2;
			collisionBox.collide.connect( function( box : CollisionBox ) {
				if ( box.owner != null ) {
					if ( box.owner.get( GameEntity ) == this.player1 ) {
						--player1Hp_;
						collisionBox.owner.dispose();
						if ( player1Hp_ <= 0 ) {
							gameEnd( this.player2 );
						}
					}
				}
			} );
			e.add( collisionBox );
			
			this.pack.getSound( "audio/lazer_shot" ).play();
			this.entityLayer.addChild( e );
			
			{
				var e1 : Entity = new Entity();
				e1.add( collisionBox.sprite );
				this.entityLayer.addChild( e1 );
			}
		}
	}
	
	private function gameEnd( l_player : GameEntity ) : Void {
		
	}
}