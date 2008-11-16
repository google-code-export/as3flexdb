package phi.db
{
	import mx.rpc.remoting.RemoteObject;
	
	
	/**
	 * A class for storing a connection information.<BR>
	 * 
	 * @see phi.db.Database
	 */
	public class ConnectionData
	{
		// Connection Constans
		public static const DESTINATION		:String = "amfphp";
		public static const SOURCE			:String = "mysql.database"
		
		// Connection Data
		public var remoteObj	:RemoteObject;
		public var username		:String;
		public var password		:String;
		public var host 		:String;
		public var db			:String;
		
		/**
  		 * Constructor.
  		 * 
  		 * @param user the username of the remote application server
		 * @param pass the password of the remote application server
		 * @param host the server ip
		 * @param db the database name
  		 */
		public function ConnectionData(user:String, pass:String, host:String, db:String)
		{
			this.remoteObj = new RemoteObject(DESTINATION);
			this.remoteObj.source = SOURCE;
			
			this.username 	= user;
			this.password 	= pass;
			this.host 		= host;
			this.db 		= db;
		}
		
		public function clone():ConnectionData
		{
			return new ConnectionData(username, password, host, db);
		}
	}
}