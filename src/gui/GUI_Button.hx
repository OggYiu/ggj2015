package gui;
import flambe.display.ImageSprite;
import flambe.display.Texture;
import flambe.Disposer;
import flambe.input.PointerEvent;
import flambe.System;

/**
 * ...
 * @author ragbit
 */
class GUI_Button extends ImageSprite
{
	private var normalTexture : Texture;
	private var pressedTexture : Texture;
	public function new( l_normalTexture : Texture, l_pressedTexture : Texture, func : String -> Void ) 
	{
		normalTexture = l_normalTexture;
		pressedTexture = l_pressedTexture;
		
		super( normalTexture ); 
	}
	
	override public function onAdded() : Void 
	{
		super.onAdded();
		
		var disposer = owner.get( Disposer );
		
		if ( disposer == null ) {
			owner.add( disposer = new Disposer() );
		}
		
		disposer.add( this.pointerDown.connect( onPressed ) ); 
		disposer.add( this.pointerUp.connect( onRelease ) );
		disposer.add( this.pointerOut.connect( onOut ) );
	}
	
	private function onPressed( e : PointerEvent ) : Void {
		this.texture = this.pressedTexture;
	}
	
	private function onRelease( e : PointerEvent ) : Void {
		this.texture = this.normalTexture;
	}
	
	private function onOut( e : PointerEvent ) : Void {
		this.texture = this.normalTexture;
	}
}