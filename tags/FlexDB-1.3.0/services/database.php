<?php

class Database 
{
	private $NAME 				= "databese";
	private $VERSION			= "1.0.0";
	
	public function Database()
	{
	}
	
	/**
     * Execute a SQL statement to databse.
     * @returns the result object.
     */
	public function query($strQuery, $strUser, $strPass, $strHost, $strDB)
	{
		$rsConnectionID = $this->open($strUser, $strPass, $strHost);
		$rsResult = mysql_db_query($strDB, $strQuery, $rsConnectionID);
		
		if(!$rsResult)
		   return mysql_error($rsConnectionID);
		
		if(($lastInsertID = mysql_insert_id($rsConnectionID)) != 0)
			return $lastInsertID;
	
		$this->close($rsConnectionID);
		return $rsResult;
	}
	
	/**
     * Open the connection to the database.
     * @returns the connection id.
     */
	private function open($strUser, $strPass, $strHost) 
	{
   		$rsConnectionID = @mysql_connect($strHost, $strUser, $strPass);
    	return $rsConnectionID;	
  	}
	
	/**
     * Close the connection to the database.
     * @returns a resource.
     */
  	private function close($rsConnectionID) 
	{
    	$res = @mysql_close($rsConnectionID);
    	return $res;
  	}
	
	/**
     * Class name.
     * @returns a string that reprezent class name.
     */
	public function getName()
	{
		return $this->NAME;
	}
	
	/**
     * Class version.
     * @returns a string that reprezent class version.
     */
	public function getVersion()
	{
		return $this->VERSION;
	}
}
?>