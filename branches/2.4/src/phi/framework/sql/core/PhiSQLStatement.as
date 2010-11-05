package phi.framework.sql.core
{
	import flash.events.EventDispatcher;
	
	import mx.managers.CursorManager;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	
	import phi.framework.sql.events.PhiSQLErrorEvent;

	/**
	 *  Dispatched after the SQL statement was executed.
	 * 
	 * <P>The SQL_RESULT event is dispatched when the 
	 * <code>execute()</code> method is called.<BR>
	 * At the time when this event is sent, the <code>SQLStatement</code> object has been
	 * retrieve the records if a SELECT statements was execute or the last inserted id
	 * if a INSERT statement was execute.</P>
	 * 
	 * @eventType phi.framework.sql.SQLEvent
	 */
	[Event(name="sqlResult", type="phi.framework.sql.core.PhiSQLEvent")]
	
	/**
	 *  Dispatched if any error occurs.
	 * 
	 * @eventType phi.framework.sql.SQLErrorEvent
	 */
	[Event(name="sqlError", type="phi.framework.sql.events.PhiSQLErrorEvent")]

	
	public class PhiSQLStatement extends EventDispatcher
	{
		protected var _sqlConnection :PhiSQLConnection = null;
		protected var _text :String;
		protected var _parameters :Array = new Array();
		protected var _token :Object = new Object();
		protected var _result :PhiSQLResult;
		protected var _waitingStack :Array = new Array();
		protected var _isExecuting :Boolean = false;
		
		public function PhiSQLStatement( text:String="" )
		{
			this.text = text;
			this._result = new PhiSQLResult( this );
		}
		
		public function get parsedText():String
		{
			return substituteText();
		}
		
		public function set text( value:String ):void
		{
			_text = value;
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function set token( value:Object ):void
		{
			_token = value;
		}
		
		public function get token():Object
		{
			return _token;
		}
		
		public function get parameters():Array
		{
			return _parameters;
		}
		
		public function set sqlConnection( value:PhiSQLConnection ):void
		{
			_sqlConnection = value;	
		}
		
		public function get sqlConnection():PhiSQLConnection
		{
			if( !_sqlConnection )
				return PhiSQLConnectionManager.getInstance().getDefaultConnection();
			
			return _sqlConnection;	
		}
		
		public function get isExecuting():Boolean
		{
			return _isExecuting;
		}
		
		public function set isExecuting( value:Boolean ):void
		{
			_isExecuting = value;
		}
		
		public function clearParameters():void
		{
			_parameters = new Array();
		}
		
		public function getResult():PhiSQLResult
		{
			return _result;
		}
		
		public function execute( sql:String="", tok:Object=null):void
		{
			var host :String = sqlConnection.sqlAdapter.host;
			var database :String = sqlConnection.sqlAdapter.database;
			var t :AsyncToken = null
			var q :String = "";
			
			if( sql == "" )
				q = substituteText();
			else
				q = sql;
			
			if( !tok )
				tok = token;
			
			if( isExecuting )
			{
				_waitingStack.push( {sql: q, token: tok} );
			}
			else
			{
				isExecuting = true;
				
				t = sqlConnection.remoteObj.query( q, host, database );
				CursorManager.setBusyCursor();
			
				t.addResponder(
					new AsyncResponder(
						resultHandler,
						faultHandler,
						{sql: q, token: tok}
					)
				);
			}
			
			return;
		}
		
		protected function executeNext():void
		{
			if( _waitingStack.length > 0 )
			{
				var extra :Object = _waitingStack.shift();
				execute( extra.sql, extra.token );
			}
		}
		
		protected function substituteText():String
		{
			var i:Number = 0;
			var result :String = text;
			var regEx :RegExp = /\?/;
			
			for ( i=0; i<parameters.length; i++ )
			{
				var replaceWith :String = "";
				
				if( parameters[i] is Number )
					replaceWith = parameters[i];
				else
				if( parameters[i] is PhiSQLFunction )
					replaceWith = PhiSQLFunction( parameters[i] ).toString();
				else
				if( parameters[i] is String )
					replaceWith = '"' + parameters[i] + '"';
				
				result = result.replace( regEx, replaceWith );
			}
			
			return result;
		}
		
		//-----------------------------------------
		// Async handlers
		//-----------------------------------------
		
		protected function resultHandler( data:Object, extra:Object ):void
		{
			CursorManager.removeBusyCursor();
			isExecuting = false;
			
			var resultType :String = data.result.type;
			
			if( resultType == "error" )
			{
				var errorEvent :PhiSQLErrorEvent = new PhiSQLErrorEvent();
				errorEvent.error = data.result.error as String;
				
				dispatchEvent( errorEvent );
				return;
			}
			
			// If no error
			var event	:PhiSQLEvent = new PhiSQLEvent();	
			var result	:PhiSQLResult = new PhiSQLResult( this, data.result, String( extra.sql ) );
			result.token = extra.token;
						
			event.result = result;
			dispatchEvent( event );
			
			executeNext();
			return;
		}
		
		protected function faultHandler( info:Object, token:Object ):void
		{
			CursorManager.removeBusyCursor();
			
			isExecuting = false;
			executeNext();
		}
	}
}