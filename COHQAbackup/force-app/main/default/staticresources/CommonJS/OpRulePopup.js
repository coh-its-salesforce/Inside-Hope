
var root;
var tree;
var OpRuleTreePopUpWindow;
var height = 490;
var width= 700;
var forAcAction;
var selectedNode;
var CancleButton;
var OkButton;
var tabOutImg;

var closePopUpWindow= function(btn, text) {
                OpRuleTreePopUpWindow.close();
            }


function hideWaitMsg(){
	if(typeof(waitMsg) != 'undefined' && waitMsg != null && waitMsg != ''){
		waitMsg.hide();
	}
}
function waitbox(timeout){ 
	if(parseInt(timeout)>0) setTimeout("waitMsg.hide()", timeout);
	waitMsg = new Ext.Window({ 
		height:100, 
		width:200, 
		resizable:false, 
		closable : false, 
		header:false,
		frame:false, 
		modal:true,
		shadow :false, 
		items:[{ 
			xtype:'panel', 
			height:100, 
			width:200, 
			bodyStyle:'background-color:transparent;border:none;', 
			html: '<div align="center"><img src="' +  tabOutImg +  '"/></div>' 
		}] 
	}); 
	waitMsg.show();
}

function openOpRuleLookup(){

	root= new Ext.tree.AsyncTreeNode({
		expanded: true,
		id:'0',
		loader: new Ext.tree.TreeLoader({
		url: page_CMDBJsonGenerator+"?type=getAssetCoreOpRules",
        requestMethod: 'GET',
      }),
      listeners: {
                load: function(n) {
                    if (n.hasChildNodes() == true)
                    {
                        for(var i=0; i <  n.childNodes.length ; i++)
                        {
                            if(n.childNodes[i].attributes.error == true)
                            {
                                var errorMsg = n.childNodes[i].attributes.text;
                                n.childNodes[i].remove(true);
                                Ext.MessageBox.show({ msg:errorMsg, buttons: Ext.MessageBox.OK,fn: closePopUpWindow,title: errTitle});
                            }
                        }
                    }
                }}
	});

	tree = new Ext.tree.TreePanel({
			animate: true,
			id: 'OpRuleTree',
			root: root,
			useArrows: true,
			autoScroll: true,
			animate: true,
			containerScroll: true,
			border: false,
			rootVisible: false,
			height: height-80,
			listeners: {
				afterrender: function(treeComp) {
					// if you want to load the subtree automatically - do it here
				},
				dblclick : function( n,e ){
					if(n.leaf) {
						
						if(forAcAction == null || forAcAction == '' || forAcAction != 'true'){
							OpRuleTreePopUpWindow.close();
							window.SelectedOpRuleNode = n;
							selectedNode= n;
							preSetReferenceToText(n.attributes.id);
						}else{
							selectedNode=n;
							var extracontext = selectedNode.attributes.text;
							if(selectedNode.attributes.notes!= null && selectedNode.attributes.notes!='') {
								extracontext += ':' + selectedNode.attributes.notes;
							}
							waitbox(0);
							applyAction(selectedNode.attributes.id, selectedNode.attributes.approval,extracontext);
						}
					}
				},
				click: function(n) {
					if(n.leaf) {
						
						if(forAcAction == null || forAcAction == '' || forAcAction != 'true'){
							window.SelectedOpRuleNode = n;
							selectedNode=n;
						}else{
							selectedNode=n;
						}
					}else{
						selectedNode=null;
					}
				}
			}
		});
		
	OkButton = new Ext.Button({	
		id:'OkBtn',
		text:okBtnLabel,
		xtype: 'tbbutton',
		cls: 'windowBtnCls',
		handler: function(){
			
			if(selectedNode != null && selectedNode !='undefined'){
				if(forAcAction == null || forAcAction == '' || forAcAction != 'true'){
					OpRuleTreePopUpWindow.close();
					preSetReferenceToText(selectedNode.attributes.id);
				}else{
					
					if(selectedNode!=null && typeof(selectedNode)!='undefined') {
						var extracontext = selectedNode.attributes.text;
						if(selectedNode.attributes.notes!= null && selectedNode.attributes.notes!='') {
							extracontext += ':' + selectedNode.attributes.notes;
						}
						waitbox(0);
						applyAction(selectedNode.attributes.id, selectedNode.attributes.approval,extracontext);
						this.disabled = true;
					}
					
				}
			}else{
				Ext.MessageBox.show({ msg:selectORError, buttons: Ext.MessageBox.OK});
			}
		}
	});
	CancleButton = new Ext.Button({	
		id:'CancleBtn',
		text:cancelBtnLabel,
		xtype: 'tbbutton',
        cls: 'windowBtnCls',
		handler: function(){
			if(forAcAction == null || forAcAction == '' || forAcAction != 'true'){
				OpRuleTreePopUpWindow.close();
			}else{
				window.close();
			}
		}
	});
	
		//return false;
}

function showORWindow(){
	openOpRuleLookup();	
	OpRuleTreePopUpWindow = new Ext.Window({
			title: label_SelectOpRule,
			height: height,
			width: width,
			x: 10,
			y: 5,
			modal:true,
			resizable:true,
			constrain : true,
			viewConfig: {forceFit: true},
			items : tree,
			buttonAlign:'right',
			cls:'TextEditorWindowCls',
			buttons: [OkButton,CancleButton]
			
		});

		OpRuleTreePopUpWindow.show();
		tree.getRootNode().expand();
	return false;

}