/*
 * Ext JS Library 3.1.1
 * Copyright(c) 2006-2010 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
Ext.ux.Portal=Ext.extend(Ext.Panel,{layout:"column",autoScroll:true,cls:"x-portal",defaultType:"portalcolumn",initComponent:function(){Ext.ux.Portal.superclass.initComponent.call(this);
this.addEvents({validatedrop:true,beforedragover:true,dragover:true,beforedrop:true,drop:true})
},initEvents:function(){Ext.ux.Portal.superclass.initEvents.call(this);
this.dd=new Ext.ux.Portal.DropZone(this,this.dropConfig)
},beforeDestroy:function(){if(this.dd){this.dd.unreg()
}Ext.ux.Portal.superclass.beforeDestroy.call(this)
}});
Ext.reg("portal",Ext.ux.Portal);
Ext.ux.Portal.DropZone=function(a,b){this.portal=a;
Ext.dd.ScrollManager.register(a.body);
Ext.ux.Portal.DropZone.superclass.constructor.call(this,a.bwrap.dom,b);
a.body.ddScrollConfig=this.ddScrollConfig
};
Ext.extend(Ext.ux.Portal.DropZone,Ext.dd.DropTarget,{ddScrollConfig:{vthresh:50,hthresh:-1,animate:true,increment:200},createEvent:function(a,f,d,b,h,g){return{portal:this.portal,panel:d.panel,columnIndex:b,column:h,position:g,data:d,source:a,rawEvent:f,status:this.dropAllowed}
},notifyOver:function(v,t,w){var f=t.getXY(),a=this.portal,n=v.proxy;
if(!this.grid){this.grid=this.getGrid()
}var b=a.body.dom.clientWidth;
if(!this.lastCW){this.lastCW=b
}else{if(this.lastCW!=b){this.lastCW=b;
a.doLayout();
this.grid=this.getGrid()
}}var d=0,l=this.grid.columnX,m=false;
for(var s=l.length;
d<s;
d++){if(f[0]<(l[d].x+l[d].w)){m=true;
break
}}if(!m){d--
}var q,k=false,i=0,u=a.items.itemAt(d),o=u.items.items,j=false;
for(var s=o.length;
i<s;
i++){q=o[i];
var r=q.el.getHeight();
if(r===0){j=true
}else{if((q.el.getY()+(r/2))>f[1]){k=true;
break
}}}i=(k&&q?i:u.items.getCount())+(j?-1:0);
var g=this.createEvent(v,t,w,d,u,i);
if(a.fireEvent("validatedrop",g)!==false&&a.fireEvent("beforedragover",g)!==false){n.getProxy().setWidth("auto");
if(q){n.moveProxy(q.el.dom.parentNode,k?q.el.dom:null)
}else{n.moveProxy(u.el.dom,null)
}this.lastPos={c:u,col:d,p:j||(k&&q)?i:false};
this.scrollPos=a.body.getScroll();
a.fireEvent("dragover",g);
return g.status
}else{return g.status
}},notifyOut:function(){delete this.grid
},notifyDrop:function(k,g,f){delete this.grid;
if(!this.lastPos){return
}var i=this.lastPos.c,b=this.lastPos.col,j=this.lastPos.p;
var a=this.createEvent(k,g,f,b,i,j!==false?j:i.items.getCount());
if(this.portal.fireEvent("validatedrop",a)!==false&&this.portal.fireEvent("beforedrop",a)!==false){k.proxy.getProxy().remove();
k.panel.el.dom.parentNode.removeChild(k.panel.el.dom);
if(j!==false){if(i==k.panel.ownerCt&&(i.items.items.indexOf(k.panel)<=j)){j++
}i.insert(j,k.panel)
}else{i.add(k.panel)
}i.doLayout();
this.portal.fireEvent("drop",a);
var l=this.scrollPos.top;
if(l){var h=this.portal.body.dom;
setTimeout(function(){h.scrollTop=l
},10)
}}delete this.lastPos
},getGrid:function(){var a=this.portal.bwrap.getBox();
a.columnX=[];
this.portal.items.each(function(b){a.columnX.push({x:b.el.getX(),w:b.el.getWidth()})
});
return a
},unreg:function(){Ext.ux.Portal.DropZone.superclass.unreg.call(this)
}});
/*
 * Ext JS Library 3.1.1
 * Copyright(c) 2006-2010 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
Ext.ux.PortalColumn=Ext.extend(Ext.Container,{layout:"anchor",defaultType:"portlet",cls:"x-portal-column"});
Ext.reg("portalcolumn",Ext.ux.PortalColumn);
/*
 * Ext JS Library 3.1.1
 * Copyright(c) 2006-2010 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
Ext.ux.Portlet=Ext.extend(Ext.Panel,{anchor:"100%",frame:true,collapsible:true,draggable:true,cls:"x-portlet"});
Ext.reg("portlet",Ext.ux.Portlet);
/*
 * Ext JS Library 3.1.1
 * Copyright(c) 2006-2010 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
Ext.ux.GroupTab=Ext.extend(Ext.Container,{mainItem:0,expanded:true,deferredRender:true,activeTab:null,idDelimiter:"__",headerAsText:false,frame:false,hideBorders:true,initComponent:function(a){Ext.apply(this,a);
this.frame=false;
Ext.ux.GroupTab.superclass.initComponent.call(this);
this.addEvents("activate","deactivate","changemainitem","beforetabchange","tabchange");
this.setLayout(new Ext.layout.CardLayout({deferredRender:this.deferredRender}));
if(!this.stack){this.stack=Ext.TabPanel.AccessStack()
}this.initItems();
this.on("beforerender",function(){this.groupEl=this.ownerCt.getGroupEl(this)
},this);
this.on("add",this.onAdd,this,{target:this});
this.on("remove",this.onRemove,this,{target:this});
if(this.mainItem!==undefined){var b=(typeof this.mainItem=="object")?this.mainItem:this.items.get(this.mainItem);
delete this.mainItem;
this.setMainItem(b)
}},setActiveTab:function(c){c=this.getComponent(c);
if(!c){return false
}if(!this.rendered){this.activeTab=c;
return true
}if(this.activeTab!=c&&this.fireEvent("beforetabchange",this,c,this.activeTab)!==false){if(this.activeTab&&this.activeTab!=this.mainItem){var a=this.getTabEl(this.activeTab);
if(a){Ext.fly(a).removeClass("x-grouptabs-strip-active")
}}var b=this.getTabEl(c);
Ext.fly(b).addClass("x-grouptabs-strip-active");
this.activeTab=c;
this.stack.add(c);
this.layout.setActiveItem(c);
if(this.layoutOnTabChange&&c.doLayout){c.doLayout()
}if(this.scrolling){this.scrollToTab(c,this.animScroll)
}this.fireEvent("tabchange",this,c);
return true
}return false
},getTabEl:function(a){if(a==this.mainItem){return this.groupEl
}return Ext.TabPanel.prototype.getTabEl.call(this,a)
},onRender:function(b,a){Ext.ux.GroupTab.superclass.onRender.call(this,b,a);
this.strip=Ext.fly(this.groupEl).createChild({tag:"ul",cls:"x-grouptabs-sub"});
this.tooltip=new Ext.ToolTip({target:this.groupEl,delegate:"a.x-grouptabs-text",trackMouse:true,renderTo:document.body,listeners:{beforeshow:function(e){var d=(e.triggerElement.parentNode===this.mainItem.tabEl)?this.mainItem:this.findById(e.triggerElement.parentNode.id.split(this.idDelimiter)[1]);
if(!d.tabTip){return false
}e.body.dom.innerHTML=d.tabTip
},scope:this}});
if(!this.itemTpl){var c=new Ext.Template('<li class="{cls}" id="{id}">','<a onclick="return false;" class="x-grouptabs-text {iconCls}">{text}</a>',"</li>");
c.disableFormats=true;
c.compile();
Ext.ux.GroupTab.prototype.itemTpl=c
}this.items.each(this.initTab,this)
},afterRender:function(){Ext.ux.GroupTab.superclass.afterRender.call(this);
if(this.activeTab!==undefined){var a=(typeof this.activeTab=="object")?this.activeTab:this.items.get(this.activeTab);
delete this.activeTab;
this.setActiveTab(a)
}},initTab:function(c,a){var d=this.strip.dom.childNodes[a];
var e=Ext.TabPanel.prototype.getTemplateArgs.call(this,c);
if(c===this.mainItem){c.tabEl=this.groupEl;
e.cls+=" x-grouptabs-main-item"
}var b=d?this.itemTpl.insertBefore(d,e):this.itemTpl.append(this.strip,e);
c.tabEl=c.tabEl||b;
c.on("disable",this.onItemDisabled,this);
c.on("enable",this.onItemEnabled,this);
c.on("titlechange",this.onItemTitleChanged,this);
c.on("iconchange",this.onItemIconChanged,this);
c.on("beforeshow",this.onBeforeShowItem,this)
},setMainItem:function(a){a=this.getComponent(a);
if(!a||this.fireEvent("changemainitem",this,a,this.mainItem)===false){return
}this.mainItem=a
},getMainItem:function(){return this.mainItem||null
},onBeforeShowItem:function(a){if(a!=this.activeTab){this.setActiveTab(a);
return false
}},onAdd:function(a,c,b){if(this.rendered){this.initTab.call(this,c,b)
}},onRemove:function(c,b){Ext.destroy(Ext.get(this.getTabEl(b)));
this.stack.remove(b);
b.un("disable",this.onItemDisabled,this);
b.un("enable",this.onItemEnabled,this);
b.un("titlechange",this.onItemTitleChanged,this);
b.un("iconchange",this.onItemIconChanged,this);
b.un("beforeshow",this.onBeforeShowItem,this);
if(b==this.activeTab){var a=this.stack.next();
if(a){this.setActiveTab(a)
}else{if(this.items.getCount()>0){this.setActiveTab(0)
}else{this.activeTab=null
}}}},onBeforeAdd:function(b){var a=b.events?(this.items.containsKey(b.getItemId())?b:null):this.items.get(b);
if(a){this.setActiveTab(b);
return false
}Ext.TabPanel.superclass.onBeforeAdd.apply(this,arguments);
var c=b.elements;
b.elements=c?c.replace(",header",""):c;
b.border=(b.border===true)
},onItemDisabled:Ext.TabPanel.prototype.onItemDisabled,onItemEnabled:Ext.TabPanel.prototype.onItemEnabled,onItemTitleChanged:function(b){var a=this.getTabEl(b);
if(a){Ext.fly(a).child("a.x-grouptabs-text",true).innerHTML=b.title
}},onItemIconChanged:function(d,a,c){var b=this.getTabEl(d);
if(b){Ext.fly(b).child("a.x-grouptabs-text").replaceClass(c,a)
}},beforeDestroy:function(){Ext.TabPanel.prototype.beforeDestroy.call(this);
this.tooltip.destroy()
}});
Ext.reg("grouptab",Ext.ux.GroupTab);
/*
 * Ext JS Library 3.1.1
 * Copyright(c) 2006-2010 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
Ext.ns("Ext.ux");
Ext.ux.GroupTabPanel=Ext.extend(Ext.TabPanel,{tabPosition:"left",alternateColor:false,alternateCls:"x-grouptabs-panel-alt",defaultType:"grouptab",deferredRender:false,activeGroup:null,initComponent:function(){Ext.ux.GroupTabPanel.superclass.initComponent.call(this);
this.addEvents("beforegroupchange","groupchange");
this.elements="body,header";
this.stripTarget="header";
this.tabPosition=this.tabPosition=="right"?"right":"left";
this.addClass("x-grouptabs-panel");
if(this.tabStyle&&this.tabStyle!=""){this.addClass("x-grouptabs-panel-"+this.tabStyle)
}if(this.alternateColor){this.addClass(this.alternateCls)
}this.on("beforeadd",function(b,c,a){this.initGroup(c,a)
})
},initEvents:function(){this.mon(this.strip,"mousedown",this.onStripMouseDown,this)
},onRender:function(c,a){Ext.TabPanel.superclass.onRender.call(this,c,a);
if(this.plain){var f=this.tabPosition=="top"?"header":"footer";
this[f].addClass("x-tab-panel-"+f+"-plain")
}var b=this[this.stripTarget];
this.stripWrap=b.createChild({cls:"x-tab-strip-wrap ",cn:{tag:"ul",cls:"x-grouptabs-strip x-grouptabs-tab-strip-"+this.tabPosition}});
var e=(this.tabPosition=="bottom"?this.stripWrap:null);
this.strip=new Ext.Element(this.stripWrap.dom.firstChild);
this.header.addClass("x-grouptabs-panel-header");
this.bwrap.addClass("x-grouptabs-bwrap");
this.body.addClass("x-tab-panel-body-"+this.tabPosition+" x-grouptabs-panel-body");
if(!this.groupTpl){var d=new Ext.Template('<li class="{cls}" id="{id}">','<a class="x-grouptabs-expand" onclick="return false;"></a>','<a class="x-grouptabs-text {iconCls}" href="#" onclick="return false;">',"<span>{text}</span></a>","</li>");
d.disableFormats=true;
d.compile();
Ext.ux.GroupTabPanel.prototype.groupTpl=d
}this.items.each(this.initGroup,this)
},afterRender:function(){Ext.ux.GroupTabPanel.superclass.afterRender.call(this);
this.tabJoint=Ext.fly(this.body.dom.parentNode).createChild({cls:"x-tab-joint"});
this.addClass("x-tab-panel-"+this.tabPosition);
this.header.setWidth(this.tabWidth);
if(this.activeGroup!==undefined){var a=(typeof this.activeGroup=="object")?this.activeGroup:this.items.get(this.activeGroup);
delete this.activeGroup;
this.setActiveGroup(a);
a.setActiveTab(a.getMainItem())
}},getGroupEl:Ext.TabPanel.prototype.getTabEl,findTargets:function(c){var b=null,a=c.getTarget("li",this.strip);
if(a){b=this.findById(a.id.split(this.idDelimiter)[1]);
if(b.disabled){return{expand:null,item:null,el:null}
}}return{expand:c.getTarget(".x-grouptabs-expand",this.strip),isGroup:!c.getTarget("ul.x-grouptabs-sub",this.strip),item:b,el:a}
},onStripMouseDown:function(b){if(b.button!=0){return
}b.preventDefault();
var a=this.findTargets(b);
if(a.expand){this.toggleGroup(a.el)
}else{if(a.item){if(a.isGroup){a.item.setActiveTab(a.item.getMainItem())
}else{a.item.ownerCt.setActiveTab(a.item)
}}}},expandGroup:function(a){if(a.isXType){a=this.getGroupEl(a)
}Ext.fly(a).addClass("x-grouptabs-expanded");
this.syncTabJoint()
},toggleGroup:function(a){if(a.isXType){a=this.getGroupEl(a)
}Ext.fly(a).toggleClass("x-grouptabs-expanded");
this.syncTabJoint()
},collapseGroup:function(a){if(a.isXType){a=this.getGroupEl(a)
}Ext.fly(a).removeClass("x-grouptabs-expanded");
this.syncTabJoint()
},syncTabJoint:function(b){if(!this.tabJoint){return
}b=b||this.getGroupEl(this.activeGroup);
if(b){this.tabJoint.setHeight(Ext.fly(b).getHeight()-2);
var a=Ext.isGecko2?0:1;
if(this.tabPosition=="left"){this.tabJoint.alignTo(b,"tl-tr",[-2,a])
}else{this.tabJoint.alignTo(b,"tr-tl",[1,a])
}}else{this.tabJoint.hide()
}},getActiveTab:function(){if(!this.activeGroup){return null
}return this.activeGroup.getTabEl(this.activeGroup.activeTab)||null
},onResize:function(){Ext.ux.GroupTabPanel.superclass.onResize.apply(this,arguments);
this.syncTabJoint()
},createCorner:function(a,b){return Ext.fly(a).createChild({cls:"x-grouptabs-corner x-grouptabs-corner-"+b})
},initGroup:function(f,b){var d=this.strip.dom.childNodes[b],e=this.getTemplateArgs(f);
if(b===0){e.cls+=" x-tab-first"
}e.cls+=" x-grouptabs-main";
e.text=f.getMainItem().title;
var c=d?this.groupTpl.insertBefore(d,e):this.groupTpl.append(this.strip,e),a=this.createCorner(c,"top-"+this.tabPosition),g=this.createCorner(c,"bottom-"+this.tabPosition);
f.tabEl=c;
if(f.expanded){this.expandGroup(c)
}if(Ext.isIE6||(Ext.isIE&&!Ext.isStrict)){g.setLeft("-10px");
g.setBottom("-5px");
a.setLeft("-10px");
a.setTop("-5px")
}this.mon(f,{scope:this,changemainitem:this.onGroupChangeMainItem,beforetabchange:this.onGroupBeforeTabChange})
},setActiveGroup:function(b){b=this.getComponent(b);
if(!b){return false
}if(!this.rendered){this.activeGroup=b;
return true
}if(this.activeGroup!=b&&this.fireEvent("beforegroupchange",this,b,this.activeGroup)!==false){if(this.activeGroup){this.activeGroup.activeTab=null;
var a=this.getGroupEl(this.activeGroup);
if(a){Ext.fly(a).removeClass("x-grouptabs-strip-active")
}}var c=this.getGroupEl(b);
Ext.fly(c).addClass("x-grouptabs-strip-active");
this.activeGroup=b;
this.stack.add(b);
this.layout.setActiveItem(b);
this.syncTabJoint(c);
this.fireEvent("groupchange",this,b);
return true
}return false
},onGroupBeforeTabChange:function(a,c,b){if(a!==this.activeGroup||c!==b){this.strip.select(".x-grouptabs-sub > li.x-grouptabs-strip-active",true).removeClass("x-grouptabs-strip-active")
}this.expandGroup(this.getGroupEl(a));
if(a!==this.activeGroup){return this.setActiveGroup(a)
}},getFrameHeight:function(){var a=this.el.getFrameWidth("tb");
a+=(this.tbar?this.tbar.getHeight():0)+(this.bbar?this.bbar.getHeight():0);
return a
},adjustBodyWidth:function(a){return a-this.tabWidth
}});
Ext.reg("grouptabpanel",Ext.ux.GroupTabPanel);