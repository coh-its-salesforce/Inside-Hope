/* Date format setting */

// If the date format is not already set, create a global variable with this format
if(typeof(SDEDateFormat)=='undefined' || SDEDateFormat==null ||  SDEDateFormat=='')
{
    SDEDateFormat =  "m/d/Y h:i A";
}
if(typeof(SDETimeFormat)=='undefined' || SDETimeFormat==null ||  SDETimeFormat=='')
{
    SDETimeFormat =  "h:i A";
}
Date.useStrict = true;
    
/* End of date format setting */


/* Constants -- Some (not all) can come from the server and  then be reset here */

var ShowChangeNumberOrTypeValue = { number: "number", type: "type" }; // Enum for "Show Change Number OR Show Change Type"
var ShowReleaseNumberOrTypeValue = { number: "number", type: "type" }; // Enum for "Show Release Number OR Show Release Type"
var ViewComboValues = { day12: "DayView12", day24: "DayView24", week: "WeekView", month: "MonthView" }; // Enum for "One Day/Week/Month" dropdown values

/* End of constants */

/* EXT ONREADY method */
var pageRefreshed = true;
var linkedToVal = '[]';



Ext.onReady(function(){

	setTimeOptionData();

    ObsInstance = new CalendarObservable();
    console.log('adding obs-instance event handlers');
    ObsInstance.on(CalendarEvents.VIEW_UPDATED, logObservable); // Adds debug logs to the fire-bug console
    ObsInstance.on(CalendarEvents.VIEW_UPDATED, updateCalendar); // Adds debug logs to the fire-bug console

    // -- LoadPreviousCalendarState here before using the values
	//eval(taskDetail);
	//eval(combolinkedVal);
	//linkedToVal1 = linkedToVal;
	var southPanel = generateLegendBar();
    var centerPanel = getCenterPanel();
    var westPanel = getWestPanel();
	
    var StateValues = loadFromServer();
    if(typeof(StateValues)!='undefined' && StateValues!=null)
    {
    	syncDates(StateValues.DrawerDatePicker);
		document.getElementById("StartTime").value = StateValues.DrawerStartTimeField;
        
		if (StateValues.DrawerChangeGroup == ShowChangeNumberOrTypeValue.type) 
			document.getElementById("cmbChange").value = 'Type';
		else
			document.getElementById("cmbChange").value = 'Number';
			
		if (StateValues.DrawerReleaseGroup == ShowReleaseNumberOrTypeValue.type) 
			document.getElementById("cmbRelease").value = 'Type';
		else
			document.getElementById("cmbRelease").value = 'Number';
			
		if (StateValues.DrawerChangeGroup == 'undefined')
			document.getElementById("chkChange").checked = '';
		if (StateValues.DrawerReleaseGroup == 'undefined')
			document.getElementById("chkRelease").checked = '';
        document.getElementById("ViewType").value = StateValues.DrawerViewCombo;     
    }

    // Create the border layout. Viewport gives issues, so use a panel layout
    var panel = new Ext.Panel({
        layout: 'border',
        stateful:false,
        items: [westPanel,centerPanel],
        tbar: generateToolbar(),
        height: controlHeight
    });
    panel.render("contentDiv");
    
    ObsInstance.updateView();

    Ext.QuickTips.init();
    
    ChangeCalendar();
	var params = Ext.urlDecode(window.location.href);
	if(params.SlideOutWest=="true")
	{
		panel.layout.west.animFloat=false;
	    panel.layout.west.slideOut();
		panel.layout.west.animFloat=true;
	}
	var dCollpased = Ext.get("drawerPanel-xcollapsed");
	if(dCollpased!=null)
	{
		dCollpased.addListener('mouseover',function() {panel.layout.west.slideOut();});
 	}
    
    pageRefreshed = false;
	
	document.getElementById('cmbLinkedTo').selectedIndex = 0;	
	document.getElementById('cmbLinkedTo').parentNode.style.width = '100px';
	renderTaskGrid();
	renderUnscheduleGrid();
	
	//document.getElementById('taskCalendarTable').style.display = 'block';
	document.getElementById('schedulePage:taskPanel').style.display = 'none';
});

/* End of EXT ONREADY method */

var gridData=[];

function renderTaskGrid() {	
	/* Task Deatil Grid Start */
	if (taskRecordFound) {
		/* Task Grid Data Store */
		var store = new Ext.data.ArrayStore({
			fields:[{name: Labels['lblTask'] + ' #'},
				   {name: Labels['lblType']},
				   {name: Labels['lblCategory']},
				   {name: Labels['lblDescription']},
				   {name: Labels['lblStatus']},
				   {name: Labels['lblScheduledStart']},
				   {name: Labels['lblScheduledEnd']}]
			});
		store.loadData(gridData);
		// CREATE THE COLUMNS
		var cm = new Ext.grid.ColumnModel({
			columns: [
				{
					id:'taskName',
					header: Labels['lblTask'] + ' #', 
					width:150
				},
				{
					id:'taskType',
					header: Labels['lblType'], 
					width:100
				},
				{
					id:'taskCategory',
					header: Labels['lblCategory'], 
					width:120
				},
				{
					id:'taskDescription',
					header: Labels['lblDescription'], 
					width:200
				},
				{
					id:'taskStatus',
					header: Labels['lblStatus'], 
					width:80
				},
				{
					id:'taskStartDate',
					header: Labels['lblScheduledStart'], 
					width:120
				},
				{
					id:'taskEndDate',
					header: Labels['lblScheduledEnd'], 
					width:120
				}
					],defaults: {sortable: false, menuDisabled: true, width: 100}
		 });
		// CREATE THE GRID
		grid = new Ext.grid.GridPanel({
				id:'grid',
				autoWidth: true,
				border:true,
				store: store,
				autoscroll: 'auto',
				height :'100px',
				autoHeight :false,
				cm :cm,
				height:148,
				layout: 'fit',
				stateful: true,
				stateId: 'grid',
				enableColumnResize : true,
				enableColumnMove : false,
				viewConfig:{
					forceFit:true,
					scrollOffset:0 
				},
				autoFitColumns: true       
		 });		
		 grid.render("schedulePage:taskPanel");
		}
	

		/* Task Deatil Grid End */

}

function renderUnscheduleGrid(){
	if(!unScheduleTaskRecordFound){
		var NoRecordLabel = new Ext.form.Label({
			name: 'lblNoRecFnd',
            id: 'lblNoRecFnd',
			style:'vertical-align: middle; text-align: center;',
            text: Labels['lblNoRecordsFound']
		})
		var LabelPanel = new Ext.Panel({
			height:152,
			bodyStyle:"padding-top:67px; padding-left:82px;",
			items:[NoRecordLabel]
		})
		LabelPanel.render("unscheduleDiv");
	} else {
		var unscheduleStore = new Ext.data.ArrayStore({
			fields:[{name: Labels['lblTask'] + ' #'},
			{name: Labels['lblType']},
			{name: Labels['lblDescription']},
			{name: 'Id'}
			]
		});
		unscheduleStore.loadData(unscheduleTask);
			// CREATE THE UNSCHEDULE GRID
			var unScheduledTaskGrid = new Ext.grid.GridPanel({store: unscheduleStore,id:'taskDetail', columns: [
			{
				id: 'TaskName', 
				header: Labels['lblTask'] + ' #',
				width: 100, 
				menuDisabled:true,
				renderer:function(value, metaData, record, rowIndex, colIndex, store) {
					if(value!= Labels['lblCreationPending']){
						var ID = unscheduleStore.getAt(rowIndex).get('Id');
						return '<a class="changeLink" onclick="openTaskForm(\'' + ID + '\',\'' + value + '\')">' + value +'</a>';
					} else{
						return value; 
					}
				}
			 },{
				id: 'Type',
				header: Labels['lblType'], 
				width: 90,
				menuDisabled:true
			 },{
				id:'Description',
				header: Labels['lblDescription'], 
				width: 85,
				menuDisabled:true
			 }
			],stripeRows:true,
			autoHeight :true,
			bodyCssClass:'gridPanelMinHeight',
			layout: 'fit',
			width: 'auto',
	        stateId: 'grid1', title: Labels.tasks});

		unScheduledTaskGrid.render("unscheduleDiv");
	}
}

/* Extra debugger code */

if(typeof(console)=='undefined' || console==null) console = { log:function(a){}}; // In case of other browsers

// Create a console log for firefox
function logObservable(v)
{
     console.log('-date updated1--' + v.date);
     console.log('-start time updated1--' + v.startTime);
     console.log('-radio updated1--' + v.showChangeNumberOrType);
     console.log('-view type updated1--' + v.viewType);
}
/* End of Extra debugger code */



/* The West and Center panel definitions */

// Main calendar content here.
function getCenterPanel()
{
    var panel = new Ext.Panel({
                                    //bbar: generateLegendBar(),
                                    layout:'border',
                                    border:false,
                                    style:'border:10px solid #005d9c;',
                                    region:'center',
                                    items : [getCalendarPanel(),generateTaskPanel()]
                                });
    return panel;
}

function getCalendarPanel()
{
    var inhtml = getCalendarHTML();
    return (new Ext.Panel({
                layout:'fit',
                id:'CalendarPanel',
				autoScroll:'auto',
                html: inhtml,
				region: 'center',
                border: false
            }));
}

