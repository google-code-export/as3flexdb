package phi.framework.sql
{
	public class SQLConnectionManager
	{
		static private const SINGLETON_EXCEPTION :String = "This class is a singleton";
		static private var instance :SQLConnectionManager;
		
		protected var defaultConnection :SQLConnection = null;
		protected var connections :Array = new Array();
		
		public function SQLConnectionManager()
		{
			if ( instance != null )
				throw new Error( SINGLETON_EXCEPTION );
			
			instance = this;
		}
		
		static public function getInstance() :SQLConnectionManager
		{
			if ( instance == null )
				instance = new SQLConnectionManager();
			
			return instance;
		}
		
		public function saveConnection( name:String, connection:SQLConnection, useAsDefault:Boolean=false ):void
		{
			connections[ name ] = connection;
			
			if( useAsDefault )
				defaultConnection = connection;
		}
		
		public function getConnection( name:String ):SQLConnection
		{
			return connections[ name ];
		}
		
		public function getDefaultConnection():SQLConnection
		{
			return defaultConnection;
		}
	}
}