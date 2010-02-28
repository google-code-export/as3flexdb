package phi.framework.sql
{
	import mx.rpc.remoting.RemoteObject;

	public class SQLConnection
	{
		protected var _remoteObj	:RemoteObject;
		protected var _sqlAdapter 	:ISQLAdapter;
		
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
		}
		
		public function set sqlAdapter( value:ISQLAdapter ):void
		{
			_sqlAdapter = value;
			connect();
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