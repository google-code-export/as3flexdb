package phi.framework.sql
{
	public class MySQLAdapter extends SQLAbstractAdapter
		implements ISQLAdapter
	{
		public function MySQLAdapter( server:String="", database:String="" )
		{
			super( server, database );
			service = new SQLDefaultService();
		}
		
	}
}