// Main calendar content here.
function getCalendarHTML()
{
    var row, cell;
    var mainTable = document.createElement("table");
    mainTable.cellPadding = "0";
    mainTable.cellSpacing = "0";
    mainTable.id = "mainTable";
    mainTable.name = "mainTable";
    
    row = mainTable.insertRow(0);
    cell = row.insertCell(0);
    cell.appendChild(GetMainHeader());
    row = mainTable.insertRow(1);
    cell.appendChild(GetCalendar());

    var div = document.createElement("div");
    div.id = 'destroyer';
    div.appendChild(mainTable);
    return div.innerHTML;
}
function collapsablePanelPluginInit(p,titleElemStyle,titleElemStyleIE,label)
{
	if (p.collapsible) {
                        var textClass = 'x-collapsed-header-text';
						if ((p.region == 'east') || (p.region == 'west')) textClass += '-rotated';
                        p.on('render', function() {
                            var ct = p.ownerCt;
                            ct.on('afterlayout', function() {
                                var supportsSVG = !!document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure", "1.1");
                        		var verticalText = ((p.region == 'east') || (p.region == 'west'));    
								//Only for other than IE
								var insertTableForTop = '';
								if (!(verticalText && supportsSVG)) {
									textClass = 'x-panel-header x-panel-header-rotated';
									titleElemStyle = titleElemStyleIE+'important;position: relative;';
									if (verticalText) {
										// use writing-mode for vertical text 
										titleElemStyle +='white-space: nowrap; writing-mode: tb-rl;top:5px;';												
									} else {
										titleElemStyle += 'top: 1px;';										
									}									
								}else
								{
									titleElemStyle += 'left:2px;';
									insertTableForTop = '<table><tr><td height="5"></td></tr></table>';
								}
								p.collapsedTitleEl = p.ownerCt.layout[p.region].getCollapsedEl().createChild({
									tag: 'div',									
									cls: textClass,
									html:insertTableForTop+'<div style="'+titleElemStyle+'" >'+label+'</div>'
									
								});
								
								p.setTitle = Ext.Panel.prototype.setTitle.createSequence(function(t) {
                                     p.collapsedTitleEl.dom.innerHTML = t;
                                });														
                            }, false, {single:true});
                        });
                    }
}
// Options for calendar views shown here
function getWestPanel()
{

Ext.override(Ext.DatePicker, {
    showPrevMonth : function(e){
        var d = this.activeDate.add('mo', -1);
        this.update(d);
        this.fireEvent('select', this, d);
    },
 
    // private
    showNextMonth : function(e){
        var d = this.activeDate.add('mo', 1);
        this.update(d);
        this.fireEvent('select', this, d);
    },
 
    onMonthClick : function(e, t){
        e.stopEvent();
        var el = new Ext.Element(t), pn;
        if(el.is('button.x-date-mp-cancel')){
            this.hideMonthPicker();
        }
        else if(el.is('button.x-date-mp-ok')){
            var d = new Date(this.mpSelYear, this.mpSelMonth, (this.activeDate || this.value).getDate());
            if(d.getMonth() != this.mpSelMonth){
                // 'fix' the JS rolling date conversion if needed
                d = new Date(this.mpSelYear, this.mpSelMonth, 1).getLastDateOfMonth();
            }
			window.status = d
            this.update(d);
            this.hideMonthPicker();
            this.fireEvent('select', this, d);
        }
        else if((pn = el.up('td.x-date-mp-month', 2))){
            this.mpMonths.removeClass('x-date-mp-sel');
            pn.addClass('x-date-mp-sel');
            this.mpSelMonth = pn.dom.xmonth;
        }
        else if((pn = el.up('td.x-date-mp-year', 2))){
            this.mpYears.removeClass('x-date-mp-sel');
            pn.addClass('x-date-mp-sel');
            this.mpSelYear = pn.dom.xyear;
        }
        else if(el.is('a.x-date-mp-prev')){
            this.updateMPYear(this.mpyear-10);
        }
        else if(el.is('a.x-date-mp-next')){
            this.updateMPYear(this.mpyear+10);
        }
    }    
});

    drawer_Datepicker = new Ext.DatePicker({
                            
                            listeners: {
                                'select': {
                                    fn: function(p, dt) {
                                        ObsInstance.updateDate(p, dt);
                                    },
                                    scope: this
                                },                                
                                'afterrender': {
                                    fn: function(o) {
                                    	o.todayBtn.on('click',GoToToday);
                                    },
                                    scope: this
                                }
                            }   
                        });
    
    var panel = new Ext.Panel({
        width: 210,
        id:"drawerPanel",
        region:'west',   	   
        collapsible:true,
        split:false,
        collapsed:true,
        minSize: 175,
        maxSize: 400,
        margins:'0 0 0 0',
        cmargins:'0 0 0 0',
        plugins: {
            init: function(p) {
                    collapsablePanelPluginInit(p,'padding-left:0px;','',Labels.HeaderViews);
            }
        },
        contentEl:"drawerPanelContent"
    });
    
    drawer_Datepicker.render('datePickerHolder');
    
    return panel;
}

/* End of the West and Center panel definitions*/



/* View drawer panel  definition - used in West panel*/

var drawer_Datepicker = null;
var drawer_RadioGroup  = null;
var drawer_StartTimeField = null;
var drawer_ViewCombo = null;


/* End of View drawer panel  definition */


/* Toolbar definition */
function generateToolbar()
{
    
    var tb = new Ext.Toolbar({
        border: false,
        height: 40,
        margins: '0 0 0 0',
        autoWidth:true,
        items: [
                    {
                        scale: 'medium',
                        iconCls: 'bmcRefreshCalendar',
						id: 'refreshCalender',
                        tooltipType : 'title',
                        tooltip: Labels.RefreshButtonTooltip, 
                        id:'refreshCalendarBtn',
                        handler:RefreshButtonClick
                    },
                    {
                        scale: 'medium',
                        iconCls: 'bmcPrintCalendar',
						id: 'printCalender',
                        tooltipType : 'title',
                        tooltip: Labels.PrintButtonTooltip,
                        id:'printCalendarBtn',
                        handler:PrintButtonClick
                    },
					 {
                        scale: 'medium',
                        iconCls: 'bmcReportCalendar',
                        tooltipType : 'title',
						tooltip: Labels.lblReport,
                        id:'reportCalendarBtn',
						handler: ReportButtonClick
                    },					
		    {
				xtype: 'tbfill'
			},
			{ 
				xtype:"textfield",
				fieldLabel:"Text",
				name:"textvalue",
				id:"searchField",
				emptyText:Labels.lblEmptySearchText,
				emptyClass:'x-form-empty-field',
				listeners: {
							specialkey: function(field, e){
								if (e.getKey() == e.ENTER){
										search();
								}
							}
				}
			},
		    {
                        scale: 'medium',
                        iconCls: 'bmcSearchCalendar',
                        tooltipType : 'title',
                        id:'searchCalendarBtn',
						tooltip: Labels.lblSearch,
                        handler:search
                    },
					{
                        scale: 'medium',
                        iconCls: 'bmcResetCalendar',
                        tooltipType : 'title',
						tooltip: Labels.RefreshButtonTooltip,
                        id:'resetCalendarBtn',
                        handler:reset
                    },
					{xtype: 'tbtext', html: '<img id="BarIcon" src="'+  BarImgsrc +'"  />'},
					{xtype: 'tbtext', html: '<img id="legendIcon" src="'+ LegendImgSrc +'" onmouseover="showLegendTip(this);" />'} 
                ]
    });

    return tb;
}
/* End of Toolbar definition */

/* Legend definition */

