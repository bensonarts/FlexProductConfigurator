package com.decalrus.view.component.custom
{
	import spark.components.DropDownList;
	import spark.components.supportClasses.DropDownController;
	
	public class DropDownMenu extends DropDownList
	{
		public function DropDownMenu()
		{
			super();
		}
		
		public function get controller():DropDownController
		{
			return super.dropDownController;
		}
		
		public function set controller(value:DropDownController):void
		{
			super.dropDownController = value;
		}
	}
}