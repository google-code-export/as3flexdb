package phi.framework.sql
{
	public class SQLHelper
	{
		static public function arrayInsert( table:String, array:Object ):String
		{
			var result :String = "";
			var keys :Array = new Array();
			var values :Array = new Array();
			
			for( var item:String in array )
			{
				keys.push( item );
				values.push( array[item] );
			}
			
			result = 'INSERT INTO '+table+' (`'+keys.join('`,`')+'`) VALUES ("'+values.join('","')+'")';		
			return result;
		}
		
		static public function arrayUpdate( table:String, array:Object, cond:String ):String
		{
			var result :String = "";
			var body :String = "";
			
			for( var item:String in array )
				body += "`"+item+'` = "'+array[item]+'", ';
			
			body = body.substr(0, body.length-2 );
			result = "UPDATE "+table+" SET "+body+" WHERE "+cond;
			return result;	
		}
			
	}
}