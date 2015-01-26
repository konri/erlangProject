makeStore = ->
      store = Ext.create("Ext.data.Store",
      autoLoad : true
fields : ["name","status"]
proxy :
type : "ajax"
url : "getAllStatus.yaws"
reader :
type: "json"
root: "data"
)
console.log(store)
store
setupMultiCast = ->
store = makeStore()
form = Ext.create("Ext.form.Panel",
    buttons:
    {
      xtype: "button"
      text: "Set Status"
      handler: () ->
  values = form.getValues()
console.log(values)
Ext.Ajax.request(
    url: "setStatus.yaws",
    params: values
success: () ->
store.load()
alert("Data Reloaded")
)
}
title: "Set Status"
items: [
{
xtype : "textfield"
name : "name"
fieldLabel : "User"
width : 400
}
{
xtype : "textarea"
name : "status"
fieldLabel : "Status"
width : 400
}
]
)
grid = Ext.create("Ext.grid.Panel",
    width : 500
height : 350,
frame : true
renderTo : "multi_cast"
store : store
title : "User Status"
bbar : form
buttons : [
{
text: "Reload"
handler: () -> store.load()

}]
columns:
[
{
text: "User"
width: 80
sortable: true
dataIndex: "name"
}
{
text: "Status"
dataIndex: "status"
sortable: true
width: 300
}
]
)