var LegendToolTip = null;
var legend_html = '';
function showLegendTip(eventObject, htmlToolTip)
{

	if(LegendToolTip==null)
	{
	   var target=eventObject;//.target;
	   if(target == null) 
	    target = eventObject.srcElement; 
		
		LegendToolTip = new Ext.ToolTip({
		    target: target.id,
		    anchor: 'bottom',
		    shadow:false,
		    autoWidth:true,
		    trackMouse: true,
		    bodyStyle:'font: 8pt Tahoma, Verdana, Arial; color:black;width:2%;border-color:black;',
		    dismissDelay: 60000,
		    html:legend_html
	    });
	}
   
    if (!Ext.isIE)
    {
   		LegendToolTip.targetXY = [eventObject.pageX, eventObject.pageY]
      	LegendToolTip.show();
	}
}
function generateLegendBar()
{
    var data = getCalendarLegendData();
    var tpl = new Ext.XTemplate('<tpl for="codes">',
                                    '<tr>',
										'<tpl if="values.text == \'1\'">',
											'<td style="height:20px;width:40px;background-color:{code}">',
													'&nbsp;<s>{div_html}</s>',
												'</td>',
											'<td>&nbsp;</td>',
											'<td>{title}</td>',
										'</tpl>',
										'<tpl if="values.text == \'0\'">',
											'<td style="height:1px;" colspan="3">',
												'<br /><div class="hrline"></div><br />',
											'</td>',
										'</tpl>', 
										'<tpl if="values.text == \'2\'">',
											'<td class="emergencyDeployRelease">',
													'&nbsp;<s>{div_html}</s>',
												'</td>',
											'<td>&nbsp;</td>',
											'<td>{title}</td>',
										'</tpl>',
										'<tpl if="values.text == \'3\'">',
											'<td class="minorDeployRelease">',
													'&nbsp;<s>{div_html}</s>',
												'</td>',
											'<td>&nbsp;</td>',
											'<td>{title}</td>',
										'</tpl>',
										'<tpl if="values.text == \'4\'">',
											'<td class="majorDeployRelease">',
													'&nbsp;<s>{div_html}</s>',
												'</td>',
											'<td>&nbsp;</td>',
											'<td>{title}</td>',
										'</tpl>',
										'<tpl if="values.text == \'5\'">',
											'<td class="deploymentRelease">',
													'&nbsp;<s>{div_html}</s>',
												'</td>',
											'<td>&nbsp;</td>',
											'<td>{title}</td>',
										'</tpl>',
										'<tpl if="values.text == \'6\'">',
											'<td class="closedDeploymentReleaseTooltip">',
													'&nbsp;<s>{div_html}</s>',
												'</td>',
											'<td>&nbsp;</td>',
											'<td>{title}</td>',
										'</tpl>',										
                                    '</tr>',
                                '</tpl>');
	legend_html = "<table cellpadding='3' cellspacing='3'>"+tpl.apply(data)+"</table>";
}
var NONPRINT = 'ф';
function generateTaskPanel()
{
	var cookieTaskType = taskFilterCookie;//readCookie('taskfilter');
	var taskTypesValues = taskTypes.split(NONPRINT);
	cookieTaskType = cookieTaskType.split(NONPRINT);
		
	var filterMenus = new Array(taskTypesValues.length + taskTypesValues.length + 1);
	var i=0, j=0;
	if (document.getElementById("taskFilterValue").value == 'All')
		document.getElementById("taskFilterValue").value = document.getElementById("taskFilterValue").value.replace('All','');
	for(;i<taskTypesValues.length;i++,j++) {
		var taskChecked = false;
		if (cookieTaskType != 'All') {
			for(c=0;c<cookieTaskType.length;c++) {
				if (taskTypesValues[i] == cookieTaskType[c]) {
					taskChecked = true;
					document.getElementById("taskFilterValue").value=document.getElementById("taskFilterValue").value + taskTypesValues[i] + NONPRINT;
					break;
				}
			}
		}
		else {
			taskChecked = true;
			document.getElementById("taskFilterValue").value=document.getElementById("taskFilterValue").value + taskTypesValues[i] + NONPRINT;
		}
		filterMenus[j]={xtype:'checkbox', name: 'ttype', group: 'ttype', checked: taskChecked, iconCls: 'emptyIcon', boxLabel: taskTypesValues[i] +  ' ' + Labels['lblTasks'], inputValue: taskTypesValues[i], handler: filterTasksHandler};
		j = j+1;
		filterMenus[j]=' ';
	}
	
	filterMenus[j]={text: Labels['lblApply'], iconCls: 'mnuList', handler: doApply};
	
	var linkedToLabel = new Ext.form.Label({
		text: Labels['lblLinkedTo'], 
		margins: '20 0 0 0',
		width:100,
		tooltipType:'title',
		tooltip:Labels['lblLinkedTo'],
		id:'lblLinkedTo'
	});
	linkComboStore = new Ext.data.JsonStore({
		id: 'inputStore',
		data: combolinkedVal,
		fields: ['id', 'name']		        	
	});
	var comboHtml = "<select id='cmbLinkedTo' style='width:130px;' onchange='ViewTasks();'>";
	linkComboStore.each(function(r) {
		//alert(r.get('id') + ' ' + r.get('name'));
		comboHtml += "<option value='"+r.get('id')+"'>"+r.get('name')+"</option>"
	});
	comboHtml += "</select>";
	var cmbLinkedTo = new Ext.form.ComboBox({
		id:'cmbLinkedTo',
		fieldLabel: Labels['lblLinkedTo'],
		margins: '0 0 0 0',
		store: linkComboStore,
		displayField: 'name',
		valueField: 'id',
		typeAhead: true,
		mode: 'local',
		triggerAction: 'all',
		editable:false, 
		selectOnFocus:true,
		width: 100,
		value:SelectedLinkedName
	});
	cmbLinkedTo.on('select', function(){
		ViewTasks();
	});
	
	var tb = new Ext.Toolbar({
        border: false,
        height: 35,
        margins: '0 0 0 0',
        autoWidth:true,
        items: [linkedToLabel,
			{
				html: "&nbsp;&nbsp;&nbsp;",
				xtype: "spacer"
			},
			//{
			//	html: comboHtml,//"<select title='test'><option value='test1'>test1</option><option value='test2'>test2</option></select>",
			//	xtype: "panel"
			//},
			cmbLinkedTo,
			{
				html: "&nbsp;",
				xtype: "spacer"
			},
			{xtype: 'tbseparator'},
			{iconCls: 'bmcView1', tooltip: Labels['HeaderViews'], tooltipType: 'title', id:'btnView', scale: 'medium', menu: filterMenus}, 
			{xtype: 'tbseparator'},
			{
				html: "&nbsp;",
				xtype: "spacer"
			},
			{
				scale: 'medium',
				cls: 'viewTimelineSelected',
				id: 'timelineId',
				tooltipType : 'title',
				tooltip: Labels['lblTimeline'], 
				handleMouseEvents : false,
				handler:showTaskCalendar
			},
			{
				scale: 'medium',
				cls: 'viewTable',
				id: 'tableId',
				tooltipType : 'title',
				tooltip: Labels['lblTable'], 
				handleMouseEvents : false,
				handler:showTaskTable
			}
		]
    });
	
	var taskaccordionval = new Ext.Panel({
		header:true,
		border:false,
		title: '<div title="'+Labels['lblHideTasks']+'">'+Labels["lblTasks"]+'</div>',
		//titleCollapse:false,
		//animCollapse: false,
		floatable: false,
		region:'south',
		layout:'border',
		//contentEl: 'schedulePage:taskPanel',
		collapsible : true,
		collapsed:true,
		height: 200,
		//minSize: 100,
		//maxSize: 200,
		//split: true,
		//tbar: tb,
		defaults:{
			split:true
		},
		id:'mainTaskCalendar',
		//autoScroll:'auto',
		items : [{
			id:'taskPanel',
			tbar: tb,
			width:800,
			collapsible:false,
			autoScroll:true,
			region:'center',
			items:[getTaskCalendarPanel()],
			listeners: {
				'resize': function () {
					refreshGrid();
				}
			},
			contentEl: 'schedulePage:taskPanel'
		},{
			title:Labels['lblUnscheduledTasks'],
			id:'unScheduleTasks',
			region:'east',
			autoScroll:true,
			collapsible:true,
			width:300,
			minWidth:300,
			maxWidth:300,
			//cmargins:'5 0 0 0',
			contentEl:'unscheduleDiv',
			plugins: {
				init: function(p) {
						var styleStr = '';
						if(Ext.isIE){styleStr+='right:6px;';}else{styleStr+='left:0px;';}
						collapsablePanelPluginInit(p,'padding-left:0px;color:#004376;',styleStr,Labels['lblUnscheduledTasks']);
				}
			}
		}],
		plugins: {
            init: function(p) {
                    collapsablePanelPluginInit(p,'padding-left:0px;cursor:pointer;font-weight:bold;color:#FFF;','',Labels["lblTasks"]);
            }
        }
		//defaults: {
			// applied to each contained panel
		//	bodyStyle: 'padding:15px'
		//},
		
		//items: [{
		//	title: 'Panel 1',
		//	html: '<p>Panel content!</p>'
		//}]
	});
	return taskaccordionval;
}
function ViewTasks() {
	var cmbLink = Ext.getCmp('cmbLinkedTo');
	SelectedLinkedName = cmbLink.getValue();//cmbLink.options[cmbLink.selectedIndex].value;
	//alert(SelectedLinkedName);
	changeTask(SelectedLinkedName);
}
var isCalendarShown = true;
function showTaskCalendar() {
	isCalendarShown = true;
	document.getElementById('taskCalendarPanel').style.display = 'block';
	document.getElementById('schedulePage:taskPanel').style.display = 'none';	
	if (document.getElementById('timelineId').className.indexOf('viewTimelineSelected') != -1)
		return;
	document.getElementById('timelineId').className = document.getElementById('timelineId').className.replace('viewTimeline', 'viewTimelineSelected');
	document.getElementById('tableId').className = document.getElementById('tableId').className.replace('viewTableSelected', 'viewTable');
}
function showTaskTable() {
	isCalendarShown = false;
	document.getElementById('taskCalendarPanel').style.display = 'none';		
	document.getElementById('schedulePage:taskPanel').style.display = 'block';
	if (document.getElementById('tableId').className.indexOf('viewTableSelected') != -1)
		return;
	document.getElementById('tableId').className = document.getElementById('tableId').className.replace('viewTable', 'viewTableSelected');
	document.getElementById('timelineId').className = document.getElementById('timelineId').className.replace('viewTimelineSelected', 'viewTimeline');
	refreshGrid();
}
function doApply(){
	if (SelectedLinkedName != null && SelectedLinkedName != '')
		changeTask(SelectedLinkedName);//, document.getElementById('taskFilterValue').value);
}
function replaceAll(value,stringToFind,stringToReplace){
	var temp = value;
	var index = temp.indexOf(stringToFind);
	while(index != -1){
		temp = temp.replace(stringToFind,stringToReplace);
		index = temp.indexOf(stringToFind);
	}
	return temp;
}
var filterTasksHandler = function(item, checked) {
		setOptions(item, checked);
    };
