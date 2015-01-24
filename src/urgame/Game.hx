package urgame;
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
		pages_ = [page_stage_1, page_main, page_find];
		gotoNextPage();
	}
	
	private function gotoPreviousPage() : Void {
		--pageIndex_;
		if ( pageIndex_ < 0 ) {
			pageIndex_ = pages_.length -1;
		} else if ( pageIndex_ >= pages_.length ) {
			pageIndex_ = 0;
		}
		transitToLeft_ = true;
		gotoPage( pageIndex_ );
	}
	
	private function gotoNextPage() : Void {
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
		Kernel.instance().goto( pages_[demoIndex](), transitToLeft_ );
	}
	
	public function page_main() : Entity {
		var scene : Entity = new Entity().add( new Scene() );
		
		{
			var e : Entity = new Entity();
			var page : GamePage_Main = new GamePage_Main( e );
			e.add( page );
			
			scene.addChild( e );
		}
		
		return scene;
	}
	
	public function page_stage_1() : Entity {
		var scene : Entity = new Entity().add( new Scene() );
		
		{
			var e : Entity = new Entity();
			var page : GamePage_Stage_1 = new GamePage_Stage_1( e );
			e.add( page );
			
			scene.addChild( e );
		}
		
		return scene;
	}
	
	public function page_find() : Entity {
		var scene : Entity = new Entity().add( new Scene() );
		
		{
			//var page : GamePage_Main = new GamePage_Main( scene );
			//scene.addChild( page );
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