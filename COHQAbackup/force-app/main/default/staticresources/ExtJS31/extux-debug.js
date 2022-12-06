/*!
 * Ext JS Library 3.1.1
 * Copyright(c) 2006-2010 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
Ext.ux.Portal = Ext.extend(Ext.Panel, {
    layout : 'column',
    autoScroll : true,
    cls : 'x-portal',
    defaultType : 'portalcolumn',
    
    initComponent : function(){
        Ext.ux.Portal.superclass.initComponent.call(this);
        this.addEvents({
            validatedrop:true,
            beforedragover:true,
            dragover:true,
            beforedrop:true,
            drop:true
        });
    },

    initEvents : function(){
        Ext.ux.Portal.superclass.initEvents.call(this);
        this.dd = new Ext.ux.Portal.DropZone(this, this.dropConfig);
    },
    
    beforeDestroy : function() {
        if(this.dd){
            this.dd.unreg();
        }
        Ext.ux.Portal.superclass.beforeDestroy.call(this);
    }
});

Ext.reg('portal', Ext.ux.Portal);


Ext.ux.Portal.DropZone = function(portal, cfg){
    this.portal = portal;
    Ext.dd.ScrollManager.register(portal.body);
    Ext.ux.Portal.DropZone.superclass.constructor.call(this, portal.bwrap.dom, cfg);
    portal.body.ddScrollConfig = this.ddScrollConfig;
};

Ext.extend(Ext.ux.Portal.DropZone, Ext.dd.DropTarget, {
    ddScrollConfig : {
        vthresh: 50,
        hthresh: -1,
        animate: true,
        increment: 200
    },

    createEvent : function(dd, e, data, col, c, pos){
        return {
            portal: this.portal,
            panel: data.panel,
            columnIndex: col,
            column: c,
            position: pos,
            data: data,
            source: dd,
            rawEvent: e,
            status: this.dropAllowed
        };
    },

    notifyOver : function(dd, e, data){
        var xy = e.getXY(), portal = this.portal, px = dd.proxy;

        // case column widths
        if(!this.grid){
            this.grid = this.getGrid();
        }

        // handle case scroll where scrollbars appear during drag
        var cw = portal.body.dom.clientWidth;
        if(!this.lastCW){
            this.lastCW = cw;
        }else if(this.lastCW != cw){
            this.lastCW = cw;
            portal.doLayout();
            this.grid = this.getGrid();
        }

        // determine column
        var col = 0, xs = this.grid.columnX, cmatch = false;
        for(var len = xs.length; col < len; col++){
            if(xy[0] < (xs[col].x + xs[col].w)){
                cmatch = true;
                break;
            }
        }
        // no match, fix last index
        if(!cmatch){
            col--;
        }

        // find insert position
        var p, match = false, pos = 0,
            c = portal.items.itemAt(col),
            items = c.items.items, overSelf = false;

        for(var len = items.length; pos < len; pos++){
            p = items[pos];
            var h = p.el.getHeight();
            if(h === 0){
                overSelf = true;
            }
            else if((p.el.getY()+(h/2)) > xy[1]){
                match = true;
                break;
            }
        }

        pos = (match && p ? pos : c.items.getCount()) + (overSelf ? -1 : 0);
        var overEvent = this.createEvent(dd, e, data, col, c, pos);

        if(portal.fireEvent('validatedrop', overEvent) !== false &&
           portal.fireEvent('beforedragover', overEvent) !== false){

            // make sure proxy width is fluid
            px.getProxy().setWidth('auto');

            if(p){
                px.moveProxy(p.el.dom.parentNode, match ? p.el.dom : null);
            }else{
                px.moveProxy(c.el.dom, null);
            }

            this.lastPos = {c: c, col: col, p: overSelf || (match && p) ? pos : false};
            this.scrollPos = portal.body.getScroll();

            portal.fireEvent('dragover', overEvent);

            return overEvent.status;
        }else{
            return overEvent.status;
        }

    },

    notifyOut : function(){
        delete this.grid;
    },

    notifyDrop : function(dd, e, data){
        delete this.grid;
        if(!this.lastPos){
            return;
        }
        var c = this.lastPos.c, col = this.lastPos.col, pos = this.lastPos.p;

        var dropEvent = this.createEvent(dd, e, data, col, c,
            pos !== false ? pos : c.items.getCount());

        if(this.portal.fireEvent('validatedrop', dropEvent) !== false &&
           this.portal.fireEvent('beforedrop', dropEvent) !== false){

            dd.proxy.getProxy().remove();
            dd.panel.el.dom.parentNode.removeChild(dd.panel.el.dom);
            
            if(pos !== false){
                if(c == dd.panel.ownerCt && (c.items.items.indexOf(dd.panel) <= pos)){
                    pos++;
                }
                c.insert(pos, dd.panel);
            }else{
                c.add(dd.panel);
            }
            
            c.doLayout();

            this.portal.fireEvent('drop', dropEvent);

            // scroll position is lost on drop, fix it
            var st = this.scrollPos.top;
            if(st){
                var d = this.portal.body.dom;
                setTimeout(function(){
                    d.scrollTop = st;
                }, 10);
            }

        }
        delete this.lastPos;
    },

    // internal cache of body and column coords
    getGrid : function(){
        var box = this.portal.bwrap.getBox();
        box.columnX = [];
        this.portal.items.each(function(c){
             box.columnX.push({x: c.el.getX(), w: c.el.getWidth()});
        });
        return box;
    },

    // unregister the dropzone from ScrollManager
    unreg: function() {
        //Ext.dd.ScrollManager.unregister(this.portal.body);
        Ext.ux.Portal.DropZone.superclass.unreg.call(this);
    }
});
/*!
 * Ext JS Library 3.1.1
 * Copyright(c) 2006-2010 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
Ext.ux.PortalColumn = Ext.extend(Ext.Container, {
    layout : 'anchor',
    //autoEl : 'div',//already defined by Ext.Component
    defaultType : 'portlet',
    cls : 'x-portal-column'
});

Ext.reg('portalcolumn', Ext.ux.PortalColumn);
/*!
 * Ext JS Library 3.1.1
 * Copyright(c) 2006-2010 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
Ext.ux.Portlet = Ext.extend(Ext.Panel, {
    anchor : '100%',
    frame : true,
    collapsible : true,
    draggable : true,
    cls : 'x-portlet'
});

Ext.reg('portlet', Ext.ux.Portlet);
/*!
 * Ext JS Library 3.1.1
 * Copyright(c) 2006-2010 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
Ext.ux.GroupTab = Ext.extend(Ext.Container, {
    mainItem: 0,
    
    expanded: true,
    
    deferredRender: true,
    
    activeTab: null,
    
    idDelimiter: '__',
    
    headerAsText: false,
    
    frame: false,
    
    hideBorders: true,
    
    initComponent: function(config){
        Ext.apply(this, config);
        this.frame = false;
        
        Ext.ux.GroupTab.superclass.initComponent.call(this);
        
        this.addEvents('activate', 'deactivate', 'changemainitem', 'beforetabchange', 'tabchange');
        
        this.setLayout(new Ext.layout.CardLayout({
            deferredRender: this.deferredRender
        }));
        
        if (!this.stack) {
            this.stack = Ext.TabPanel.AccessStack();
        }
        
        this.initItems();
        
        this.on('beforerender', function(){
            this.groupEl = this.ownerCt.getGroupEl(this);
        }, this);
        
        this.on('add', this.onAdd, this, {
            target: this
        });
        this.on('remove', this.onRemove, this, {
            target: this
        });
        
        if (this.mainItem !== undefined) {
            var item = (typeof this.mainItem == 'object') ? this.mainItem : this.items.get(this.mainItem);
            delete this.mainItem;
            this.setMainItem(item);
        }
    },
    
    /**
     * Sets the specified tab as the active tab. This method fires the {@link #beforetabchange} event which
     * can return false to cancel the tab change.
     * @param {String/Panel} tab The id or tab Panel to activate
     */
    setActiveTab : function(item){
        item = this.getComponent(item);
        if(!item){
            return false;
        }
        if(!this.rendered){
            this.activeTab = item;
            return true;
        }
        if(this.activeTab != item && this.fireEvent('beforetabchange', this, item, this.activeTab) !== false){
            if(this.activeTab && this.activeTab != this.mainItem){
                var oldEl = this.getTabEl(this.activeTab);
                if(oldEl){
                    Ext.fly(oldEl).removeClass('x-grouptabs-strip-active');
                }
            }
            var el = this.getTabEl(item);
            Ext.fly(el).addClass('x-grouptabs-strip-active');
            this.activeTab = item;
            this.stack.add(item);

            this.layout.setActiveItem(item);
            if(this.layoutOnTabChange && item.doLayout){
                item.doLayout();
            }
            if(this.scrolling){
                this.scrollToTab(item, this.animScroll);
            }

            this.fireEvent('tabchange', this, item);
            return true;
        }
        return false;
    },
    
    getTabEl: function(item){
        if (item == this.mainItem) {
            return this.groupEl;
        }
        return Ext.TabPanel.prototype.getTabEl.call(this, item);
    },
    
    onRender: function(ct, position){
        Ext.ux.GroupTab.superclass.onRender.call(this, ct, position);
        
        this.strip = Ext.fly(this.groupEl).createChild({
            tag: 'ul',
            cls: 'x-grouptabs-sub'
        });

        this.tooltip = new Ext.ToolTip({
           target: this.groupEl,
           delegate: 'a.x-grouptabs-text',
           trackMouse: true,
           renderTo: document.body,
           listeners: {
               beforeshow: function(tip) {
                   var item = (tip.triggerElement.parentNode === this.mainItem.tabEl)
                       ? this.mainItem
                       : this.findById(tip.triggerElement.parentNode.id.split(this.idDelimiter)[1]);

                   if(!item.tabTip) {
                       return false;
                   }
                   tip.body.dom.innerHTML = item.tabTip;
               },
               scope: this
           }
        });
                
        if (!this.itemTpl) {
            var tt = new Ext.Template('<li class="{cls}" id="{id}">', '<a onclick="return false;" class="x-grouptabs-text {iconCls}">{text}</a>', '</li>');
            tt.disableFormats = true;
            tt.compile();
            Ext.ux.GroupTab.prototype.itemTpl = tt;
        }
        
        this.items.each(this.initTab, this);
    },
    
    afterRender: function(){
        Ext.ux.GroupTab.superclass.afterRender.call(this);
        
        if (this.activeTab !== undefined) {
            var item = (typeof this.activeTab == 'object') ? this.activeTab : this.items.get(this.activeTab);
            delete this.activeTab;
            this.setActiveTab(item);
        }
    },
    
    // private
    initTab: function(item, index){
        var before = this.strip.dom.childNodes[index];
        var p = Ext.TabPanel.prototype.getTemplateArgs.call(this, item);
        
        if (item === this.mainItem) {
            item.tabEl = this.groupEl;
            p.cls += ' x-grouptabs-main-item';
        }
        
        var el = before ? this.itemTpl.insertBefore(before, p) : this.itemTpl.append(this.strip, p);
        
        item.tabEl = item.tabEl || el;
                
        item.on('disable', this.onItemDisabled, this);
        item.on('enable', this.onItemEnabled, this);
        item.on('titlechange', this.onItemTitleChanged, this);
        item.on('iconchange', this.onItemIconChanged, this);
        item.on('beforeshow', this.onBeforeShowItem, this);
    },
    
    setMainItem: function(item){
        item = this.getComponent(item);
        if (!item || this.fireEvent('changemainitem', this, item, this.mainItem) === false) {
            return;
        }
        
        this.mainItem = item;
    },
    
    getMainItem: function(){
        return this.mainItem || null;
    },
    
    // private
    onBeforeShowItem: function(item){
        if (item != this.activeTab) {
            this.setActiveTab(item);
            return false;
        }
    },
    
    // private
    onAdd: function(gt, item, index){
        if (this.rendered) {
            this.initTab.call(this, item, index);
        }
    },
    
    // private
    onRemove: function(tp, item){
        Ext.destroy(Ext.get(this.getTabEl(item)));
        this.stack.remove(item);
        item.un('disable', this.onItemDisabled, this);
        item.un('enable', this.onItemEnabled, this);
        item.un('titlechange', this.onItemTitleChanged, this);
        item.un('iconchange', this.onItemIconChanged, this);
        item.un('beforeshow', this.onBeforeShowItem, this);
        if (item == this.activeTab) {
            var next = this.stack.next();
            if (next) {
                this.setActiveTab(next);
            }
            else if (this.items.getCount() > 0) {
                this.setActiveTab(0);
            }
            else {
                this.activeTab = null;
            }
        }
    },
    
    // private
    onBeforeAdd: function(item){
        var existing = item.events ? (this.items.containsKey(item.getItemId()) ? item : null) : this.items.get(item);
        if (existing) {
            this.setActiveTab(item);
            return false;
        }
        Ext.TabPanel.superclass.onBeforeAdd.apply(this, arguments);
        var es = item.elements;
        item.elements = es ? es.replace(',header', '') : es;
        item.border = (item.border === true);
    },
    
    // private
    onItemDisabled: Ext.TabPanel.prototype.onItemDisabled,
    onItemEnabled: Ext.TabPanel.prototype.onItemEnabled,
    
    // private
    onItemTitleChanged: function(item){
        var el = this.getTabEl(item);
        if (el) {
            Ext.fly(el).child('a.x-grouptabs-text', true).innerHTML = item.title;
        }
    },
    
    //private
    onItemIconChanged: function(item, iconCls, oldCls){
        var el = this.getTabEl(item);
        if (el) {
            Ext.fly(el).child('a.x-grouptabs-text').replaceClass(oldCls, iconCls);
        }
    },
    
    beforeDestroy: function(){
        Ext.TabPanel.prototype.beforeDestroy.call(this);
        this.tooltip.destroy();
    }
});