function setOptions(item, checked){
	if(checked){
		document.getElementById("taskFilterValue").value=document.getElementById("taskFilterValue").value + item.inputValue + NONPRINT;
	}else{
		//document.getElementById("taskFilterValue").value=NONPRINT+document.getElementById("taskFilterValue").value;
		
		while(document.getElementById("taskFilterValue").value.indexOf(NONPRINT+item.inputValue+NONPRINT)!=-1)
			document.getElementById("taskFilterValue").value=document.getElementById("taskFilterValue").value.replace(NONPRINT+item.inputValue+NONPRINT, NONPRINT);
		//while(document.getElementById("taskFilterValue").value.indexOf(NONPRINT+NONPRINT)!=-1)
		//	document.getElementById("taskFilterValue").value=document.getElementById("taskFilterValue").value.replace(NONPRINT+NONPRINT, NONPRINT);
		while(document.getElementById("taskFilterValue").value.indexOf(NONPRINT+item.inputValue)!=-1)
			document.getElementById("taskFilterValue").value=document.getElementById("taskFilterValue").value.replace(NONPRINT+item.inputValue, '');
		while(document.getElementById("taskFilterValue").value.indexOf(item.inputValue+NONPRINT)!=-1)
			document.getElementById("taskFilterValue").value=document.getElementById("taskFilterValue").value.replace(item.inputValue+NONPRINT, '');
		while(document.getElementById("taskFilterValue").value.indexOf(item.inputValue)!=-1)
			document.getElementById("taskFilterValue").value=document.getElementById("taskFilterValue").value.replace(item.inputValue, '');
	}
}
function createCookie(name,value,days) {    
	if (days) {        
		var date = new Date();        
		date.setTime(date.getTime()+(days*24*60*60*1000));        
		var expires = "; expires="+date.toGMTString();    
	} else var expires = "";    
	  document.cookie = name+"="+value+expires+"; path=/"; 
}
function readCookie(name) {    
	var nameEQ = name + "=";    
	var ca = document.cookie.split(';');    
	for(var i=0;i < ca.length;i++) {        
		var c = ca[i];        
		while (c.charAt(0)==' ') c = c.substring(1,c.length);        
		if (c.indexOf(nameEQ) == 0) 
			return c.substring(nameEQ.length,c.length);    
	}    
	return ''; 
} 
function eraseCookie(name) {
	createCookie(name,"",-1); 
}
function changeGridValue(){
	document.getElementById('unscheduleDiv').innerHTML='';
	renderUnscheduleGrid();
	var taskCalendarTable = document.getElementById("taskCalendarTable");
	var taskCalendarDiv = taskCalendarTable.parentNode;
	taskCalendarDiv.innerHTML = '';
	
	var row, cell;
	var calendarTable = document.createElement("table");
	calendarTable.id = "taskCalendarTable";
	calendarTable.name = "taskCalendarTable";
	calendarTable.style.tableLayout="fixed"
	calendarTable.cellPadding = "0";
	calendarTable.cellSpacing = "0";
	calendarTable.width = '100%';
	taskCalendarDiv.appendChild(calendarTable);
	
	if (taskRecordFound) {
		getTaskCalendarPanel();
		GetTaskCalendarData(calendarTable);
		renderTaskGrid();
	}
	else {
		TaskGridData = ' ';
		GetTaskCalendarData(calendarTable);
	}
	if (isCalendarShown) showTaskCalendar();
		else showTaskTable();
}
/* End of legend definition */

/* Toolbar event handlers */

function RefreshButtonClick()
{
    ObsInstance.updateView();
}

function PrintButtonClick()
{
	if(window.print)
	{
		window.print();
	}
    ////alert('print me');
}
function ReportButtonClick() {
	var link='\'/ChangeScheduleExportCSV';
	window.open(link);
}
/* End of toolbar event handlers */


/* Observables 
    -- Use the observer pattern for event notifications within components
    -- This reduces the messy and wired event handling
    Usage example:
        ObsInstance.on(CalendarEvents.EVENT_DATE_UPDATED, function(v){ console.log('-date updated1--' + v.date) });

*/

var ObsInstance = null;

// List of events
var CalendarEvents = { 
                        // Make sure the name matches in registrations in constructor
                        VIEW_UPDATED: 'view_updated'
                    };

var CalendarObservable = function(){
                                this.values = {};
                                this.addEvents({
                                    parameters_updated: true});
                            };
Ext.extend(CalendarObservable, Ext.util.Observable,{
        updateDate: function(sender, date, DoNotSlideOutWest){
            this.values.date = date;
            syncDates(date);
            this.updateView(DoNotSlideOutWest);
        },
        
        updateView: function(DoNotSlideOutWest)
        {
            var v = getParamsForView();
            v.DoNotSlideOutWest=(DoNotSlideOutWest==true);
                        
            // Make sure that the parameters are mapped correctly.
            this.values.date = v.date;
            this.values.startTime = v.startTime;
            this.values.showChangeNumberOrType = v.showChangeNumberOrType;
			this.values.showReleaseNumberOrType = v.showReleaseNumberOrType;
            this.values.viewType = v.viewType;
            this.values.filterField = v.filterField;
            this.values.filterField =v.filterValue;
            this.values.DoNotSlideOutWest=v.DoNotSlideOutWest;

            this.fireEvent(CalendarEvents.VIEW_UPDATED, this.values, null);
            
        }
        
    });
    
function syncDates(dt)
{
    drawer_Datepicker.setValue(dt);
}

function getParamsForView()
{
    var val = {};
    val.date = drawer_Datepicker.getValue();
    val.startTime = document.getElementById("StartTime").value;
    var cmbChange = document.getElementById("cmbChange");
	var cmbRelease = document.getElementById("cmbRelease");
	var dropDownObject = document.getElementById("<%=DropDownList1.ClientID%>");

    if(document.getElementById("chkChange").checked && cmbChange.options[cmbChange.selectedIndex].value == "Number")
    {
        val.showChangeNumberOrType = ShowChangeNumberOrTypeValue.number;
    }
    else if(document.getElementById("chkChange").checked && cmbChange.options[cmbChange.selectedIndex].value == "Type")
    {
        val.showChangeNumberOrType = ShowChangeNumberOrTypeValue.type;
    }
    
	if(document.getElementById("chkRelease").checked && cmbRelease.options[cmbRelease.selectedIndex].value == "Number")
    {
        val.showReleaseNumberOrType = ShowReleaseNumberOrTypeValue.number;
    }
    else if(document.getElementById("chkRelease").checked && cmbRelease.options[cmbRelease.selectedIndex].value == "Type")
    {
        val.showReleaseNumberOrType = ShowReleaseNumberOrTypeValue.type;
    }
    val.viewType = document.getElementById("ViewType").value;
    val.filterField = 'some_field__c';
    val.filterValue = 'P1';
    return val;
}

function ViewChanged()
{
    ObsInstance.updateView();
}

function FireOnChangeEvent()
{
	//if(Ext.isIE)// && o.checked && ExtJSNumberOrType!=o.value)
	//{
		ViewChanged();
	//}
}

function GoToToday()
{
	document.getElementById("ViewType").value = ViewComboValues.day12;
}

function EnableDisableTime() {
	var o=document.getElementById("ViewType");
	if (o.value == 'DayView12' || o.value == 'DayView24') 
		document.getElementById("StartTime").disabled = false;
	else
		document.getElementById("StartTime").disabled = true;
}
/* End of observables*/



/* Calendar View code  */

function move(mul)
{
    var viewType = getParamsForView().viewType;
    var dt = drawer_Datepicker.getValue();
    var days = 1;
    if(viewType==ViewComboValues.day12)
    {
        dt = dt.add(Date.DAY, 1*mul);
    }
    else if(viewType==ViewComboValues.day24)
    {
        dt = dt.add(Date.DAY, 1*mul);
    }
    else if(viewType==ViewComboValues.week)
    {
        dt = dt.add(Date.DAY, 7*mul);
    }
    else if(viewType==ViewComboValues.month)
    {
        dt = dt.add(Date.MONTH, 1*mul);
    }
    ObsInstance.updateDate(null,dt, true);
}

function previous()
{
    move(-1);
}

function next()
{
    move(1);
}

/* End of Calendar View code  */

