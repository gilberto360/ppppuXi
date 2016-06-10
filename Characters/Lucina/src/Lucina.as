package
{
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author 
	 */
	public class Lucina extends AnimatedCharacter 
	{
		
		public function Lucina()
		{
			m_topLeftDiamondColor = CreateColorTransformFromHex(0xC4CCE1);
			m_centerDiamondColor = CreateColorTransformFromHex(0xA3B1D1);
			m_bottomRightDiamondColor = CreateColorTransformFromHex(0x869AC4);
			m_backgroundColor = CreateColorTransformFromHex(0x496298);
			m_backlightColor = new ColorTransform(0, 0, 1);
			m_charAnimations = new LucinaAnimations();
			m_charAnimations.x = -54.05;
			m_charAnimations.y = 93;
			m_menuButton = new LucinaButton();
			m_menuButton.SetHitArea(new SquareBtnHitArea(101.15,87.75));
			m_name = "Lucina";
			m_musicClassName = m_name + "BGM";
			m_musicTitle = "Main Theme (Spa) - Fire Emblem 13";
			m_musicStartPoint = ConvertSamplesToMilliseconds(576);
			m_musicLoopStartPoint = ConvertSamplesToMilliseconds(680646) + m_musicStartPoint;
			m_musicLoopEndPoint = (ConvertSamplesToMilliseconds(1740226) + m_musicStartPoint);
		}
		
	}

}