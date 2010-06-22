package phi.framework.sql.adapters
{
	import phi.framework.sql.services.SQLDefaultService;

	public class PhiMySQLAdapter extends PhiSQLAbstractAdapter
		implements ISQLAdapter
	{
		public function PhiMySQLAdapter( server:String="", database:String="" )
		{
			super( server, database );
			service = new SQLDefaultService();
		}
		
	}
}