/* Update calendar code here..... */
function updateCalendar(v)
{
    if(pageRefreshed) {return; }
    //v.date,
    //v.showChangeNumberOrType,
    //v.startTime,
    //v.viewType
    var dt=v.date.add(Date.HOUR, v.startTime).format(isoDateFormat);
    console.log('isodate:' + dt);
    var viewtype = ''; 
    if(v.viewType==ViewComboValues.day12)
    {
        viewtype ='DayView12';
    }
    else if(v.viewType==ViewComboValues.day24)
    {
        viewtype ='DayView24';
    }
    else if(v.viewType==ViewComboValues.week)
    {
        viewtype ='WeekView';
    }
    else if(v.viewType==ViewComboValues.month)
    {
        viewtype ='MonthView';
    }
    if(getStandardLayout()){
    	window.location.href= CurrentPage + "?refresh=true&CurrentView="+viewtype+"&ClientDate="+dt+"&StartTime="+v.startTime+"&changeNumberOrType=" + v.showChangeNumberOrType+"&releaseNumberOrType=" + v.showReleaseNumberOrType+"&height="+controlHeight+"&SlideOutWest="+(!v.DoNotSlideOutWest)+"&standardLayout=true";
    }else{
    window.location.href= CurrentPage + "?refresh=true&CurrentView="+viewtype+"&ClientDate="+dt+"&StartTime="+v.startTime+"&changeNumberOrType=" + v.showChangeNumberOrType+"&releaseNumberOrType=" + v.showReleaseNumberOrType+"&height="+controlHeight+"&SlideOutWest="+(!v.DoNotSlideOutWest);
    }
    console.log('Calendar updated for date ' + v.date);
}

