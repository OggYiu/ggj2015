package urgame ;
import components.GameEntity;
import flambe.System;

/**
 * ...
 * @author ragbit
 */
class Projectile extends GameEntity
{
	public function new() 
	{
		super();
	}
	
	override public function onUpdate(dt:Float) 
	{
		//trace( "projectile update" );
		super.onUpdate(dt);
		
		if (	this.x < 0 ||
				this.x >= System.stage.width ) {
			//trace( "out of the screen" );
			this.owner.dispose();
		}
	}
}