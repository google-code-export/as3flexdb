package phi.db
{
	import mx.rpc.remoting.RemoteObject;
	
	import phi.PhiServer;
	
	
	/**
	 * A class for storing a connection information.<BR>
	 * 
	 * @see phi.db.Database
	 */
	public class ConnectionData
	{
		// Connection Constans
		public static const DESTINATION		:String = "amfphp";
		public static const SOURCE			:String = "mysql.as3flexdb"
		
		// Connection Data
		public var remoteObj	:RemoteObject;
		
		protected var _name			:String;
		protected var _host 		:String;
		protected var _db			:String;
		
		
		/**
  		 * Constructor.
  		 * 
  		 * @param user the username of the remote application server
		 * @param pass the password of the remote application server
		 * @param host the server ip
		 * @param db the database name
  		 */
		public function ConnectionData(host:String="", db:String="", name:String="default")
		{
			remoteObj = new RemoteObject(DESTINATION);
			remoteObj.source = SOURCE;
			
			if( PhiServer.getChannelSet().channels.length > 0 )
				remoteObj.channelSet = PhiServer.getChannelSet();
			
			this.name		= name;
			this.host 		= host;
			this.db 		= db;			
		}
		
		public function clone():ConnectionData
		{
			return new ConnectionData(host, db);
		}
		
		public function get name():String {return _name;}
		public function get host():String {return _host;}
		public function get db():String {return _db;}
		
		public function set name(n:String):void {_name = n;}
		public function set host(h:String):void {_host = h;}
		public function set db(d:String):void {_db = d;}		
	}
}