/* End of Update calendar code */

        var ChangeTypeColorArr;
		var ReleaseTypeColorArr;
        var maxColumns;
        function GetMainHeader()
        { 
            var row, cell;
            var headerTable = document.createElement("table");
            headerTable.cellPadding = "0";
            headerTable.cellSpacing = "0";
            headerTable.id = "headerTable";
            headerTable.name = "headerTable";
            row = headerTable.insertRow(0);
            
            cell = row.insertCell(0);
            cell.width="35%";
            
            cell = row.insertCell(1);
            cell.id="movePreviousHeader";
            cell.innerHTML = "<img id='previousBTN' src='" + PrevImgSrc + "' style='cursor:pointer' onclick='previous();' title='" + Labels['lblPrevious'] + "'>";
            
            cell = row.insertCell(2);
            cell.innerHTML = HeaderLabel;
            cell.id = "lblHeader";
            cell.width="16%";
            
            cell = row.insertCell(3);
            cell.id="movePreviousHeader";
            cell.innerHTML = "<img id='nextBTN' src='" + NextImgSrc + "' style='cursor:pointer' onclick='next();' title='" + Labels['lblNext'] + "'>";
            
            cell = row.insertCell(4);
            cell.width="35%";
            return(headerTable);   
        }
        
        function GetCalendar()
        {
            var row, cell;
            var calendarTable = document.createElement("table");
            calendarTable.id = "calendarTable";
            calendarTable.name = "calendarTable";
            calendarTable.style.tableLayout="fixed"
            calendarTable.cellPadding = "0";
            calendarTable.cellSpacing = "0";
            row = calendarTable.insertRow(calendarTable.rows.length);
            GetCalendarHeader(row);
            return(calendarTable); 
        }
        
        function ChangeCalendar()
        {
            var row, cell;
            var calendarTable = document.getElementById("calendarTable");
            GetBlackoutData(calendarTable);
            GetCalendarData(calendarTable);
			GetReleaseCalendarData(calendarTable);
			var taskCalendarTable = document.getElementById("taskCalendarTable");
			GetTaskCalendarData(taskCalendarTable);
            var CalendarPanelHeight = Ext.get('CalendarPanel').getHeight();
            var ctHeight = document.getElementById('calendarTable').clientHeight + 35;
			if (CalendarPanelHeight > ctHeight)
            document.getElementById('calendarTable').rows[document.getElementById('calendarTable').rows.length-1].style.height = 
		            parseInt('0'+document.getElementById('calendarTable').rows[document.getElementById('calendarTable').rows.length-1].style.height, 10) + (CalendarPanelHeight - ctHeight) + 'px';
        }
        
        
        function GetCalendarHeader(row)
        {
            maxColumns = calendarHeader.length;
            for(var i=0; i<maxColumns; i++)
            {
                cell  = row.insertCell(i);
                 if ((ExtJSViewType == 'WeekView') || (ExtJSViewType == 'MonthView'))
                	cell.innerHTML = String(calendarHeader[i][0]).replace(' ','<br/>');
            	else if(ExtJSViewType =='DayView24'){
                  var startTime=calendarHeader[i][0];
				   if(startTime<9)
                	cell.innerHTML = '0'+startTime+':00';
				   else 
				    cell.innerHTML = startTime+':00';
				}else 
				  cell.innerHTML = calendarHeader[i][0];
                if (calendarHeader[i][1] == 0)
                    cell.className = 'serviceOutageHeader';
                else if (calendarHeader[i][1] == 1)
                    cell.className = 'blackoutHeader';
                else
                    cell.className = 'normalHeader';
            }
        }
                       
    function GetBlackoutData(calendarTable)
    {
        var maxRows = BOGridData.length;
		var UtilJsQuoteStrRe = RegExp("'", "g");
        var row, cell, cellCount, maxSOs, SOId, SOName, blackout, iStart, iEnd, cellHTML;
        for(var i=0; i<maxRows; i++)    //iterate thru rows
        {
            row = calendarTable.insertRow(calendarTable.rows.length);
            row.style.height = '20px';
            cellCount = 1;
            arrSOs = BOGridData[i];
            maxSOs = arrSOs.length;
            for (var j=0; j<maxSOs; j++)    //iterate thru Service Outages
            {
                SOId = arrSOs[j][0];
                SOName = arrSOs[j][1];
                iStart = arrSOs[j][2];
                iEnd = arrSOs[j][3];
                blackout = arrSOs[j][4];

                while (cellCount <= maxColumns)
                {
                    cell = row.insertCell(row.cells.length);
                    if (cellCount == iStart)
                    {
                    	if(getStandardLayout()){
							var link='\'/'+SOId+'\'';
							cellHTML = '<a class="changeLink" onclick="window.open('+link+')">' + SOName + '</a>';
						}else{
                        cellHTML = '<a class="changeLink" onclick="openServiceOutageForm(\'' + SOId + '\',\'' + escape(SOName) + '\')">' + SOName + '</a>';
						}
                        cell.id = 's_o' + i + 'c' + j;
                        cell.innerHTML = cellHTML;
                        if (blackout == 1)
                            cell.className = 'blackout';
                        else
                            cell.className = 'serviceOutage';
                        cell.colSpan = iEnd - iStart + 1;
                        if (Ext.isIE)
                            cell.onmouseover = new Function("showToolTip(event,'" + SOId + "', false, 'Change')");
                        else
                            cell.setAttribute('onmouseover', 'showToolTip(event, \''+ SOId +'\', false, \'Change\')');
                        cellCount = iEnd + 1;
                        break;
                    }
                    else
                    {
                        if (calendarHeader[cellCount-1][1] !=255)
                        {
                            if(calendarHeader[cellCount-1][1] == 0)
                                cell.className = 'serviceOutage';
                            else if(calendarHeader[cellCount-1][1] == 1)
                                cell.className = 'blackout';
                        }
                        else
                        {
                            if ((cellCount-1) % 2 == 0)
                                cell.className = 'alternateRow0';
                            else
                                cell.className = 'alternateRow1';
                        }
                    }
                    cellCount++;
                }
            }
            while (cellCount <= maxColumns)
            {
                cell = row.insertCell(row.cells.length);
                if (calendarHeader[cellCount-1][1] !=255)
                {
                    if(calendarHeader[cellCount-1][1] == 0)
                        cell.className = 'serviceOutage';
                    else if(calendarHeader[cellCount-1][1] == 1)
                        cell.className = 'blackout';
                }
                else
                {
                    if ((cellCount-1) % 2 == 0)
                        cell.className = 'alternateRow0';
                    else
                        cell.className = 'alternateRow1';
                }
                cellCount++;
            }
        }
       
    }
    
    function GetCalendarData(calendarTable)
    {
		var maxRows = ChangeGridData.length;
        var row, cell, cellCount, maxChanges, changeId, changeNumber, changeType, iStart, iEnd, changeState, cellHTML, changeColor;

        for(var i=0; i<maxRows; i++)    //iterate thru rows
        {
            row = calendarTable.insertRow(calendarTable.rows.length);
            row.style.height = '20px';
            cellCount = 1;
            arrChanges = ChangeGridData[i];
            maxChanges = arrChanges.length;
			//alert('maxChanges: ' +  maxChanges + ' ' + maxRows);
            for (var j=0; j<maxChanges; j++)    //iterate thru Changes
            {
                changeId = arrChanges[j][0];
                changeNumber = arrChanges[j][1];
                changeType = arrChanges[j][2];
                iStart = arrChanges[j][3];
                iEnd = arrChanges[j][4];
                changeState = arrChanges[j][5];
                cellHTML = '';
                
                while (cellCount <= maxColumns)
                {
                    cell = row.insertCell(row.cells.length);
                    if (cellCount == iStart)
                    {
						if (!changeState)
							changeColor = '#F2F2F2';
                        else if (typeof(ChangeTypeColorArr[changeType]) != 'undefined')
                            changeColor = ChangeTypeColorArr[changeType];
                        else
                            changeColor = '#CCCCCC';
                        if (!changeState)
                            cellHTML += '<s>';
						if(getStandardLayout()){
						
							var link='\'/'+changeId+'\'';
							cellHTML += '<a class="changeLink" onclick="window.open('+link+')">'
						}
						else
                        cellHTML += '<a class="changeLink" onclick="openChangeForm(\'' + changeId + '\',\'' + changeNumber + '\')">' 
                        if (ExtJSChangeNumberOrType == 'number' || ExtJSChangeNumberOrType == 'undefined')
                            cellHTML += changeNumber 
                        else
                            cellHTML += changeType
                        cellHTML += '</a>';
                        if (!changeState)
                            cellHTML += '</s>';
                        cell.id = 'c_r' + i + 'c' + j;
                        cell.innerHTML = cellHTML;
                        cell.className = 'changeRequest';
                        cell.bgColor = changeColor;
                        cell.colSpan = iEnd - iStart + 1;
                        var counter = cell.id;
						if (Ext.isIE)
							cell.onmouseover = new Function("showToolTip(event,'" + changeId + "', true, 'Change')");
						else
							cell.setAttribute('onmouseover', 'showToolTip(event, \''+ changeId +'\', true, \'Change\')');
						
                        cellCount = iEnd + 1;
                        break;
                    }
                    else
                    {
                        if (calendarHeader[cellCount-1][1] !=255)
                        {
                            if(calendarHeader[cellCount-1][1] == 0)
                            {
                                cell.className = 'serviceOutage';
                            }
                            else if(calendarHeader[cellCount-1][1] == 1)
                            {
                                cell.className = 'blackout';
                            }
                        }
                        else
                        {
                            if ((cellCount-1) % 2 == 0)
                                cell.className = 'alternateRow0';
                            else
                                cell.className = 'alternateRow1';
                        }
                    }
                    cellCount++;
                }
            }
            while (cellCount <= maxColumns)
            {
                cell = row.insertCell(row.cells.length);
                if (calendarHeader[cellCount-1][1] !=255)
                {
                    if(calendarHeader[cellCount-1][1] == 0)
                        cell.className = 'serviceOutage';
                    else if(calendarHeader[cellCount-1][1] == 1)
                        cell.className = 'blackout';
                }
                else
                {
                    if ((cellCount-1) % 2 == 0)
                        cell.className = 'alternateRow0';
                    else
                        cell.className = 'alternateRow1';
                }
                cellCount++;
            }
        }
        
    }
    function GetReleaseCalendarData(calendarTable)
    {
		var maxRows = ReleaseGridData.length;
        var row, cell, cellCount, maxReleases, releaseId, releaseNumber, releaseType, iStart, iEnd, releaseState, cellHTML, releaseColor;
		for(var i=0; i<maxRows; i++)    //iterate thru rows
        {
            row = calendarTable.insertRow(calendarTable.rows.length);
            row.style.height = '20px';
            cellCount = 1;
            arrReleases = ReleaseGridData[i];
            maxReleases = arrReleases.length;
			////alert('maxReleases: ' +  maxReleases);
			for (var j=0; j<maxReleases; j++)    //iterate thru releases
            {
				var releaseClass;
				var forDeployment = arrReleases[j][0].indexOf('$') != -1 ? true : false;				
				releaseId = forDeployment ? arrReleases[j][0].substring(0, arrReleases[j][0].length - 1) : arrReleases[j][0];
                releaseNumber = arrReleases[j][1];
                releaseType = arrReleases[j][2];
                iStart = arrReleases[j][3];
                iEnd = arrReleases[j][4];
				releaseState = arrReleases[j][5];
				////alert(releaseId + ' ' + releaseNumber + ' ' + releaseType + ' ' + iStart + ' ' + iEnd + ' ' + releaseState);
                cellHTML = '';
                ////alert(cellCount + ' ' + maxColumns);
				if (releaseState) {
					if (releaseType == 'Minor' || releaseType == '')
						releaseClass = 'minorReleaseLink';
					else
						releaseClass = 'releaseLink';
				}
				else releaseClass = 'minorReleaseLink';
				
				while (cellCount <= maxColumns)
                {
                    cell = row.insertCell(row.cells.length);
					////alert(cell + ' ' + cellCount + ' ' + iStart);
					if (cellCount == iStart)
                    {
						if (!releaseState && !forDeployment) {
							releaseColor = '#F2F2F2';
							releaseClass = 'minorReleaseLink';
						}
                        else if (typeof(ReleaseTypeColorArr[releaseType]) != 'undefined')
                            releaseColor = ReleaseTypeColorArr[releaseType];
                        else if (releaseType == '') 
							releaseColor = '#C4D8E8';
						else
                            releaseColor = '#CCCCCC';
							
						if (!releaseState)
                            cellHTML += '<s>';
						var link='\'/'+releaseId+'\'';
						cellHTML += '<a class="'+releaseClass+'" onclick="window.open('+link+')">'
						if (ExtJSReleaseNumberOrType == 'number' || ExtJSReleaseNumberOrType == 'undefined')
                            cellHTML += releaseNumber 
                        else
                            cellHTML += releaseType
                        cellHTML += '</a>';
                        if (!releaseState)
                            cellHTML += '</s>';
						if (!forDeployment)
                        cell.id = 'ri_r' + i + 'c' + j;
						else
						cell.id = 'rd_r' + i + 'c' + j;
                        cell.innerHTML = cellHTML;
						cell.className = 'release';
						
						if (!releaseState && forDeployment) {
							cell.className = 'closedDeploymentRelease';
						}
						
						if (forDeployment && releaseType == 'Minor' && releaseState)
							cell.className = 'minorDeployRelease';
						else if (forDeployment && releaseType == 'Major' && releaseState)
							cell.className = 'majorDeployRelease';
						else if (forDeployment && releaseType == 'Emergency' && releaseState)
							cell.className = 'emergencyDeployRelease';
						else if (forDeployment && releaseType == '' && releaseState)
							cell.className = 'deploymentRelease';
                        cell.bgColor = releaseColor;
                        cell.colSpan = iEnd - iStart + 1;
                        var counter = cell.id;
						////alert('GetCalendarData : ' + tooltipType);
						if (Ext.isIE)
							cell.onmouseover = new Function("showToolTip(event,'" + arrReleases[j][0] + "', true, 'Release')");
						else
							cell.setAttribute('onmouseover', 'showToolTip(event, \''+ arrReleases[j][0] +'\', true, \'Release\')');
						
                        cellCount = iEnd + 1;
                        break;
                    }
                    else
                    {
                        if (calendarHeader[cellCount-1][1] !=255)
                        {
                            if(calendarHeader[cellCount-1][1] == 0)
                                cell.className = 'serviceOutage';
                            else if(calendarHeader[cellCount-1][1] == 1)
                                cell.className = 'blackout';
                        }
                        else
                        {
							if ((cellCount-1) % 2 == 0)
                                cell.className = 'alternateRow0';
                            else
                                cell.className = 'alternateRow1';
                        }
                    }
                    cellCount++;
                }
            }
            while (cellCount <= maxColumns)
            {
                cell = row.insertCell(row.cells.length);
                if (calendarHeader[cellCount-1][1] !=255)
                {
                    if(calendarHeader[cellCount-1][1] == 0)
                        cell.className = 'serviceOutage';
                    else if(calendarHeader[cellCount-1][1] == 1)
                        cell.className = 'blackout';
                }
                else
                {
                    if ((cellCount-1) % 2 == 0)
						cell.className = 'alternateRow0';
					else
						cell.className = 'alternateRow1';
                }
                cellCount++;
            }
        }
        
    }
    function openServiceOutageForm(Id, name)
    {
        //var name = escape(name);
		var url =  "NavigatorPage?&title="+name+"&target=BlackOutPage?id="+Id;
        window.parent.parent.addNewTab("BlackoutPage", Labels['lblPSO'],url);  
        return false;
    }
    
    function openChangeForm(Id, name)
    {
        var url =  "NavigatorPage? &title="+name+"&target=ChangeRequestPage?id="+Id;
        window.parent.parent.addNewTab("ChangeRequestPage", Labels['lblCR'],url);  
        return false;

    }
    function openReleaseForm(Id, name)
    {
        var url =  "NavigatorPage? &title="+name+"&target=ReleasePage?id="+Id;
        window.parent.parent.addNewTab("ReleasePage", Labels['lblCR'],url);  
        return false;

    }
	function openTaskForm(Id, name)
    {	
	var url = "/"+Id;
        //var url =  "NavigatorPage? &title="+name+"&target=TaskPage?id="+Id;
        //window.parent.parent.addNewTab("TaskPage", Labels['lblCR'],url);  
	window.open(url);
        return false;

    }
    var changeToolTip
    function showToolTip(eventObject, Id, change, tooltipType)
    {
		var target=eventObject.target;
	    if(target == null) 
		    target = eventObject.srcElement;
	    if (target.nodeName == 'A') return; 
		var htmlToolTip;
		
		if (tooltipType == 'Release') {
			////alert('type release : ' + tooltipType);
			htmlToolTip = getReleaseToolTip(Id);
		}
		else if (tooltipType == 'Task') {
			htmlToolTip = getTaskToolTip(Id);
		}
		else {
			////alert('type change : ' + tooltipType);
			if (change)
				htmlToolTip = getChangeToolTip(Id);
			else
				htmlToolTip = getBlackoutToolTip(Id);
		}
	    changeToolTip = new Ext.ToolTip({
			    target: target.id,
			    anchor: 'left',
			    width:tooltipType == 'Release'? 380:365,
			    shadow:false,
			    trackMouse: true,
			    bodyStyle:'font: 8pt Tahoma, Verdana, Arial; color:black;width:2%;border-color:black;',
			    dismissDelay: 60000,
				html:htmlToolTip
		    }); 
		   
		    if (!Ext.isIE)
		    {
              	changeToolTip.targetXY = [eventObject.pageX, eventObject.pageY]
                changeToolTip.show();
             }
    }
    
    function getChangeToolTip(changeId)
    {
		var arrChange, html='';
        if (typeof(ChangeRequestTooltip[changeId]) == 'undefined')
            html = '</span>' + Labels['lblChangeRequest'] + '</span>';
        else
        {
			arrChange = ChangeRequestTooltip[changeId].split('%#$#%');
			//if (arrChange.length != 10)
                //html = '<span>' + Labels['lblChangeRequest'] + '</span>';
            //else
            //{
				if (arrChange.length > 0){
					arrChange[1] = arrChange[1].replace(/>/g, '&gt;');
					arrChange[1] = arrChange[1].replace(/</g, '&lt;');
				}
				html = '<table class="ttipTable" cellpadding=4 cellspacing=3 border=0 width="350" style="table-layout:fixed">' + 
                '<tr><td class="ttipHeader1" width="33%">' + Labels['lblChangeRequest'] + '</td><td class="ttipHeader1" style="white-space:normal;">' + arrChange[0] + '</td></tr>' +
                '<tr><td colspan="2">&nbsp;</td></tr>' +
				'<tr><td class="ttipHeader2" >' + Labels['lblDescription'] + ':</td><td class="ttipLabel"></td></tr>' +
				'<tr><td colspan="2">' + arrChange[1].replace(/`n/g, '<br>') + '</td></tr>' +
				'<tr><td colspan="2">&nbsp;</td></tr>' +
                '<tr><td class="ttipHeader2" >' + Labels['lblStage'] + ':</td><td class="ttipLabel">' + arrChange[2] + '</td></tr>' +
                '<tr><td class="ttipHeader2" >' + Labels['lblStatus'] + ':</td><td class="ttipLabel">' + arrChange[3] + '</td></tr>' +
				'<tr><td class="ttipHeader2" >' + Labels['lblChangeType'] + ':</td><td class="ttipLabel">' + arrChange[4] + '</td></tr>' +
                '<tr><td class="ttipHeader2" >' + Labels['lblAssignedTo'] + ':</td><td class="ttipLabel">' + arrChange[5] + '</td></tr>' +
                '<tr><td class="ttipHeader2" >' + Labels['lblStartDate'] + ':</td><td class="ttipLabel">' + arrChange[6] + '</td></tr>' +
                '<tr><td class="ttipHeader2" >' + Labels['lblEndDate'] + ':</td><td class="ttipLabel">' + arrChange[7] + '</td></tr>' +
                '</table>';
            //}
            
        }
       return html; 
    }
    function getReleaseToolTip(releaseId)
    {
		////alert(typeof(ReleaseTooltip[releaseId]));
		var arrRelease, html='';
		if (typeof(ReleaseTooltip[releaseId]) == 'undefined')
            html = '</span>' + Labels['lblRelease'] + '</span>';
        else
        {
			arrRelease = ReleaseTooltip[releaseId].split('%#$#%');
			//if (arrRelease.length != 10)
            //    html = '<span>' + Labels['lblChangeRequest'] + '</span>';
            //else
            //{
				if (arrRelease.length > 0){
					arrRelease[1] = arrRelease[1].replace(/>/g, '&gt;');
					arrRelease[1] = arrRelease[1].replace(/</g, '&lt;');
				}
				html = '<table class="ttipTable" cellpadding=4 cellspacing=3 border=0 width="375" style="table-layout:fixed">' + 
                '<tr><td class="ttipHeader1" width="40%">' + Labels['lblRelease'] + '</td><td class="ttipHeader1" style="white-space:normal;">' + arrRelease[0] + '</td></tr>' +
				'<tr><td colspan="2">&nbsp;</td></tr>' +
                '<tr><td class="ttipHeader2" >' + Labels['lblDescription'] + ':</td><td class="ttipLabel"></td></tr>' +
				'<tr><td colspan="2">' + arrRelease[1].replace(/`n/g, '<br>') + '</td></tr>' +
				'<tr><td colspan="2">&nbsp;</td></tr>' +
				'<tr><td class="ttipHeader2" >' + Labels['lblStage'] + ':</td><td class="ttipLabel">' + arrRelease[2] + '</td></tr>' +
				'<tr><td class="ttipHeader2" >' + Labels['lblStatus'] + ':</td><td class="ttipLabel">' + arrRelease[3] + '</td></tr>' +
				'<tr><td class="ttipHeader2" >' + Labels['lblReleaseType'] + ':</td><td class="ttipLabel">' + arrRelease[4] + '</td></tr>' +
				'<tr><td class="ttipHeader2" >' + Labels['lblReleaseCoordinator'] + ':</td><td class="ttipLabel">' + arrRelease[5] + '</td></tr>' +
                '<tr><td class="ttipHeader2" >' + Labels['lblStartImplementation'] + ':</td><td class="ttipLabel">' + arrRelease[6] + '</td></tr>' +
				'<tr><td class="ttipHeader2" >' + Labels['lblEndImplementation'] + ':</td><td class="ttipLabel">' + arrRelease[7] + '</td></tr>' +
				'<tr><td class="ttipHeader2" >' + Labels['lblStartDeployment'] + ':</td><td class="ttipLabel">' + arrRelease[8] + '</td></tr>' +
				'<tr><td class="ttipHeader2" >' + Labels['lblEndDeployment'] + ':</td><td class="ttipLabel">' + arrRelease[9] + '</td></tr>' +
                '</table>';
            //}
            
        }
       return html; 
    }
	
	function getTaskToolTip(taskId)
    {
		var arrTask, html='';
		if (typeof(TaskTooltip[taskId]) == 'undefined')
            html = '</span>' + Labels['lblTask'] + '</span>';
        else
        {
			arrTask = TaskTooltip[taskId].split('%#$#%');
			if (arrTask.length > 0){
				arrTask[1] = arrTask[1].replace(/>/g, '&gt;');
				arrTask[1] = arrTask[1].replace(/</g, '&lt;');
			}
			html = '<table class="ttipTable" cellpadding=4 cellspacing=3 border=0 width="350" style="table-layout:fixed">' + 
			'<tr><td class="ttipHeader1" width="33%">' + Labels['lblTask'] + '</td><td class="ttipHeader1" style="white-space:normal;">' + arrTask[0] + '</td></tr>' +
			'<tr><td colspan="2">&nbsp;</td></tr>' +
			'<tr><td class="ttipHeader2" >' + Labels['lblDescription'] + ':</td><td class="ttipLabel"></td></tr>' +
			'<tr><td colspan="2">' + arrTask[1].replace(/`n/g, '<br>') + '</td></tr>' +
			'<tr><td colspan="2">&nbsp;</td></tr>' +
			'<tr><td class="ttipHeader2" >' + Labels['lblStage'] + ':</td><td class="ttipLabel">' + arrTask[2] + '</td></tr>' +
			'<tr><td class="ttipHeader2" >' + Labels['lblStatus'] + ':</td><td class="ttipLabel">' + arrTask[3] + '</td></tr>' +
			'<tr><td class="ttipHeader2" >' + Labels['lblTaskType'] + ':</td><td class="ttipLabel">' + arrTask[4] + '</td></tr>' + 
			'<tr><td class="ttipHeader2" >' + Labels['lblAssignedTo'] + ':</td><td class="ttipLabel">' + arrTask[5] + '</td></tr>' + 
			'<tr><td class="ttipHeader2" >' + Labels['lblScheduledStart'] + ':</td><td class="ttipLabel">' + arrTask[6] + '</td></tr>' +
			'<tr><td class="ttipHeader2" >' + Labels['lblScheduledEnd'] + ':</td><td class="ttipLabel">' + arrTask[7] + '</td></tr>' +
			'</table>';
        }
       return html; 
    }
	
    function getBlackoutToolTip(blackoutId)
    {
        var arrBlackouts, html = '';
        if (typeof(BOTooltip[blackoutId]) == 'undefined')
            html = '<span>' + Labels['lblPSO'] + '</span>';
        else
        {
            arrBlackouts = BOTooltip[blackoutId].split('%#$#%');
            if (arrBlackouts.length != 6)
                html = '<span>' + Labels['lblPSO'] + '</span>';
            else
            {
				if (arrBlackouts.length > 0){
					arrBlackouts[1] = arrBlackouts[1].replace(/>/g, '&gt;');
					arrBlackouts[1] = arrBlackouts[1].replace(/</g, '&lt;');
				}
                html = '<table class="ttipTable" cellpadding=3 cellspacing=3 border=0 width="350" style="table-layout:fixed">' + 
                '<tr><td class="ttipHeader1"  width="45%">' + Labels['lblName'] + '</td><td class="ttipHeader1"  style="white-space:normal;">' + arrBlackouts[0] + '</td></tr>' +
                '<tr><td colspan="2">' + arrBlackouts[1].replace(/`n/g, '<br>') + '</td></tr>' +
                '<tr><td class="ttipHeader2" >' + Labels['lblAffectedService'] + ':</td><td class="ttipLabel">' + arrBlackouts[2] + '</td></tr>' +
                '<tr><td class="ttipHeader2" >' + Labels['lblBOStartDate'] + ':</td><td class="ttipLabel">' + arrBlackouts[3] + '</td></tr>' +
                '<tr><td class="ttipHeader2" >' + Labels['lblBOEndDate'] + ':</td><td class="ttipLabel">' + arrBlackouts[4] + '</td></tr>' +
                '<tr><td class="ttipHeader2" >' + Labels['lblBlackoutPeriod'] + ':</td><td class="ttipLabel">' + ((arrBlackouts[5]=='1')? Labels['lblTrue'] :Labels['lblFalse']) + '</td></tr>' +
                '</table>';
            }
        }
       return html; 
    }
    
	
	// Task calendar related changes
	
