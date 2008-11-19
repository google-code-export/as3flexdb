package phi.db
{
	import phi.interfaces.IQuery;
	
	/**
	 * A <code>QueryExecute</code> implementation.
	 * 
	 * <P>
	 * A <code>QueryExecute</code> object assumes these responsibilities:
	 * <UL>
	 * <LI>Execute a SQL statement on a database.</LI>
	 * </UL>
	 * 
	 * @see phi.db.Database
	 * @see phi.db.Query
	 */
	public class QueryExecute
	{
		
		private var _q  :IQuery;
		private var _op :String = Query.SELECT;
		
		/**
		 * Constructor
		 */
		public function QueryExecute(){};
		
		public function get query():IQuery {return _q;}
		public function set query(q:IQuery):void
		{
			_q = q;
			q.execute(_q.toString());
		}
		
		
	}
}