package page;
import flambe.asset.AssetPack;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.Disposer;
import flambe.Entity;
import flambe.input.KeyboardEvent;
import flambe.input.MouseEvent;
import flambe.input.PointerEvent;
import flambe.System;
import urgame.Game;
import urgame.Global;
import urgame.Kernel;

/**
 * ...
 * @author ragbit
 */
class GamePage extends Component
{
	private var parent( default, default ) : Entity;
	private var kernel( default, default ) : Kernel;
	private var pack( default, default ) : AssetPack;
	private var game( default, default ) : Game;
	private var font( default, default ) : Font;
	private var screenWidth( default, default ) : Int;
	private var screenHeight( default, default ) : Int;
	
	public function new( l_parent : Entity ) 
	{
		super();
		
		this.parent = l_parent;
		this.kernel = Kernel.instance();
		this.pack = Kernel.instance().pack;
		this.game = Game.instance();
		this.kernel.font;
		this.screenWidth = System.stage.width;
		this.screenHeight = System.stage.height;
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		
		var disposer : Disposer = new Disposer();
		disposer.add( System.keyboard.up.connect( onKeyUp ) );
		disposer.add( System.keyboard.down.connect( onKeyDown ) );
		disposer.add( System.pointer.down.connect( onMouseDown ) );
		disposer.add( System.pointer.up.connect( onMouseUp ) );
		disposer.add( System.pointer.move.connect( onMouseMove ) );
		
		{	
			{
				var e : Entity = new Entity();
				var sprite : FillSprite = new FillSprite( 0xAAAAAA, Global.getPageWidth(), Global.getPageHeight() );
				sprite.x._ = Global.getPage1X();
				sprite.y._ = Global.getPage1Y();
				e.add( sprite );
				
				this.parent.addChild( e );
			}
				
			{
				var e : Entity = new Entity();
				var sprite : FillSprite = new FillSprite( 0xAAAAAA, Global.getPageWidth(), Global.getPageHeight() );
				sprite.x._ = Global.getPage2X();
				sprite.y._ = Global.getPage2Y();
				e.add( sprite );
				
				this.parent.addChild( e );
			}
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
	
	private function onKeyUp( e : KeyboardEvent ) : Void {
	}
	
	private function onKeyDown( e : KeyboardEvent ) : Void {
	}
	
	private function onMouseDown( e : PointerEvent ) : Void {
	}
	
	private function onMouseUp( e : PointerEvent ) : Void {
	}
	
	private function onMouseMove( e : PointerEvent ) : Void {
	}
}