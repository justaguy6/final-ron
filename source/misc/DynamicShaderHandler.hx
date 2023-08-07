package misc;
import openfl.display.GraphicsShader;
import flixel.FlxG;
import flixel.graphics.tile.FlxGraphicsShader;
#if sys
import sys.FileSystem;
#end
import flixel.FlxCamera;
import lime.utils.Assets;

using StringTools;
//fragment header for shader resolution fix
//thanks yoshi
/*
	Class to handle animated shaders, calling the new consturctor is enough, 
	the update function will be automatically called by the playstate.
	Access the shader the handler with `PlayState.animatedShaders["fileName"]`
	Shaders should be placed at /shaders folder, with ".frag" extension, 
	See shaders folder for examples and guides.
	Optimize variable might help with some heavy shaders but only makes a difference on decent Intel CPUs.
	@author Kemo
	Please respect the effort but to this and credit us if used :]
	
	
	
	Hiiiii bbpanzu i edited the shits to work with psych engineee < 33333
 */

 
class DynamicShaderHandler
{
	public var shader:FlxGraphicsShader;
	private var bHasResolution:Bool = false;
	private var bHasTime:Bool = false;
	public function new(fileName:String, optimize:Bool = false)
	{
		var fragSource:String = "";
		var vertSource:String = "";
		#if sys
		var path = Paths.shaderFragment(fileName);
		

		if (Assets.exists(path))
		{
			fragSource = Assets.getText(path);
		}

		
		var path2 = Paths.shaderVertex(fileName);
		

		if (Assets.exists(path2))
		{
			vertSource = Assets.getText(path2);
		}
		#end
		if (fragSource != "" || vertSource != "")
		{

			shader = new FlxGraphicsShader(fragSource, optimize, vertSource);
		}

		if (shader == null)
		{
			return;
		}

		if (fragSource.indexOf("iResolution") != -1)
		{
			bHasResolution = true;
			shader.data.iResolution.value = [FlxG.width, FlxG.height];
		}

		if (fragSource.indexOf("iTime") != -1)
		{
			bHasTime = true;
			shader.data.iTime.value = [0];
		}

		//#if LUA_ALLOWED 
		//PlayState.instance.luaShaders[fileName] = this;
		//#end
		MusicBeatState.animatedShaders[fileName] = this;
	
			//trace(shader.data.get('rOffset'));
		
	}

	public function modifyShaderProperty(property:String, value:Dynamic)
	{
		if (shader == null)
		{
			return;
		}
		
		if (shader.data.get(property) != null)
		{
			shader.data.get(property).value = value;
		}
	}

	private function getTime()
	{
		return shader.data.iTime.value[0];
	}

	private function setTime(value)
	{
		shader.data.iTime.value = [value];
	}

	public function update(elapsed:Float)
	{
		if (bHasTime)
		{
			setTime(getTime() + elapsed);
		}
	}
}
