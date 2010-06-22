package phi.framework.sql
{
	public class PhiSQLConnectionManager
	{
		static private const SINGLETON_EXCEPTION :String = "This class is a singleton";
		static private var instance :PhiSQLConnectionManager;
		
		protected var defaultConnection :PhiSQLConnection = null;
		protected var connections :Array = new Array();
		
		public function PhiSQLConnectionManager()
		{
			if ( instance != null )
				throw new Error( SINGLETON_EXCEPTION );
			
			instance = this;
		}
		
		static public function getInstance() :PhiSQLConnectionManager
		{
			if ( instance == null )
				instance = new PhiSQLConnectionManager();
			
			return instance;
		}
		
		public function saveConnection( name:String, connection:PhiSQLConnection, useAsDefault:Boolean=false ):void
		{
			connections[ name ] = connection;
			
			if( useAsDefault )
				defaultConnection = connection;
		}
		
		public function getConnection( name:String ):PhiSQLConnection
		{
			return connections[ name ];
		}
		
		public function getDefaultConnection():PhiSQLConnection
		{
			return defaultConnection;
		}
	}
}