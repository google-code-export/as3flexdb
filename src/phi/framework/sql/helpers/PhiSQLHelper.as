package phi.framework.sql.helpers
{
	import mx.utils.StringUtil;
	import phi.framework.sql.core.PhiSQLFunction;

	public class PhiSQLHelper
	{
		static public function arrayInsert( table:String, array:Object ):String
		{
			var result 	:String = "INSERT INTO `{0}` (`{1}`) VALUES ({2});";
			var keys 	:Array = [];
			var values 	:Array = [];
			
			for( var key:String in array )
			{
				keys.push( key );
				values.push( PhiSQLHelper.itemToString( array[key] ));
			}
			
			return StringUtil.substitute( result, table, keys.join('`,`'), values.join(','));
		}
		
		/**
		 * Return a UPDATE SQL from a array.
		 * 
		 * @param table
		 * @param array
		 * @param cond
		 * @return 
		 */
		static public function arrayUpdate( table:String, array:Object, cond:String ):String
		{
			var result :String = "UPDATE `{0}` SET {1} WHERE {2};";
			var updateBody :String = "";
			
			for( var key :String in array )
				updateBody += "`"+ key +'` = ' + PhiSQLHelper.itemToString( array[key] ) + ', ';
			
			updateBody = updateBody.substr(0, updateBody.length-2 );
			return StringUtil.substitute( result, table, updateBody, cond );	
		}
		
		static public function addslashes( str:String ):String
		{
			return str.replace(/([\\"'])/g, "\\$1").replace(/\0/g, "\\0");
		}
		
		static public function itemToString( item:* ):String
		{
			var result :String = "";
			
			if( item is Number )
				result = Number(item).toString();
			else 
			if( item is PhiSQLFunction )
				result = PhiSQLFunction( item ).toString();
			else
				result = '"'+ String(item) +'"';
			
			return result;
		}

			
	}
}