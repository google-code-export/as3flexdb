package phi.framework.sql
{
	public class SQLAbstractService implements ISQLService
	{
		protected var _destination :String;
		protected var _source :String;
		
		public function SQLAbstractService( destination:String, source:String )
		{
			this._destination = destination;
			this._source = source;
		}
		
		public function get destination():String
		{
			return _destination;
		}
		
		public function get source():String
		{
			return _source;
		}
	}
}