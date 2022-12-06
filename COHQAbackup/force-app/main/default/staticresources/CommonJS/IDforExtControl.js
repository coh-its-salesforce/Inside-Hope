/*Override for buttons to assign them an Id*/
var originalInit = Ext.Button.prototype.initButtonEl;
Ext.override(Ext.Button, {
    initButtonEl : function(btn, btnEl){
	    btnEl.dom.id = 'BTN' + this.id;
	    originalInit.apply(this, arguments);
    }
});
var originalWindowLayout = Ext.Window.prototype.doLayout;
	Ext.override(Ext.Window, {
	doLayout : function(){
	   try{
		var count=0;
		Ext.select('.x-tool').each(function(el){
			var elDomId=el.dom.id;
			elDomId=elDomId.substring(0,6);
			if(elDomId != 'WINDOW')
			el.dom.id = 'WINDOW-TOOL-' +count++; 
		}); 
		originalWindowLayout.apply(this, arguments);
	}catch(e){}
		
		}
	});
var originalPanelLayout = Ext.Panel.prototype.doLayout;
Ext.override(Ext.Panel, {
	doLayout : function(){
	 try{
		var i=0;
		Ext.select('.x-menu-item-text').each(function(el){
		  el.dom.id = 'MENU-LIST-ITEM-' +i++;
		});
		var k=0;
		Ext.select('.x-combo-list-item').each(function(el){
		  el.dom.id = 'COMBO-LIST-ITEM-' +k++;
		});
		originalPanelLayout.apply(this, arguments);
	}catch(e){}
	}
});
/*Override for OK-buttons of msg-box to assign them an Id*/
Ext.MessageBox = function() {
	var F = function(){};
	F.prototype = Ext.MessageBox;
	var o = function(){};
	o.prototype = new F();
	o.superclass = F.prototype;
	Ext.override(o, function(){
		return {
			getDialog : function() {
					var d = o.superclass.getDialog.apply(this, arguments);
					var cnt = 0;
					Ext.select('.x-window-dlg .x-window-footer table.x-btn button').each(function(el){
						el.dom.id = 'MSG-BTN-' + (cnt++);
					});
			 return d;
			}
		};
	}());
	return new o();
}();

Ext.Msg = function() {
	var F = function(){};
	F.prototype = Ext.MessageBox;
	var o = function(){};
	o.prototype = new F();
	o.superclass = F.prototype;
	Ext.override(o, function(){
		return {
			getDialog : function() {
					var d = o.superclass.getDialog.apply(this, arguments);
					var cnt = 0;
					Ext.select('.x-window-dlg .x-window-footer table.x-btn button').each(function(el){
						el.dom.id = 'MSG-BTN-' + (cnt++);
					});
			 return d;
			}
		};
	}());
	return new o();
}();