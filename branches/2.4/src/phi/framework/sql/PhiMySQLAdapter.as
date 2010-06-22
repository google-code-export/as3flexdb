package phi.framework.sql
{
	public class PhiMySQLAdapter extends SQLAbstractAdapter
		implements ISQLAdapter
	{
		public function PhiMySQLAdapter( server:String="", database:String="" )
		{
			super( server, database );
			service = new SQLDefaultService();
		}
		
	}
}