Ext.reg('grouptab', Ext.ux.GroupTab);
/*!
 * Ext JS Library 3.1.1
 * Copyright(c) 2006-2010 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
Ext.ns('Ext.ux');

Ext.ux.GroupTabPanel = Ext.extend(Ext.TabPanel, {
    tabPosition: 'left',
    
    alternateColor: false,
    
    alternateCls: 'x-grouptabs-panel-alt',
    
    defaultType: 'grouptab',
    
    deferredRender: false,
    
    activeGroup : null,
    
    initComponent: function(){
        Ext.ux.GroupTabPanel.superclass.initComponent.call(this);
        
        this.addEvents(
            'beforegroupchange',
            'groupchange'
        );
        this.elements = 'body,header';
        this.stripTarget = 'header';
        
        this.tabPosition = this.tabPosition == 'right' ? 'right' : 'left';
        
        this.addClass('x-grouptabs-panel');
        
        if (this.tabStyle && this.tabStyle != '') {
            this.addClass('x-grouptabs-panel-' + this.tabStyle);
        }
        
        if (this.alternateColor) {
            this.addClass(this.alternateCls);
        }
        
        this.on('beforeadd', function(gtp, item, index){
            this.initGroup(item, index);
        });		     
    },
    
    initEvents : function() {
        this.mon(this.strip, 'mousedown', this.onStripMouseDown, this);
    },
        
    onRender: function(ct, position){
        Ext.TabPanel.superclass.onRender.call(this, ct, position);
        if(this.plain){
            var pos = this.tabPosition == 'top' ? 'header' : 'footer';
            this[pos].addClass('x-tab-panel-'+pos+'-plain');
        }

        var st = this[this.stripTarget];

        this.stripWrap = st.createChild({cls:'x-tab-strip-wrap ', cn:{
            tag:'ul', cls:'x-grouptabs-strip x-grouptabs-tab-strip-'+this.tabPosition}});

        var beforeEl = (this.tabPosition=='bottom' ? this.stripWrap : null);
        this.strip = new Ext.Element(this.stripWrap.dom.firstChild);

		this.header.addClass('x-grouptabs-panel-header');
		this.bwrap.addClass('x-grouptabs-bwrap');
        this.body.addClass('x-tab-panel-body-'+this.tabPosition + ' x-grouptabs-panel-body');

        if (!this.groupTpl) {
            var tt = new Ext.Template(
                '<li class="{cls}" id="{id}">', 
                '<a class="x-grouptabs-expand" onclick="return false;"></a>', 
                '<a class="x-grouptabs-text {iconCls}" href="#" onclick="return false;">',
                '<span>{text}</span></a>', 
                '</li>'
            );
            tt.disableFormats = true;
            tt.compile();
            Ext.ux.GroupTabPanel.prototype.groupTpl = tt;
        }
        this.items.each(this.initGroup, this);
    },
    
    afterRender: function(){
        Ext.ux.GroupTabPanel.superclass.afterRender.call(this);
        
        this.tabJoint = Ext.fly(this.body.dom.parentNode).createChild({
            cls: 'x-tab-joint'
        });
        
        this.addClass('x-tab-panel-' + this.tabPosition);
        this.header.setWidth(this.tabWidth);
        
        if (this.activeGroup !== undefined) {
            var group = (typeof this.activeGroup == 'object') ? this.activeGroup : this.items.get(this.activeGroup);
            delete this.activeGroup;
            this.setActiveGroup(group);
            group.setActiveTab(group.getMainItem());
        }
    },

    getGroupEl : Ext.TabPanel.prototype.getTabEl,
        
    // private
    findTargets: function(e){
        var item = null,
            itemEl = e.getTarget('li', this.strip);
        if (itemEl) {
            item = this.findById(itemEl.id.split(this.idDelimiter)[1]);
            if (item.disabled) {
                return {
                    expand: null,
                    item: null,
                    el: null
                };
            }
        }
        return {
            expand: e.getTarget('.x-grouptabs-expand', this.strip),
            isGroup: !e.getTarget('ul.x-grouptabs-sub', this.strip),
            item: item,
            el: itemEl
        };
    },
    
    // private
    onStripMouseDown: function(e){
        if (e.button != 0) {
            return;
        }
        e.preventDefault();
        var t = this.findTargets(e);
        if (t.expand) {
            this.toggleGroup(t.el);
        }
        else if (t.item) {
            if(t.isGroup) {
                t.item.setActiveTab(t.item.getMainItem());
            }
            else {
                t.item.ownerCt.setActiveTab(t.item);
            }
        }
    },
    
    expandGroup: function(groupEl){
        if(groupEl.isXType) {
            groupEl = this.getGroupEl(groupEl);
        }
        Ext.fly(groupEl).addClass('x-grouptabs-expanded');
		this.syncTabJoint();
    },
    
    toggleGroup: function(groupEl){
        if(groupEl.isXType) {
            groupEl = this.getGroupEl(groupEl);
        }        
        Ext.fly(groupEl).toggleClass('x-grouptabs-expanded');
		this.syncTabJoint();
    },    

    collapseGroup: function(groupEl){
        if(groupEl.isXType) {
            groupEl = this.getGroupEl(groupEl);
        }
        Ext.fly(groupEl).removeClass('x-grouptabs-expanded');
		this.syncTabJoint();
    },
        
    syncTabJoint: function(groupEl){
        if (!this.tabJoint) {
            return;
        }
        
        groupEl = groupEl || this.getGroupEl(this.activeGroup);
        if(groupEl) {
            this.tabJoint.setHeight(Ext.fly(groupEl).getHeight() - 2); 
			
            var y = Ext.isGecko2 ? 0 : 1;
            if (this.tabPosition == 'left'){
                this.tabJoint.alignTo(groupEl, 'tl-tr', [-2,y]);
            }
            else {
                this.tabJoint.alignTo(groupEl, 'tr-tl', [1,y]);
            }           
        }
        else {
            this.tabJoint.hide();
        }
    },
    
    getActiveTab : function() {
        if(!this.activeGroup) return null;
        return this.activeGroup.getTabEl(this.activeGroup.activeTab) || null;  
    },
    
    onResize: function(){
        Ext.ux.GroupTabPanel.superclass.onResize.apply(this, arguments);
        this.syncTabJoint();
    },
    
    createCorner: function(el, pos){
        return Ext.fly(el).createChild({
            cls: 'x-grouptabs-corner x-grouptabs-corner-' + pos
        });
    },
    
    initGroup: function(group, index){
        var before = this.strip.dom.childNodes[index],   
            p = this.getTemplateArgs(group);
        if (index === 0) {
            p.cls += ' x-tab-first';
        }
        p.cls += ' x-grouptabs-main';
        p.text = group.getMainItem().title;
        
        var el = before ? this.groupTpl.insertBefore(before, p) : this.groupTpl.append(this.strip, p),
            tl = this.createCorner(el, 'top-' + this.tabPosition),
            bl = this.createCorner(el, 'bottom-' + this.tabPosition);

        group.tabEl = el;
        if (group.expanded) {
            this.expandGroup(el);
        }

        if (Ext.isIE6 || (Ext.isIE && !Ext.isStrict)){
            bl.setLeft('-10px');
            bl.setBottom('-5px');
            tl.setLeft('-10px');
            tl.setTop('-5px');
        }

        this.mon(group, {
            scope: this,
            changemainitem: this.onGroupChangeMainItem,
            beforetabchange: this.onGroupBeforeTabChange
        });
    },
    
    setActiveGroup : function(group) {
        group = this.getComponent(group);
        if(!group){
            return false;
        }
        if(!this.rendered){
            this.activeGroup = group;
            return true;
        }
        if(this.activeGroup != group && this.fireEvent('beforegroupchange', this, group, this.activeGroup) !== false){
            if(this.activeGroup){
                this.activeGroup.activeTab = null;
                var oldEl = this.getGroupEl(this.activeGroup);
                if(oldEl){
                    Ext.fly(oldEl).removeClass('x-grouptabs-strip-active');
                }
            }

            var groupEl = this.getGroupEl(group);
            Ext.fly(groupEl).addClass('x-grouptabs-strip-active');
                        
            this.activeGroup = group;
            this.stack.add(group);

            this.layout.setActiveItem(group);
            this.syncTabJoint(groupEl);

            this.fireEvent('groupchange', this, group);
            return true;
        }
        return false; 
    },
    
    onGroupBeforeTabChange: function(group, newTab, oldTab){
        if(group !== this.activeGroup || newTab !== oldTab) {
            this.strip.select('.x-grouptabs-sub > li.x-grouptabs-strip-active', true).removeClass('x-grouptabs-strip-active');
        } 
        this.expandGroup(this.getGroupEl(group));
        if(group !== this.activeGroup) {
            return this.setActiveGroup(group);
        }        
    },
    
    getFrameHeight: function(){
        var h = this.el.getFrameWidth('tb');
        h += (this.tbar ? this.tbar.getHeight() : 0) +
        (this.bbar ? this.bbar.getHeight() : 0);
        
        return h;
    },
    
    adjustBodyWidth: function(w){
        return w - this.tabWidth;
    }
});

Ext.reg('grouptabpanel', Ext.ux.GroupTabPanel);