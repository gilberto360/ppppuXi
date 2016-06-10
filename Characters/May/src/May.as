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
			m_backgroundColor = CreateColorTransformFromHex(0xFF0000);
			m_backlightColor = CreateColorTransformFromHex(0x999999);
			m_charAnimations = new MayAnimations();
			m_charAnimations.x = -99.15;
			m_charAnimations.y = 173.8;
			m_menuButton = new MayButton();
			m_menuButton.SetHitArea(new SquareBtnHitArea(75,75));
			m_name = "May";
			m_musicClassName = "HildaBGM";
			m_musicTitle = "Miror B. Battle - Pokemon XD";
			m_musicStartPoint = ConvertSamplesToMilliseconds(576);
			m_musicLoopStartPoint = ConvertSamplesToMilliseconds(871773) + m_musicStartPoint;
			m_musicLoopEndPoint= (ConvertSamplesToMilliseconds(2989939) + m_musicStartPoint);
		}
		
	}

}