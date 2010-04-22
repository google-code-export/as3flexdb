package phi.framework.sql
{
	public class SQLResult
	{
		protected var _token :Object;
		protected var _type  :String = SQLType.SELECT;
		protected var _data	 :Array = new Array();
		protected var _lastInsertID :Number = 0;
		protected var _rowsAffected	:Number = 0;
		protected var _query :String = "";
		protected var _sqlStatement :SQLStatement;
		
		public function SQLResult( sqlStatement:SQLStatement, res:Object=null, query:String="" )
		{
			_sqlStatement = sqlStatement;
			
			if( res )
			{
				type = res.type;
				
				_data = res.records;
				_lastInsertID = res.lastInsertId;
				_rowsAffected = res.rowsAffected;
			}
			
			_query = query;

		}
		
		public function get token():Object
		{
			return _token;
		}
		
		public function set token( value:Object ):void
		{
			_token = value;
		}
		
		public function get query():String
		{
			return _query;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type( value:String ):void
		{
			_type = value;
		}
		
		public function get data():Array
		{
			return _data;
		}
		
		public function get lastInsertID():Number
		{
			return _lastInsertID;
		}
		
		public function get rowsAffected():Number
		{
			return _rowsAffected;
		}
		
		public function get sqlStatement():SQLStatement
		{
			return _sqlStatement;
		}
	}
}