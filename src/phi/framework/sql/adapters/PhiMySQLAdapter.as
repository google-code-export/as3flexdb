package phi.framework.sql.adapters
{
	public class PhiMySQLAdapter extends PhiSQLAbstractAdapter
		implements ISQLAdapter
	{
		public function PhiMySQLAdapter( server:String="", database:String="" )
		{
			super( server, database );
		}
		
	}
}