function getTaskCalendarPanel()
{
	var inhtml = getTaskCalendarHTML();
    return (new Ext.Panel({
                layout:'fit',
                id:'taskCalendarPanel',
                html: inhtml,
				region: 'center',
                border: false
            }));
}

// Task calendar content here.
function getTaskCalendarHTML()
{
    var row, cell;
    var mainTable = document.createElement("table");
    mainTable.cellPadding = "0";
    mainTable.cellSpacing = "0";
    mainTable.id = "taskTable";
    mainTable.name = "taskTable";
    mainTable.width = "100%";
	
    row = mainTable.insertRow(0);
    cell = row.insertCell(0);
    //cell.appendChild(GetMainHeader());
    row = mainTable.insertRow(1);
    cell.appendChild(GetTaskCalendar());

    var div = document.createElement("div");
    div.id = 'taskdestroyer';
    div.appendChild(mainTable);
    return div.innerHTML;
}
function GetTaskCalendar()
{
	var row, cell;
	var calendarTable = document.createElement("table");
	calendarTable.id = "taskCalendarTable";
	calendarTable.name = "taskCalendarTable";
	calendarTable.style.tableLayout="fixed"
	calendarTable.cellPadding = "0";
	calendarTable.cellSpacing = "0";
	calendarTable.width = '100%';
	row = calendarTable.insertRow(calendarTable.rows.length);
	//GetCalendarHeader(row);
	return(calendarTable); 
}

