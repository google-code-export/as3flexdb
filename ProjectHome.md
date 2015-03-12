# News #

Try out [AS3FlexDB version 2.0.0.](http://code.google.com/p/as3flexdb/downloads/list)

## Simple example ##

```
<?xml version="1.0" encoding="utf-8"?>
<mx:Application width="600"
		height="400"
		xmlns:mx="http://www.adobe.com/2006/mxml"
		xmlns:as3flexdb="phi.framework.sql.*"
		layout="vertical">

	<mx:Button label="Get Users" click="st1.execute()"/>
	
	<mx:DataGrid id="dg1" dataProvider="{users}">
		<mx:columns>
			<mx:DataGridColumn headerText="#ID" dataField="idUser" />
			<mx:DataGridColumn headerText="Username" dataField="username" />
			<mx:DataGridColumn headerText="Password" dataField="password" />
		</mx:columns>
	</mx:DataGrid>
	
	<!-- ++++++++++++++++++++++++++++ -->
	<!-- AS3FlexDB code -->
	
	<as3flexdb:MySQLAdapter id="defaultAdapter" host="localhost" database="dbtest"/>
	<as3flexdb:SQLConnection id="conn1" sqlAdapter="{defaultAdapter}"/>

	<as3flexdb:SQLStatement id="st1"
				sqlConnection="{conn1}"
				text="SELECT * FROM users WHERE 1"
				sqlResult="sqlResultHandler(event)"
				sqlError="sqlErrorHandler(event)"/>

	<mx:Script>
		<![CDATA[
			
			import phi.framework.sql.*;
			import mx.collections.ArrayCollection;
			
			
			[Bindable]
			protected var users :ArrayCollection = new ArrayCollection();
			
			protected function sqlResultHandler(event:SQLEvent):void
			{
				var result :SQLResult = event.result;
				
				users.removeAll();
						
				// trace result
				for each( var item :Object in result.data )
					users.addItem( item );
			}
			

			protected function sqlErrorHandler(event:SQLErrorEvent):void
			{
				trace( event.error );	
			}

		]]>
	</mx:Script>
</mx:Application>
```

## About AS3FlexDB ##
**AS3FlexDB** project is a open source library that allows Adobe Flex applications to connect to a MySQL server.This library use [AMFPHP](http://www.amfphp.org/) to access a MySQL server.

Download the [source code](http://code.google.com/p/as3flexdb/downloads).
You can learn how to use FlexDB by following the steps in this [tutorial](http://code.google.com/p/as3flexdb/wiki/FlexDBTutorial).

For any questions email us at: [as3flexdb@gmail.com](#.md)

Take a look at [FlexDB Tutorial 1](http://itutorials.ro/viewtopic.php?f=9&t=7) tutorial from [iTutorials.ro](http://itutorials.ro/)

## Version changes ##
  * ### 1.0.0 ###
  1. - Repackaged zip
  * ### 1.1.2 ###
  1. - Add getDefaultConnection(), setDefaultConnection();
  * ### 1.2.0 ###
  1. - Add query stack for oreder execute.
  * ### 1.3.0 ###
  1. - Add isStackEmpty();
  1. - Change setBusyCursor() whith "cool" preloader :D
  * ### 1.4.0 ###
  1. - Add support for use in MXML (ConnectionData, Query, Database)
  1. - Add set/get Records (bindable support)
  1. - Add QueryExecute class for use in MXML


## Simple example ##

All you need to load a table (for ex. "users") into a datagrid after you have install amfphp and set "services-config.xml" correctly is :

```
<?xml version="1.0" encoding="utf-8"?>
<mx:Application
	layout="vertical"
	xmlns:phi="phi.db.*"
	xmlns:mx="http://www.adobe.com/2006/mxml">

	<mx:DataGrid
		id="dg1"
		width="100%"
		height="100%"
		dataProvider="{q1.Records}">
		<mx:columns>
			<mx:DataGridColumn dataField="fname" headerText="First Name"/>
			<mx:DataGridColumn dataField="lname" headerText="Last Name"/>
			<mx:DataGridColumn dataField="password" headerText="Password"/>
		</mx:columns>
	</mx:DataGrid>
	
	<phi:ConnectionData id="c1" name="mxml_conn1" host="localhost" db="test" username="root" password="root" />
	<phi:Database id="db1" connection="{c1}" />
	<phi:Query id="q1" database="{db1}" q="SELECT * FROM users WHERE 1" />
	<phi:QueryExecute id="q1ex" query="{q1}" />
</mx:Application>
```

Table structures is:

```
CREATE TABLE `users` (
  `id` int(5) NOT NULL auto_increment,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `fname` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;
```