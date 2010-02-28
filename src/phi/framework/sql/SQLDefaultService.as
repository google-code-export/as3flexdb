package phi.framework.sql
{
	public class SQLDefaultService extends SQLAbstractService 
		implements ISQLService
	{
		public function SQLDefaultService( destination:String="amfphp", source:String="mysql.as3flexdb" )
		{
			super( destination, source );
		}
	}
}