//<!--
/***********************************************************
 *** Author : Gihan Karunarathne                         ***
 *** Email : gckarunarathne@gmail.com                    ***
 *** Last Modified Date : 23 March 2013                 ***
 ***********************************************************/
/**
* Description :
* MORE DETAILS : https://github.com/carhartl/jquery-cookie/
* 
* Changed log:
* Changed current cookie storage with  HTML5 localstorage due to cookies are
* not working properly on devices.
*/

/**
 * When a page is loading apply the mobile-settings
 */
$("div[data-role*='page']").live('pageinit',function(){
  //apply font-size to page
  if (mobile.getMobileValue('font-size') === null) {
    //console.log(mobile.getMobileValue('font-size'));
    //alert("init cookie");
    mobile.setDefFontSize();
    $("html").css('font-size', mobile.getMobileValue('font-size'));
    $(".ui-header .ui-title, .ui-footer .ui-title").css('font-size',mobile.getMobileValue('font-size'));
    //alert(String.concat("ccccccccccc now cookie is " ,mobile.getMobileValue('font-size')));
  }else{
    $("html").css('font-size', mobile.getMobileValue('font-size'));
    $(".ui-header .ui-title, .ui-footer .ui-title").css('font-size',mobile.getMobileValue('font-size'));
    //alert(String.concat("dddddddddddddddddddd now cookie is " ,mobile.getMobileValue('font-size')));
  }
  //apply font-family to page
  if (mobile.getMobileValue('font-family') === null) {
    mobile.setDefFontFamily();
    $("html").css('font-family', mobile.getMobileValue('font-family'));
  }else{
    $("html").css('font-family', mobile.getMobileValue('font-family'));
  }
  /**************************************/
  if (mobile.getMobileValue('menubardirection') === null ){
    mobile.setDefmenubardirection();
  }
  if (mobile.getMobileValue('tocdirection') === null ){
    mobile.setDeftocdirection();
  }
  /*************************************/
  if (mobile.getMobileValue('popupmenubar') === null ){
    mobile.setDefpopupmenubar();
  }
  if (mobile.getMobileValue('popuptoc') === null ){
    mobile.setDefpopuptoc();
  }
  /* Page navigation *******************/
  if (mobile.getMobileValue("prevpage") === null ){
    console.log(mobile.getMobileValue("prevpage"));
    mobile.setDefPrevPage();
  }
  if (mobile.getMobileValue("nextpage") === null ){
    mobile.setDefNextPage();
  }

});

/********************************************************************************
 * Default settings for cookies.                                               **
 * When cookie value is not set,these will be called and set there value.      **
 * Also,user can set them later                                                **.
 ********************************************************************************/
var mobile = new function(){
  // set the default expire days for cookies (in days)
  this.defExpireDays = 7;
  // set default domain/path name for access cookies
  this.defDomainPath = '/';
  // set default font-size
  this.defFontSize = '12px';
  // set default font-family
  this.defFontFamily = 'Helvetica';
  // set default menubar direction
  this.defmenubardirection ='swipeUp';
  // set default toc direction
  this.deftocdirection = 'swipeDown';
// set default popup menubar
  this.defpopupmenubar = 'showMenuBar';
// set default pop up toc
  this.defpopuptoc = 'showtoc';
// set defaulf Prev Page swipe direction
  this.defPrevPage = 'swipeRight';
// set defaulf Next Page swipe direction
  this.defNextPage = 'swipeLeft';
// remember-search-word
  this.defremembersearchword = 'remembersearchword';
  
  /**
   * For user defined settings
   */
   
  // set the expire days for cookies (in days)
  this.expireDays = 7;
  // set domain/path name for access cookies
  this.domainPath = '/';

  /**
  * Default value for font-size
  */
  this.setDefFontSize = function(){
    this.setDefMobileValue('font-size',mobile.defFontSize);
  }
  /**
  * Default value for font-family
  */
  this.setDefFontFamily = function(){
    this.setDefMobileValue('font-family' , mobile.defFontFamily);
  }
  /**********************************************
  * Default value for menubardirection
  */
  this.setDefmenubardirection = function(){
    this.setDefMobileValue('menubardirection' , mobile.defmenubardirection);
  }
  /**
  * Default value for tocdirection
  */
  this.setDeftocdirection = function(){
    this.setDefMobileValue('tocdirection' , mobile.deftocdirection);
  }
  /**********************************************
  * Default value for popupmenubar
  */
  this.setDefpopupmenubar = function(){
    this.setDefMobileValue('popupmenubar' , mobile.defpopupmenubar);
  }
  /**
  * Default value for popuptoc
  */
  this.setDefpopuptoc = function(){
    this.setDefMobileValue('popuptoc' , mobile.defpopuptoc);
  }
  /***********************************************
  * Default value for Prev Page swipe direction
  */
  this.setDefPrevPage = function(){
    this.setDefMobileValue("prevpage" , mobile.defPrevPage);
  }
  /**
  * Default value for Next Page swipe direction
  */
  this.setDefNextPage = function(){
    this.setDefMobileValue("nextpage" , mobile.defNextPage);
  }
  /************Advance settings ************/
 
  /**
   * Default value for remembersearchword
   */
  this.setDefremembersearchword = function(){
    this.setDefMobileValue('remembersearchword' , mobile.defremembersearchword);
  }

 /**********************************************
 * Recurring method for set default values
 * Developer can choose any method /(Cookies,
 * localStorage or new method) easily.
 **********************************************/

  /**
  * Recurring method for get user's values
  */
  this.getMobileValue = function($name){
    return localStorage.getItem($name);
    // uncomment as necessary
    /* return $.cookie($name); */
  }

  /**
  * Recurring method for set user's values
  */
  this.setDefMobileValue = function($name,$value){
    localStorage.setItem($name,$value);
    // uncomment as necesary
    /* $.cookie($name , $value , {
      expires: this.defExpireDays,
      path: this.defDomainPath
    }); */
  }
  this.setMobileValue = function($name,$value){
    localStorage.setItem($name,$value);
    // uncomment as necessary
    /* $.cookie($name , $value , {
      expires: this.expireDays,
      path: this.domainPath
    }); */
  }

}