function GetTaskCalendarData(calendarTable)
    {
		//alert('TaskGridData found ' + TaskGridData);
		var maxRows = TaskGridData.length;
        var row, cell, cellCount, maxTasks, taskId, taskNumber, taskType, iStart, iEnd, taskState, cellHTML, taskColor;
		gridData = [];
		for(var i=0; i<maxRows; i++)    //iterate thru rows
        {
            row = calendarTable.insertRow(calendarTable.rows.length);
            cellCount = 1;
			//alert(TaskGridData[i]);
            arrTasks = TaskGridData[i];
            maxTasks = arrTasks.length;
			if (maxRows == 1)
				row.style.height = '135px';
			else if (maxRows == 2)
				row.style.height = '115px';
			else if (maxRows == 3)
				row.style.height = '95px';
			else if (maxRows == 4)
				row.style.height = '75px';
			else if (maxRows == 5)
				row.style.height = '55px';
			else if (maxRows >= 6)
				row.style.height = '35px';
				
			//alert('maxTasks: ' +  maxTasks + ' ' + maxRows);
            for (var j=0; j<maxTasks; j++)    //iterate thru releases
            {
				if(maxTasks == 1 && maxRows == 1) 
					row.style.height = '135px';
				else
					row.style.height = '20px';
				var taskClass;
				taskId = arrTasks[j][0];
                taskNumber = arrTasks[j][1];
                taskType = arrTasks[j][2];
                iStart = arrTasks[j][3];
                iEnd = arrTasks[j][4];
                taskState = arrTasks[j][5];
				//alert(taskId + ' ' + taskNumber + ' ' + taskType + ' ' + iStart + ' ' + iEnd + ' ' + taskState + ' ' + arrTasks[j][6] + ' ' + arrTasks[j][7] + ' ' + arrTasks[j][8] + ' ' + arrTasks[j][9] + ' ' + arrTasks[j][10]);
                //gridData+='['+taskNumber+','+taskType+','+arrTasks[j][6]+','+arrTasks[j][7]+','+arrTasks[j][8]+','+arrTasks[j][9]+','+arrTasks[j][10]+']';
				
				var gridList = new Array(5);
				
				if(getStandardLayout()){
					var link='\'/'+taskId+'\'';
					gridList[0] = '<a href="#" onclick="window.open('+link+')">'
				}
				else
				gridList[0] = '<a href="#" onclick="openTaskForm(\'' + taskId + '\',\'' + taskNumber + '\')">' 
				
				gridList[0] += taskNumber + '</a>';
				gridList[1] = taskType;
				gridList[2] = arrTasks[j][6];//Category
				gridList[3] = arrTasks[j][7];//Description
				gridList[4] = arrTasks[j][8];//Status
				gridList[5] = arrTasks[j][9];//Scheduled Start Date
				gridList[6] = arrTasks[j][10];//Scheduled End Date
				gridData.push(gridList);
				
				cellHTML = '';
                //alert(cellCount + ' ' + maxColumns);
				taskClass = 'releaseLink';
                while (cellCount <= maxColumns)
                {
                    cell = row.insertCell(row.cells.length);
					////alert(cell + ' ' + cellCount + ' ' + iStart);
                    if (cellCount == iStart)
                    {
                        if (!taskState)
							taskColor = '#F2F2F2';
                        else if (typeof(TaskTypeColorArr['"'+Labels['lblOpenTask']+'"']) != 'undefined')
                            taskColor = TaskTypeColorArr['"'+Labels['lblOpenTask']+'"'];
                        else
                            taskColor = '#CCCCCC';
						if (!taskState)
                            cellHTML += '<s>';
						if(getStandardLayout()){
						
							var link='\'/'+taskId+'\'';
							cellHTML += '<a class="changeLink" onclick="window.open('+link+')">'
						}
						else
                        cellHTML += '<a class="changeLink" onclick="openTaskForm(\'' + taskId + '\',\'' + taskNumber + '\')">' 
                        cellHTML += taskNumber;
                        cellHTML += '</a>';
                        if (!taskState)
                            cellHTML += '</s>';
                        cell.id = 't_r' + i + 'c' + j;
                        cell.innerHTML = cellHTML;
						cell.className = 'changeRequest';
                        cell.bgColor = taskColor;
                        cell.colSpan = iEnd - iStart + 1;
                        var counter = cell.id;
						
						if (Ext.isIE)
							cell.onmouseover = new Function("showToolTip(event,'" + taskId + "', true, 'Task')");
						else
							cell.setAttribute('onmouseover', 'showToolTip(event, \''+ taskId +'\', true, \'Task\')');
						cellCount = iEnd + 1;
                        break;
                    }
                    else
                    {                        
						if ((cellCount-1) % 2 == 0)
							cell.className = 'alternateRow0';
						else
							cell.className = 'alternateRow1';
                    }
                    cellCount++;
                }
            }			
            while (cellCount <= maxColumns)
            {
                cell = row.insertCell(row.cells.length);
				if ((cellCount-1) % 2 == 0)
					cell.className = 'alternateRow0';
				else
					cell.className = 'alternateRow1';
                cellCount++;
            }
        }
        
    }
	
function reset(){
	Ext.getCmp('searchField').setValue('');
}

function search(){
	var text_to_search = Ext.getCmp('searchField').getValue();
	var tempstringtopass = encodeURIComponent(text_to_search.trim());
	if(tempstringtopass.length < 2){
		Ext.MessageBox.show({
			title: Labels['lblWarning'],
            msg:Labels['lblGsErrorMsg'],
			width:300,
			buttons: Ext.MessageBox.OK
		});
		return; 
	} else {
		var url = 'apex/KnowledgeSearch?calledFromForm=true&isCalendarSearch=true&search='+escape(tempstringtopass); 
		var stdLayoutScreenWidth = 1000;
		var stdLayoutScreenHeight = 400;
		var stdScreenLeft = parseInt((screen.availWidth/2) - (stdLayoutScreenWidth/2));
		var stdScreenTop = parseInt((screen.availHeight/2) - (stdLayoutScreenHeight/2));
		window.open(url,'_blank',"status = 1, height ="+stdLayoutScreenHeight +", width ="+stdLayoutScreenWidth +",left="+stdScreenLeft+",top="+stdScreenTop+", resizable = 1, scrollbars=no");
	}
}

function RemoveReserveCharactersForSOSL(value){
	var chars = new Array('?', '&', '|', '!', '{', '}', '[', ']', '(', ')', '^', '~', '*', ':', '\\', '"', '+', '-', '\'');
	for(var j = 0 ; j < chars.length; j++)
	{
		value = value.replace(chars[j],'');
	}
	return value;
}
function refreshGrid() {
	if(Ext.getCmp('grid') != null)
	Ext.getCmp('grid').getView().refresh();
}
