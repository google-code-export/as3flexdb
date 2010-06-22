package phi.framework.sql.adapters
{
	import phi.framework.sql.services.ISQLService;

	public class SQLAbstractAdapter 
		implements ISQLAdapter
	{
		protected var _server 	  :String;
		protected var _database   :String;
		protected var _service 	  :ISQLService;
		
		public function SQLAbstractAdapter( server:String="", database:String="")
		{
			this.host = server;
			this.database = database;
		}
		
		public function get service():ISQLService
		{
			return _service;
		}
		
		public function set service( value:ISQLService ):void
		{
			_service = value;
		}
		
		public function set host( value:String ):void
		{
			_server = value;	
		}
		
		public function get host():String
		{
			return _server;
		}
		
		public function set database( value:String ):void
		{
			_database = value;	
		}
		
		public function get database():String
		{
			return _database;	
		}
	}
}