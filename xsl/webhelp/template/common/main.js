/**
 * main.js
 *
 * Developed by: Kasun Gajasinghe, David Cramer
 *
 */

$(document).ready(function() {

    $(function() {
            $("#tabs").tabs({
                cookie: {
                    // store cookie for 2 days.
                    expires: 2
                }
            });
        });
     
    $("#tree").treeview({
        collapsed: true,
        animated: "medium",
        control: "#sidetreecontrol",
        persist: "cookie"
    });

    $("#tocLoading").attr("style","display:none;");
    $("#tree").attr("style","display:block;"); 

    $(function() {
		$("button", ".searchButton").button();

		$("button", ".searchButton").click(function() { return false; });
	});

    /*var tabView = new YAHOO.widget.TabView('tabs');
    var tab0 = tabView.getTab(0);   //TOC tab
    var tab1 = tabView.getTab(1);   //Search tab

    tab0.addListener('click', tocTabClick);
    tab1.addListener('click', searchTabClick);
    */
    if ($.cookie('ui-tabs-1') === '1') { 
        if ($.cookie('textToSearch').length > 0) {
            document.getElementById('textToSearch').value = $.cookie('textToSearch');
            Verifie('diaSearch_Form');
        }
    } else {
        //tabView.selectTab(0);
    } 

    syncToc();

 //   $('#sync').click();


});

/**
 * Synchronize with the tableOfContents 
 */
function syncToc(){
    var a = document.getElementById("webhelp-currentid");
	var b = a.getElementsByTagName("a")[0];

    //Setting the background for selected node.
    var style = a.getAttribute("style");
    if(style != null && !style.match(/background-color: Background;/)){ 
        a.setAttribute("style", "background-color: #6495ed;  "+style);
		b.setAttribute("style", "color: white;");
    } else if(style != null){
        a.setAttribute("style", "background-color: #6495ed;  " + style);
		b.setAttribute("style", "color: white;");
    } else {
        a.setAttribute("style", "background-color: #6495ed;  ");        
		b.setAttribute("style", "color: white;");
    }

    //shows the node related to current content.
    //goes a recursive call from current node to ancestor nodes, displaying all of them.
	while (a.parentNode && a.parentNode.nodeName){
        var parentNode = a.parentNode;
        var nodeName = parentNode.nodeName;

        if(nodeName.toLowerCase() == "ul"){
            parentNode.setAttribute("style", "display: block;");
        } else if(nodeName.toLocaleLowerCase() == "li"){
            parentNode.setAttribute("class", "collapsable");
            parentNode.firstChild.setAttribute("class", "hitarea collapsable-hitarea ");
        } 
		a = parentNode;
	}
}