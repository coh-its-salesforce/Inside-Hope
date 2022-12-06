Ext.namespace('CMDB.Controls');


CMDB.Controls.Label = function(config) {
    CMDB.Controls.Label.superclass.constructor.call(this, config);
}
Ext.extend(CMDB.Controls.Label, Ext.form.Label);


CMDB.Controls.TextField = function(config) {
    CMDB.Controls.TextField.superclass.constructor.call(this, config);
}
Ext.extend(CMDB.Controls.TextField, Ext.form.TextField);


CMDB.Controls.Field = function(config) {
    CMDB.Controls.Field.superclass.constructor.call(this, config);
}
Ext.extend(CMDB.Controls.Field, Ext.form.Field);


CMDB.Controls.TextArea = function(config) {
    CMDB.Controls.TextArea.superclass.constructor.call(this, config);
}
Ext.extend(CMDB.Controls.TextArea, Ext.form.TextArea);


CMDB.Controls.DateTimeField = function(config) {
    CMDB.Controls.DateTimeField.superclass.constructor.call(this, config);
}
Ext.extend(CMDB.Controls.DateTimeField, Ext.form.DateField, {
    format: "m/d/Y h:i A"
});


CMDB.Controls.DropDownField = function(config) {
    CMDB.Controls.DropDownField.superclass.constructor.call(this, config);
}
Ext.extend(CMDB.Controls.DropDownField, Ext.form.ComboBox);

CMDB.Controls.Checkbox = function(config) {
    CMDB.Controls.Checkbox.superclass.constructor.call(this, config);
}
Ext.extend(CMDB.Controls.Checkbox, Ext.form.Checkbox);

CMDB.Controls.Panel = function(config) {
    CMDB.Controls.Panel.superclass.constructor.call(this, config);
}
Ext.extend(CMDB.Controls.Panel, Ext.Panel);

CMDB.Controls.Button = function(config) {
    CMDB.Controls.Button.superclass.constructor.call(this, config);
}
Ext.extend(CMDB.Controls.Button, Ext.Button);

CMDB.Controls.FormPanel = function(config) {
    CMDB.Controls.FormPanel.superclass.constructor.call(this, config);
}
Ext.extend(CMDB.Controls.FormPanel, Ext.form.FormPanel);


CMDB.Controls.TabPanel = function(config) {
    CMDB.Controls.TabPanel.superclass.constructor.call(this, config);
}
Ext.extend(CMDB.Controls.TabPanel, Ext.TabPanel);


CMDB.Controls.DatePicker = function(config) {
    CMDB.Controls.DatePicker.superclass.constructor.call(this, config);
}
Ext.extend(CMDB.Controls.DatePicker, Ext.DatePicker);


CMDB.Controls.GridPanel = function(config) {
    CMDB.Controls.GridPanel.superclass.constructor.call(this, config);
}
Ext.extend(CMDB.Controls.GridPanel, Ext.grid.GridPanel);

CMDB.Controls.IFramePanel = function(config) {
    CMDB.Controls.IFramePanel.superclass.constructor.call(this, config);
    /*
    this.setBlank = function(){ 
    	this.setSource("about:blank");
    }; */
	var dt = new Date();
	this.FrameElementID = "framepanel_src"
								+dt.getFullYear()
								+dt.getMonth()
								+dt.getDate()
								+dt.getHours()
								+dt.getMinutes()
								+dt.getSeconds()
								+dt.getTime();
	
    this.setSource = function(frmsrc){
    
    					var ele = document.getElementById(this.FrameElementID);
    					if(typeof(ele)=='undefined' || ele==null)
    					{
						    this.html = '<iframe  src="' + frmsrc + '" frameborder="0" width="100%" height="100%"></iframe>';
    					}
    					else
    					{ 
    						ele.src=frmsrc;
    					}
				    }

    //this.setBlank();
}
Ext.extend(CMDB.Controls.IFramePanel, Ext.Panel);

CMDB.Controls.AccordionPanel = function(config){
    config.split=true;
    //config.id='accordion_panel';
    config.cls='AccordionPanel';
    config.layout='accordion';
    config.border=false;
    //config.margins='25 0 25 25'
    CMDB.Controls.DatePicker.superclass.constructor.call(this, config);
}
Ext.extend(CMDB.Controls.AccordionPanel, Ext.Panel);

(function() {
	/*
		Override for buttons to assign them an Id
		Using closure (monkey patching) to avoid unsafe overrides		
	*/
	var originalInit = Ext.Button.prototype.initButtonEl;
	Ext.override(Ext.Button, {
		initButtonEl : function(btn, btnEl){
			btnEl.dom.id = 'BTN_CDM_' + this.id;
			originalInit.apply(this, arguments);
		}
	});
})();
