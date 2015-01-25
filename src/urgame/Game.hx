package urgame ;
import components.CollisionBox;
import components.GameEntity;
import flambe.animation.Ease;
import flambe.asset.AssetPack;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.display.Texture;
import flambe.Entity;
import flambe.input.Key;
import flambe.input.KeyboardEvent;
import flambe.input.PointerEvent;
import flambe.math.Point;
import flambe.scene.Scene;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Parallel;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.script.Shake;
import flambe.swf.Library;
import flambe.swf.MoviePlayer;
import flambe.System;
import gui.GUI_Button;
import hxcollision.Collision;
import hxcollision.CollisionData;
import hxcollision.math.Vector;
import hxcollision.shapes.Circle;
import hxcollision.shapes.Polygon;
import page.Template_GamePage;
import page.GamePage_Main;
import page.GamePage_Stage_1;
import page.GamePage_Battle;
import page.GamePage_Car;

/**
 * ...
 * @author ragbit
 */
class Game
{
	private var pageIndex_ : Int = -1;
	private var pages_ : Array < (Void -> Entity) > = null;
	private var transitToLeft_ : Bool = false;

	public function new() {
	}
	
	public function create() : Void {
		pages_ = [page_title, page_stage_1, page_car, page_battle, page_end];
		gotoNextPage();
	}
	
	public function gotoPreviousPage() : Void {
		--pageIndex_;
		if ( pageIndex_ < 0 ) {
			pageIndex_ = pages_.length -1;
		} else if ( pageIndex_ >= pages_.length ) {
			pageIndex_ = 0;
		}
		transitToLeft_ = true;
		gotoPage( pageIndex_ );
	}
	
	public function gotoNextPage() : Void {
		++pageIndex_;
		if ( pageIndex_ < 0 ) {
			pageIndex_ = pages_.length -1;
		} else if ( pageIndex_ >= pages_.length ) {
			pageIndex_ = 0;
		}
		transitToLeft_ = false;
		gotoPage( pageIndex_ );
	}
	
	private function gotoPage( demoIndex : Int ) : Void {
		//Kernel.instance().pack.getSound( "audio/cheers" ).play();
		Kernel.instance().goto( pages_[demoIndex](), transitToLeft_ );
	}
	
	public function page_end() : Entity {
		var scene : Entity = new Entity().add( new Scene() );
		
		{
			var e : Entity = new Entity();
			var image : ImageSprite = new ImageSprite( Kernel.instance().pack.getTexture( "final" ) );
			image.centerAnchor();
			image.x._ = System.stage.width / 2;
			image.y._ = System.stage.height / 2;
			e.add( image );
			
			scene.addChild( e );
		}
		
		return scene;
	}
	
	public function page_car() : Entity {
		var scene : Entity = new Entity().add( new Scene() );
		
		{
			var e : Entity = new Entity();
			var page : GamePage_Car = new GamePage_Car( e );
			e.add( page );
			
			scene.addChild( e );
		}
		
		return scene;
	}
	
	public function page_battle() : Entity {
		var scene : Entity = new Entity().add( new Scene() );
		
		{
			var e : Entity = new Entity();
			var page : GamePage_Battle = new GamePage_Battle( e );
			e.add( page );
			
			scene.addChild( e );
		}
		
		return scene;
	}
	
	public function page_title() : Entity {
		Kernel.instance().pack.getSound( "audio/title" ).loop();
		
		var scene : Entity = new Entity().add( new Scene() );
		
		{
			var e : Entity = new Entity();
			
			var image : ImageSprite = new ImageSprite( Kernel.instance().pack.getTexture( "title/home" ) );
			e.add( image );
			image.scaleX._ = System.stage.width / image.getNaturalWidth();
			image.scaleY._ = System.stage.height / image.getNaturalHeight();
			scene.addChild( e );
		}
		
		{
			var e : Entity = new Entity();
			
			var image : ImageSprite = new ImageSprite( Kernel.instance().pack.getTexture( "title/home_blink1" ) );
			image.centerAnchor();
			e.add( image );
			image.x._ = System.stage.width / 2 + 300;
			image.y._ = System.stage.height / 2 - 150;
			
			scene.addChild( e );
			
			var index : Int = 0;
				
			var script : Script = new Script();
				script.run(
					new Repeat(
						new Sequence([
							new CallFunction( function() : Void {
								if ( index == 0 ) {
									image.texture = Kernel.instance().pack.getTexture( "title/home_blink2" );
									index = 1;
								} else {
									image.texture = Kernel.instance().pack.getTexture( "title/home_blink1" );
									index = 0;
								}
							} ),
							new Delay( 0.5 )]
						)
					));
			e.add(script);
			
		}
		
		//{
			//var e : Entity = new Entity();
			//
			//var image : ImageSprite = new ImageSprite( Kernel.instance().pack.getTexture( "title/home_blink2" ) );
			//image.centerAnchor();
			//e.add( image );
			//image.x._ = System.stage.width / 2 + 300;
			//image.y._ = System.stage.height / 2 - 150;
			//
			//scene.addChild( e );
		//}
		
		return scene;
	}
	
	public function page_stage_1() : Entity {
		//Kernel.instance().pack.getSound( "audio/background" ).play();
		
		var scene : Entity = new Entity().add( new Scene() );
		
		{
			var e : Entity = new Entity();
			var page : GamePage_Stage_1 = new GamePage_Stage_1( e );
			e.add( page );
			
			scene.addChild( e );
		}
		
		return scene;
	}
	
	private static var s_instance : Game = null;
	public static function instance() : Game {
		if ( s_instance == null ) {
			s_instance = new Game();
		}
		return s_instance;
	}
}