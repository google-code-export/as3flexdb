package phi.framework.sql
{
	import mx.messaging.ChannelSet;
	import mx.rpc.remoting.RemoteObject;

	public class SQLConnection
	{
		protected var _remoteObj	:RemoteObject;
		protected var _sqlAdapter 	:ISQLAdapter;
		protected var _channel		:ChannelSet = new ChannelSet();
		
		public function SQLConnection( adapter:ISQLAdapter=null )
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
			
			_remoteObj.destination = sqlAdapter.service.destination;
			_remoteObj.source = sqlAdapter.service.source;
			
			if( _channel.channels.length )
				remoteObj.channelSet = _channel;
		}
		
		public function set defaultConnection( value:Boolean ):void
		{
			if( value )
				SQLConnectionManager.getInstance().saveConnection(
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