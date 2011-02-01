package phi.framework.sql.core
{
	import mx.messaging.ChannelSet;
	import mx.rpc.remoting.RemoteObject;
	import phi.framework.sql.adapters.ISQLAdapter;

	public class PhiSQLConnection
	{
		// Public vars
		public var destination :String = "amfphp";
		public var source :String = "mysql.as3flexdb";
		
		// Protected vars
		protected var _remoteObj	:RemoteObject;
		protected var _sqlAdapter 	:ISQLAdapter;
		protected var _channel		:ChannelSet = new ChannelSet();
		
		public function PhiSQLConnection( adapter:ISQLAdapter=null )
		{
			if( adapter )
			{
				sqlAdapter = adapter;
				connect();
			}
		}
		
		public function connect():void
		{
			_remoteObj = new RemoteObject();
			
			_remoteObj.destination = destination;
			_remoteObj.source = source;
			
			if( _channel.channels.length )
				remoteObj.channelSet = _channel;
		}
		
		public function set defaultConnection( value:Boolean ):void
		{
			if( value )
				PhiSQLConnectionManager.getInstance().saveConnection(
					"default", 
					this, 
					true
				);
		}
		
		public function set sqlAdapter( value:ISQLAdapter ):void
		{
			_sqlAdapter = value;
			connect();
		}
		
		public function set channel( value:ChannelSet ):void
		{
			_channel = value;
			connect();
		}
		
		public function get channel():ChannelSet
		{
			return _channel;
		}
		
		public function get sqlAdapter():ISQLAdapter
		{
			return _sqlAdapter;
		}
		
		public function get remoteObj():RemoteObject
		{
			return _remoteObj;
		}
		
	}
}