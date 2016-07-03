package
{
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author 
	 */
	public class May extends AnimatedCharacter 
	{
		
		public function May() 
		{
			m_topLeftDiamondColor = CreateColorTransformFromHex(0xFFFFFF);
			m_centerDiamondColor = CreateColorTransformFromHex(0xCCCCCC);
			m_bottomRightDiamondColor = CreateColorTransformFromHex(0x999999);
			m_outerDiamondColor = CreateColorTransformFromHex(0xFF0000);
			m_backlightColor = CreateColorTransformFromHex(0x999999);
			
			m_menuIcon = new MayIcon();
			
			m_name = "May";
			m_defaultMusicName = "Miror B. Battle - Pokemon XD";
		}
		
	}

}