/************************************************************************
 * Set the User defined values                                        ***
 ***********************************************************************/

$(document).bind('pageinit',function () {

  $("#select-menu-bar-direction").bind("change", function (event, ui) {
    try {
      mobile.setMobileValue('menubardirection', $("#select-menu-bar-direction").val() );
      if(mobile.getMobileValue('menubardirection')=== mobile.getMobileValue('tocdirection') ){
        if( "swipeUp"===mobile.getMobileValue('menubardirection') ){
          mobile.setMobileValue('tocdirection',"swipeDown");
        }else if( "swipeDown"===mobile.getMobileValue('menubardirection') ){
          mobile.setMobileValue('tocdirection',"swipeUp");
        }
        // refresh page after reset values
        refreshSelectMenus();
      }
        //alert(String.concat("cookie is created with ",$("#select-menu-bar-direction").val()," and now cookie is " ,mobile.getMobileValue('menubardirection')));
    } catch (err) {
      txt = "There was an error on this page.\n\n";
      txt += "Error description: " + err.message + "\n\n";
      txt += "Click OK to continue.\n\n";
      //alert(txt);
      $('#warningMSG').html(txt);
      $('#showDialog').click();
    }

  });


  $("#select-toc-direction").bind("change", function (event, ui) {
    try {
      mobile.setMobileValue('tocdirection', $("#select-toc-direction").val());
      if(mobile.getMobileValue('menubardirection')=== mobile.getMobileValue('tocdirection') ){
        if( "swipeUp"===mobile.getMobileValue('tocdirection') ){
          mobile.setMobileValue('menubardirection',"swipeDown");
        }else if( "swipeDown"===mobile.getMobileValue('tocdirection') ){
          mobile.setMobileValue('menubardirection',"swipeUp");
        }
        // refresh page after reset values
        refreshSelectMenus();
      }  
        //alert(String.concat("cookie is created with ",$("#select-toc-direction").val()," and now cookie is " ,mobile.getMobileValue('tocdirection')));
    } catch (err) {
      txt = "There was an error on this page.\n\n";
      txt += "Error description: " + err.message + "\n\n";
      txt += "Click OK to continue.\n\n";
      //alert(txt);
      $('#warningMSG').html(txt);
      $('#showDialog').click();
    }
  });
  
  /************ pop up menus **************************************/
  $("#select-pop-up-menu-bar").bind("change", function (event, ui) {
    try {
      mobile.setMobileValue('popupmenubar', $("#select-pop-up-menu-bar").val());
      //alert(String.concat("cookie is created with ",$("#select-pop-up-menu-bar").val()," and now cookie is " ,mobile.getMobileValue('popupmenubar')));
    } catch (err) {
      txt = "There was an error on this page.\n\n";
      txt += "Error description: " + err.message + "\n\n";
      txt += "Click OK to continue.\n\n";
      //alert(txt);
      $('#warningMSG').html(txt);
      $('#showDialog').click();
    }
  });


  $("#select-pop-up-toc").bind("change", function (event, ui) {
    try {
      mobile.setMobileValue('popuptoc', $("#select-pop-up-toc").val());
      //alert(String.concat("cookie is created with ",$("#select-pop-up-toc").val()," and now cookie is " ,mobile.getMobileValue('popuptoc')));
    } catch (err) {
      txt = "There was an error on this page.\n\n";
      txt += "Error description: " + err.message + "\n\n";
      txt += "Click OK to continue.\n\n";
      //alert(txt);
      $('#warningMSG').html(txt);
      $('#showDialog').click();
    }
  });

  /*************************** page navigation ******************************/

  $("#select-prev-page-direction").bind("change", function (event, ui) {
    try {
        mobile.setMobileValue("prevpage", $("#select-prev-page-direction").val());
        if(mobile.getMobileValue("nextpage")=== mobile.getMobileValue("prevpage") ){
          if( "swipeRight"=== mobile.getMobileValue("prevpage") ){
            mobile.setMobileValue("nextpage","swipeLeft");
          }else if( "swipeLeft"=== mobile.getMobileValue("prevpage") ){
            mobile.setMobileValue("nextpage","swipeRight");
          }
          // refresh page after reset values
          refreshSelectMenus();
          //alert("Prev page pp:"+mobile.getMobileValue("prevpage")+" np:"+mobile.getMobileValue("nextpage"));
        }
        //alert(String.concat("cookie is created with ",$("#select-prev-page-direction").val()," and now cookie is " ,mobile.getMobileValue('prevpage')));
    } catch (err) {
      txt = "There was an error on this page.\n\n";
      txt += "Error description: " + err.message + "\n\n";
      txt += "Click OK to continue.\n\n";
      //alert(txt);
      $('#warningMSG').html(txt);
      $('#showDialog').click();
    }
  });


  $("#select-next-page-direction").bind("change", function (event, ui) {
    try {
      mobile.setMobileValue("nextpage", $("#select-next-page-direction").val());
      if(mobile.getMobileValue("nextpage")=== mobile.getMobileValue("prevpage") ){
          if( "swipeRight"=== mobile.getMobileValue("nextpage") ){
            mobile.setMobileValue("prevpage","swipeLeft");
          }else if( "swipeLeft"=== mobile.getMobileValue("nextpage") ){
            mobile.getMobileValue("prevpage","swipeRight");
          }
        // refresh page after reset values
        refreshSelectMenus();
        //alert("Prev page pp:"+mobile.getMobileValue("prevpage")+" np:"+mobile.getMobileValue("nextpage"));
        }
      //alert(String.concat("cookie is created with ",$("#select-next-page-direction").val()," and now cookie is " ,mobile.getMobileValue('nextpage')));
    } catch (err) {
      txt = "There was an error on this page.\n\n";
      txt += "Error description: " + err.message + "\n\n";
      txt += "Click OK to continue.\n\n";
      //alert(txt);
      $('#warningMSG').html(txt);
      $('#showDialog').click();
    }
  });

  /*************************************************************************************
   **       Advance Settings                                                          **
   *************************************************************************************/

  $("#remember-search-word").bind("change", function (event, ui) {
    //alert("lets rem page");
    try {
      mobile.setMobileValue('remembersearchword', $("#remember-search-word").val());
      //alert(String.concat("cookie is created with ",$("#remember-search-word").val()," and now cookie is " ,mobile.getMobileValue('remembersearchword')));
      //document.getElementById("btest").innerHTML = mobile.getMobileValue('remembersearchword');
    } catch (err) {
      txt = "There was an error on this page.\n\n";
      txt += "Error description: " + err.message + "\n\n";
      txt += "Click OK to continue.\n\n";
      //alert(txt);
      $('#warningMSG').html(txt);
      $('#showDialog').click();
    }
  });

  $("#voice-search").bind("change", function (event, ui) {
    //alert("lets do voice search");
    try {
      mobile.setMobileValue('voicesearch', $("#voice-search").val());
      //alert(String.concat("cookie is created with ",$("#voice-search").val()," and now cookie is " ,mobile.getMobileValue('voicesearch')));
      //document.getElementById("btest").innerHTML = mobile.getMobileValue('voicesearch');
    } catch (err) {
      txt = "There was an error on this page.\n\n";
      txt += "Error description: " + err.message + "\n\n";
      txt += "Click OK to continue.\n\n";
      //alert(txt);
      $('#warningMSG').html(txt);
      $('#showDialog').click();
    }
  });
  
  // reset Values to default values when click "Reset" button
  $("#reset-settings").bind("change", function (event, ui) {
    alert("reset");
    mobile.setDefFontSize();
    mobile.setDefFontFamily();
    mobile.setDefmenubardirection();
    mobile.setDeftocdirection();
    mobile.setDefpopupmenubar();
    mobile.setDefpopuptoc();
    mobile.setDefPrevPage();
    mobile.setDefNextPage();
    // refresh page after reset values
    refreshSelectMenus();
    
  });
  
});


// for testing purposes of cookies
/*function getcookie(){
	var nameVal = document.forms['cookieform'].cookievalue.val();
	//var nameVal = 'name';
	$("find").innerHTML=nameVal;
	$("test").innerHTML=mobile.getMobileValue(nameVal);
} */

//-->