package phi.framework.sql.helpers
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	import phi.framework.sql.core.PhiSQLConnection;
	import phi.framework.sql.core.PhiSQLConnectionManager;
	import phi.framework.sql.core.PhiSQLEvent;
	import phi.framework.sql.core.PhiSQLResult;
	import phi.framework.sql.core.PhiSQLStatement;
	import phi.framework.sql.core.PhiSQLType;
	import phi.framework.sql.events.PhiSQLErrorEvent;

	public class PhiTable extends EventDispatcher
	{
		//---------------------------------------
		// Public vars
		//---------------------------------------
		
		public var table :String;
		
		//---------------------------------------
		// Protected vars
		//---------------------------------------
		
		protected var sqlConnection :PhiSQLConnection;
		protected var sqlStatement :PhiSQLStatement;
		
		//---------------------------------------
		// Protected const
		//---------------------------------------
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		
		public function PhiTable ( table:String="" )
		{
			super();
			
			// Init SQL
			this.table = table;
			this.initSQL();
		}
		
		//---------------------------------------
		// Public methods
		//---------------------------------------		
		
		//---------------------------------------
		// Protected methods
		//---------------------------------------
		
		protected function initSQL () :void
		{
			if ( sqlStatement )
				return;
			
			sqlStatement = new PhiSQLStatement();
			sqlStatement.sqlConnection = PhiSQLConnectionManager.getInstance().getDefaultConnection();
			sqlStatement.addEventListener( PhiSQLEvent.SQL_RESULT, sqlResultHandler );
			sqlStatement.addEventListener( PhiSQLErrorEvent.SQL_ERROR, sqlErrorHandler );
		}
		
		/**
		 * Handle SQL result.
		 * @param event
		 */
		protected function sqlResultHandler ( event :PhiSQLEvent ) :void
		{
			var result :PhiSQLResult = event.result;
			
			switch ( result.type )
			{
				case PhiSQLType.SELECT:
				{
					selectHandler( result );
					break;
				}
					
				case PhiSQLType.INSERT:
				{
					insertHandler( result );
					break;
				}
					
				case PhiSQLType.UPDATE:
				{
					updateHandler( result );
					break;
				}
					
				case PhiSQLType.DELETE:
				{
					deleteHandler( result );
					break;
				}
			}
			
		}
		
		/**
		 * Handle SQL errors.
		 * @param event
		 */
		protected function sqlErrorHandler ( event :PhiSQLErrorEvent ) :void
		{
		}
		
		//-----------------------------------
		// SQL Handlers
		//-----------------------------------
		
		protected function selectHandler( result:PhiSQLResult ):void {}
		protected function insertHandler( result:PhiSQLResult ):void {}
		protected function updateHandler( result:PhiSQLResult ):void {}
		protected function deleteHandler( result:PhiSQLResult ):void {}
	}
}