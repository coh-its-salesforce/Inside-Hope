
var CMDBClassChooser = function(displayStyle, classViewStore, ItemClickHandler) {
    this.displayStyle = displayStyle;
    this.classViewStore = classViewStore;
    this.ItemClickHandler=ItemClickHandler;
    return this.getElement();
}
var tempgrid;
CMDBClassChooser.prototype = {
    // cache data by image name for easy lookup
    lookup: {},
    getElement: function() {
        this.initTemplates();

        this.store = this.classViewStore;
        this.stringlength = 15;

        var formatData = function(data) {
            data.shortName = data.DisplayName.ellipse(this.stringlength);
            this.lookup[data.Name] = data;
            return data;
        };

        var viewItemSelector = null;
        if (this.displayStyle == "list") {
            viewItemSelector = 'div.list-wrap';
            this.stringlength = 30;
        }
        else {
            viewItemSelector = 'div.thumb-wrap';
        }
        
        /*this.store.on('load', 
	    	function() {
	    	        this.view.select(0);
		    	}.createDelegate(this)	
	    	);*/
	
        this.view = new Ext.DataView({
            id: 'img-chooser-view',
            //            autoScroll: true,
            tpl: this.thumbTemplate,
            singleSelect: true,
            border: 0,
            overClass: 'x-view-over',
            itemSelector: viewItemSelector,
            store: this.store,
            listeners: {
                'selectionchange': { fn: this.showDetails, scope: this, buffer: 100 },
                'loadexception': { fn: this.onLoadException, scope: this }
    	 		, afterrender: function(grid) {tempgrid=grid;setTimeout("tempgrid.select(0)",500)}
            },
            prepareData: formatData.createDelegate(this)
        });
        return this.view;

    },

    initTemplates: function() {
        if (this.displayStyle == "list") {
            this.thumbTemplate = new Ext.XTemplate(
	                    '<tpl for=".">',
		                    '<div class="list-wrap" id="{Name}">',
		                    '<div class="list"><img  title="{Name}"></div>',
		                    '<span>{shortName}</span></div>',
	                    '</tpl>'
                    );
            this.thumbTemplate.compile();
        }
        else {
            this.thumbTemplate = new Ext.XTemplate(
	                    '<tpl for=".">',
		                    '<div class="thumb-wrap" id="{Name}">',
		                    '<div class="thumb"><img  src="'+CIFORCE_RES_PATH+'/images/ci/{Image}_32.png"></div>',
		                    '<span>{shortName}</span></div>',
	                    '</tpl>'
                    );
            this.thumbTemplate.compile();
        }
    },

    showDetails: function() {
        var selNode = this.view.getSelectedNodes();

        if (selNode && selNode.length > 0) {
	            selNode = selNode[0];
	            var data = this.lookup[selNode.id];
				isabstract = data.Abstract;
				if(data.Abstract || (typeof(iscreatable) != 'undefined' &&  iscreatable != 'undefined' && iscreatable != null  && !iscreatable)){
					if(Ext.getCmp('newInstanceBtn') != null && Ext.getCmp('newInstanceBtn') != 'undefined' ){
						Ext.getCmp('newInstanceBtn').disable();
						Ext.getCmp('newInstanceBtn').setIconClass('bmcNewDisable');
					}	
				}else if(typeof(iscreatable) != 'undefined' &&  iscreatable != 'undefined' && iscreatable != null && iscreatable){
					if(Ext.getCmp('newInstanceBtn') != null && Ext.getCmp('newInstanceBtn') != 'undefined' ){
						Ext.getCmp('newInstanceBtn').enable();
						Ext.getCmp('newInstanceBtn').setIconClass('bmcNew');
					}
				}
				if (this.ItemClickHandler){
					this.ItemClickHandler(data.Name);
				}
        }

    },

    onLoadException: function(v, o) {
        this.view.getEl().update('<div style="padding:10px;">Error loading data.</div>');
    }
};

String.prototype.ellipse = function(maxLength){
    if(this.length > maxLength){
        return this.substr(0, maxLength-3) + '...';
    }
    return this;
};


var CMDBTypeIcons = function(ItemClickHandler) {
    this.ItemClickHandler=ItemClickHandler;
    return this.getElement();
}

CMDBTypeIcons.prototype = {

    lookup: {},
    getElement: function() {
        var thumbTemplate = new Ext.XTemplate(
	                                '<tpl for=".">',
		                                '<div class="thumb-wrap" id="{name}" title="{tooltip}">',
		                                '<div class="{name}ViewTabHeader" id="{name}Id">&nbsp;</div>',
		                                '</div>',
	                                '</tpl>'
                                );
        thumbTemplate.compile();

        var objData = [{ name: 'tile', index: 0, tooltip:_ServerValues.TileViewLabel }, { name: 'list', index: 1, tooltip:_ServerValues.ListViewLabel }, { name: 'tree', index: 2, tooltip:_ServerValues.TreeViewLabel}];

        var typeStore = new Ext.data.JsonStore({
            data: objData,
            autoDestroy: true,
            idProperty: 'name',
            fields: ['name', 'index', 'tooltip']
        });

        var formatData = function(data) {
            this.lookup[data.name] = data;
            return data;
        };

        var viewItemSelector = 'div.thumb-wrap';
        
        
        
        this.view = new Ext.DataView({
            id: 'ClassViewChoser',
            tpl: thumbTemplate,
            singleSelect: true,
            border: 0,
            height:24,
            overClass: 'x-view-over',
            itemSelector: viewItemSelector,
            store: typeStore,
            listeners: {
                'selectionchange': { fn: this.showDetails, scope: this, buffer: 100 },
                afterrender: function(grid) { grid.select(2); }
            },
            prepareData: formatData.createDelegate(this)
        });
        
        return this.view;
    },
    showDetails: function() {
        var selNode = this.view.getSelectedNodes();
        if (selNode && selNode.length > 0) {
            selNode = selNode[0];
            var data = this.lookup[selNode.id];
            if (this.ItemClickHandler) { this.ItemClickHandler(data.name, data.index); }
        }

    }
}