//adding in the Gazebo functions
#include <gazebo/gazebo.hh> 

namespace gazebo
{	
	//making a new class WorldPluginMyRobot that inherits from the WorldPlugin class
	class WorldPluginMyRobot : public WorldPlugin
	{
	public:
		//class constructor
		WorldPluginMyRobot() : WorldPlugin()
		{
			printf("Hello World!\n");
		}
	public:
		//the load function is called by Gazebo when loading the plugin and is mandatory
		void Load(physics::WorldPtr _world, sdf::ElementPtr _sdf)
		{
		}
	};
	//registers this plugin with Gazebo, making it discoverable at runtime
	GZ_REGISTER_WORLD_PLUGIN(WorldPluginMyRobot)
}
