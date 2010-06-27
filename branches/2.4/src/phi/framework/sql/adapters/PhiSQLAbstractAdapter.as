package phi.framework.sql.adapters
{
	import mx.messaging.Channel;
	import mx.messaging.ChannelSet;
	
	public class PhiSQLAbstractAdapter 
		implements ISQLAdapter
	{
		protected var _server 	  :String;
		protected var _database   :String;
		
		public function PhiSQLAbstractAdapter( server:String="", database:String="")
		{
			this.host = server;
			this.database = database;
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