// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults



    
  



function ismaxlength(obj){
           var mlength=obj.getAttribute? parseInt(obj.getAttribute("maxlength")) : ""
            if (obj.getAttribute && obj.value.length>mlength)
                obj.value=obj.value.substring(0,mlength)
        }


function validate(){

var pwd = document.getElementById('password').value;
var c_pwd = document.getElementById('password_confirmation').value;
if ( pwd == c_pwd && (pwd.length>4))
{
document.getElementById('Change_password').style.display= 'block';
}
else{
document.getElementById('msg_validate').innerHTML="Password and confirmation password too short";
}
}
function valid(number_of_group,new_group,select_new_plan,old_plan)
{
if (number_of_group > new_group )
{
alert("You can only switch to this plan if you have  " + new_group + " active groups. Please suspend at least " + (number_of_group-new_group) + " groups.");
document.getElementById('user_plan_'+select_new_plan).checked=false
document.getElementById('user_plan_'+old_plan).checked=true
}
else
{
}
}
 function imagefirst()
    {
      document.getElementById("img").src ="/images/up_arrow.png";
      document.getElementById("img3").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img4").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img5").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img1").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img2").src = "/images/blue_up_arrow.jpg";
    }
     function imagesecond()
    {
      document.getElementById("img1").src ="/images/up_arrow.png";
      document.getElementById("img3").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img4").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img5").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img2").src = "/images/blue_up_arrow.jpg";
    }
    function imagethird()
    {
      document.getElementById("img2").src ="/images/up_arrow.png";
      document.getElementById("img3").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img4").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img5").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img1").src = "/images/blue_up_arrow.jpg";
    }
    function imagefour()
    {
      document.getElementById("img3").src ="/images/down_arrow.png";
      document.getElementById("img4").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img5").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img1").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img2").src = "/images/blue_up_arrow.jpg";
    }
     function imagefive()
    {
      document.getElementById("img4").src ="/images/down_arrow.png";
      document.getElementById("img1").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img5").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img3").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img2").src = "/images/blue_up_arrow.jpg";
    }
   function imagesix()
    {  document.getElementById("img5").src ="/images/down_arrow.png";
       document.getElementById("img2").src = "/images/blue_up_arrow.jpg";
       document.getElementById("img1").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img3").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img4").src = "/images/blue_down_arrow.jpg";
   
    }
    function imagecreat()
    {
    inital();
    document.getElementById("img_creat1").src ="/images/up_arrow.png";
    document.getElementById("img_creat2").src ="/images/blue_down_arrow.jpg";
    document.getElementById("img_active2").src="/images/blue_down_arrow.jpg"
    document.getElementById("img_active1").src="/images/blue_up_arrow.jpg"
   }
   function imageactive()
  {
  inital();
    document.getElementById("img_active1").src="/images/up_arrow.png"
    document.getElementById("img_active2").src="/images/blue_down_arrow.jpg"
    document.getElementById("img_creat1").src ="/images/blue_up_arrow.jpg";
    document.getElementById("img_creat2").src ="/images/blue_down_arrow.jpg";
 }   
 function imagecreat1()
  {
  inital();
    document.getElementById("img_creat2").src="/images/down_arrow.png"
    document.getElementById("img_creat1").src="/images/blue_up_arrow.jpg"
    document.getElementById("img_active1").src ="/images/blue_up_arrow.jpg";
    document.getElementById("img_active2").src ="/images/blue_down_arrow.jpg";
 }
 
 function imageactive1()
 {
 inital();
    document.getElementById("img_active2").src="/images/down_arrow.png"
    document.getElementById("img_active1").src="/images/blue_up_arrow.jpg"
    document.getElementById("img_creat1").src ="/images/blue_up_arrow.jpg";
    document.getElementById("img_creat2").src ="/images/blue_down_arrow.jpg";
 }
   function inital()
   {
    document.getElementById("img5").src ="/images/blue_down_arrow.jpg";
    document.getElementById("img2").src = "/images/blue_up_arrow.jpg";
    document.getElementById("img1").src = "/images/blue_up_arrow.jpg";
    document.getElementById("img").src = "/images/blue_up_arrow.jpg";
    document.getElementById("img3").src = "/images/blue_down_arrow.jpg";
    document.getElementById("img4").src = "/images/blue_down_arrow.jpg";
  }
  function groupnames()
  {
    document.getElementById("agroupname").src="/images/down_arrow.jpg";
  }

function createdat()
{
document.getElementById("acreated_at").src="/images/down_arrow.jpg";
}
    function firstname()
    {
    document.getElementById("afirstname").src="/images/down_arrow.jpg";
    }

 function isactive()
    {
    document.getElementById("ais_active").src="/images/down_arrow.jpg";
    }

//check the textarea empty
 function is_comment_empty()
  {
 	if (document.getElementById("comment").value=="")
        {
            	document.getElementById("comment_error").innerHTML="Please enter the comment";
            	return false;
	}
	else
	{
		return true;
	}
  }
//select all
function check_all_in_document()
{
  var c = new Array();
  c = document.getElementsByTagName('input');
  for (var i = 0; i < c.length; i++)
  {
    if (c[i].type == 'checkbox')
    {
      c[i].checked = true;
    }
  }
}
// group owners
function addOwner(count){
  var c = new Array();
  c = document.getElementsByTagName('input');
  var member_name=new Array();
  var member_id="";
  var k=false;
  var j=1;
  var name="";
   document.getElementById('hide'+count).innerHTML ="";
  for (var i = 0; i < c.length; i++)
  {
    if (c[i].type == 'checkbox')
    {
      if(c[i].checked == true)
      {
        member_name[j]=c[i].name
        name=name+c[i].name+' ,';
        member_id+=c[i].value+",";
        k=true;
        j++;
      }
    }
  }
  if (k==true)
  {
    document.getElementById('hide'+count).innerHTML='<input type=hidden name=objective'+count+'[owners] id=member'+count+' value='+member_id+' />';
    document.getElementById('owners'+count).innerHTML =name;
    document.getElementById('modal_container').style.display='none';
    document.getElementById('modal_overlay').style.display='none';
    return true;
  }
  else
  {
    document.getElementById('check_boxx_error').innerHTML = "Please select atleast one member";
    return false;
  }
}
//check wether the checkboxes checked in group info
function check_checkboxes_checked(){
var c = new Array();
var k=false;
  c = document.getElementsByTagName('input');
  for (var i = 0; i < c.length; i++)
  {
    if (c[i].type == 'checkbox' && c[i].checked == true)
    {
      k=true;
    }
  }
  if (k==true)
  {return true;}
  else
  {
	if ($('check_boxx_error')==null){
	document.getElementById('check_error').innerHTML = "Please select atleast one group";
 	return false;
	}
	else
	{
	document.getElementById('check_boxx_error').innerHTML = "Please select atleast one member";
  	return false;
  	}
   }
}

function check_location()
{
  var x = (document.getElementById('All Locations').checked);
  if (x==true)
  {
	document.getElementById('status_update_search').checked=true;
  document.getElementById('message').checked=true;
  document.getElementById('goal_obj').checked=true;
  }
  else
  {
  	document.getElementById('status_update_search').checked=false;
  document.getElementById('message').checked=false;
  document.getElementById('goal_obj').checked=false;
  }
}
function check_groups(groups)
{
  var x = (document.getElementById("All Groups").checked);
 if (x==true)
 {
for (i=1;i<=groups;i++)
	document.getElementById('groups['+i+']').checked=true;
  }
  else
  for (i=1;i<=groups;i++)
	document.getElementById('groups['+i+']').checked=false;
}
function single_groups()
{
document.getElementById('All Groups').checked=false;
}
function uncheck_locations()
{
document.getElementById('all_locations').checked=false;
}

function check_values()
{
if (document.getElementById('searchs').value=="") 
{
alert("Please enter the keyword");
 }
else
{
$("search_advanced").href="/searchs/group_list"
  new Control.Modal($("search_advanced"), {className:'modal_container'});
}
}
function basic_shown()
{
	document.getElementById('basic_search').visibility=true;
}
function simple_search()
{
if (document.getElementById('searchs').value=="") 
{
alert("Please enter the keyword");
return false;
}
else
{
return true;
}
}

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function ismaxlength(obj){
           var mlength=obj.getAttribute? parseInt(obj.getAttribute("maxlength")) : ""
            if (obj.getAttribute && obj.value.length>mlength)
                obj.value=obj.value.substring(0,mlength)
        }




function validate(){

var pwd = document.getElementById('password').value;
var c_pwd = document.getElementById('password_confirmation').value;
if ( pwd == c_pwd && (pwd.length>4))
{
document.getElementById('Change_password').style.display= 'block';
}
else{
document.getElementById('msg_validate').innerHTML="Password and confirmation password too short";
}
}
function valid(number_of_group,new_group,select_new_plan,old_plan)
{
if (number_of_group > new_group )
{
alert("You can only switch to this plan if you have  " + new_group + " active groups. Please suspend at least " + (number_of_group-new_group) + " groups.");
document.getElementById('user_plan_'+select_new_plan).checked=false
document.getElementById('user_plan_'+old_plan).checked=true

}
else
{
}
}

 function imagefirst()
    {
      document.getElementById("img").src ="/images/up_arrow.png";
      document.getElementById("img3").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img4").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img5").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img1").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img2").src = "/images/blue_up_arrow.jpg";
    }
     function imagesecond()
    {
      document.getElementById("img1").src ="/images/up_arrow.png";
      document.getElementById("img3").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img4").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img5").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img2").src = "/images/blue_up_arrow.jpg";
    }
    function imagethird()
    {
      document.getElementById("img2").src ="/images/up_arrow.png";
      document.getElementById("img3").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img4").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img5").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img1").src = "/images/blue_up_arrow.jpg";
    }
    function imagefour()
    {
      document.getElementById("img3").src ="/images/down_arrow.png";
      document.getElementById("img4").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img5").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img1").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img2").src = "/images/blue_up_arrow.jpg";
    }
     function imagefive()
    {
      document.getElementById("img4").src ="/images/down_arrow.png";
      document.getElementById("img1").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img5").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img3").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img2").src = "/images/blue_up_arrow.jpg";
    }
   function imagesix()
    {  document.getElementById("img5").src ="/images/down_arrow.png";
       document.getElementById("img2").src = "/images/blue_up_arrow.jpg";
       document.getElementById("img1").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img").src = "/images/blue_up_arrow.jpg";
      document.getElementById("img3").src = "/images/blue_down_arrow.jpg";
      document.getElementById("img4").src = "/images/blue_down_arrow.jpg";
   
    }
    function imagecreat()
    {
    inital();
    document.getElementById("img_creat1").src ="/images/up_arrow.png";
    document.getElementById("img_creat2").src ="/images/blue_down_arrow.jpg";
    document.getElementById("img_active2").src="/images/blue_down_arrow.jpg"
    document.getElementById("img_active1").src="/images/blue_up_arrow.jpg"
   }
   function imageactive()
  {
  inital();
    document.getElementById("img_active1").src="/images/up_arrow.png"
    document.getElementById("img_active2").src="/images/blue_down_arrow.jpg"
    document.getElementById("img_creat1").src ="/images/blue_up_arrow.jpg";
    document.getElementById("img_creat2").src ="/images/blue_down_arrow.jpg";
 }   
 function imagecreat1()
  {
  inital();
    document.getElementById("img_creat2").src="/images/down_arrow.png"
    document.getElementById("img_creat1").src="/images/blue_up_arrow.jpg"
    document.getElementById("img_active1").src ="/images/blue_up_arrow.jpg";
    document.getElementById("img_active2").src ="/images/blue_down_arrow.jpg";
 }
 
 function imageactive1()
 {
 inital();
    document.getElementById("img_active2").src="/images/down_arrow.png"
    document.getElementById("img_active1").src="/images/blue_up_arrow.jpg"
    document.getElementById("img_creat1").src ="/images/blue_up_arrow.jpg";
    document.getElementById("img_creat2").src ="/images/blue_down_arrow.jpg";
 }
   function inital()
   {
    document.getElementById("img5").src ="/images/blue_down_arrow.jpg";
    document.getElementById("img2").src = "/images/blue_up_arrow.jpg";
    document.getElementById("img1").src = "/images/blue_up_arrow.jpg";
    document.getElementById("img").src = "/images/blue_up_arrow.jpg";
    document.getElementById("img3").src = "/images/blue_down_arrow.jpg";
    document.getElementById("img4").src = "/images/blue_down_arrow.jpg";
  }
  function groupnames()
  {
  
  document.getElementById("agroupname").src="/images/down_arrow.jpg";
  }

function createdat()
{
document.getElementById("acreated_at").src="/images/down_arrow.jpg";
}
    function firstname()
    {
    document.getElementById("afirstname").src="/images/down_arrow.jpg";
    }

 function isactive()
    {
    document.getElementById("ais_active").src="/images/down_arrow.jpg";
    }

//check the textarea empty
 function is_comment_empty()
  {
 	if (document.getElementById("comment").value=="")
        {
            	document.getElementById("comment_error").innerHTML="Please enter the comment";
            	return false;
	}
	else
	{
		return true;
	}
  }
//select all
function check_all_in_document()
{
  var c = new Array();
  c = document.getElementsByTagName('input');
  for (var i = 0; i < c.length; i++)
  {
    if (c[i].type == 'checkbox')
    {
      c[i].checked = true;
    }
  }
}



function select_all_in_form(form)
{
  var n=$(form).elements.length;
  var i;
  for(i=0;i<n;i++)
  {
    if ($(form).elements[i].type=="checkbox")
    {
      ($(form).elements[i].checked=true)
    }
  }
}

function deselect_all_in_form(form)
{
  var n=$(form).elements.length;
  var i;
  for(i=0;i<n;i++)
  {
    if ($(form).elements[i].type=="checkbox")
    {
      ($(form).elements[i].checked=false)
    }
  }
}




// group owners
function addOwner(count){
  var c = new Array();
  c = document.getElementsByTagName('input');
  var member_name=new Array();
  var member_id="";
  var k=false;
  var j=1;
  var name="";
   document.getElementById('hide'+count).innerHTML ="";
  for (var i = 0; i < c.length; i++)
  {
    if (c[i].type == 'checkbox')
    {
      if(c[i].checked == true)
      {
        member_name[j]=c[i].name
        name=name+c[i].name+' ,';
        member_id+=c[i].value+",";
        k=true;
        j++;
      }
    }
  }
  if (k==true)
  {
    document.getElementById('hide'+count).innerHTML='<input type=hidden name=objective'+count+'[owners] id=member'+count+' value='+member_id+' />';
    document.getElementById('owners'+count).innerHTML =name;
    document.getElementById('modal_container').style.display='none';
    document.getElementById('modal_overlay').style.display='none';
    return true;
  }
  else
  {
    document.getElementById('check_boxx_error').innerHTML = "Please select atleast one member";
    return false;
  }
}
//check wether the checkboxes checked in group info
function check_checkboxes_checked(){
var c = new Array();
var k=false;
  c = document.getElementsByTagName('input');
  for (var i = 0; i < c.length; i++)
  {
    if (c[i].type == 'checkbox' && c[i].checked == true)
    {
      k=true;
    }
  }
  if (k==true)
  {return true;}
  else
  {
	if ($('check_boxx_error')==null){
	document.getElementById('check_error').innerHTML = "Please select atleast one group";
 	return false;
	}
	else
	{
	document.getElementById('check_boxx_error').innerHTML = "Please select atleast one member";
  	return false;
  	}
   }
}

function check_search_checked(form){
var n=$(form).elements.length;
var i;
var k=false;
  for(i=0;i<n;i++)
  {
    if ($(form).elements[i].type=="checkbox")
    {
      if($(form).elements[i].checked==true)
	{k=true;}
    }
  }
if (k==true)
  {return true;}
  else
  {
	$('check_error').innerHTML = "Please select atleast one option";
  	return false;
   }
}


function check_value_status(active){
  if (active=="true")
  {
    if ($("status").value=="")
    {
      alert("Please enter the Status");
      return false;
    }
    else
    {return true;}
  }
  else
  {
    alert("Sorry, Group is not active, you cannot post update to this group.");
    return false;
  }
}


function check_advanced_share(form){
  var n=$(form).elements.length;
  var i;
  var k=false;
  var post=false;
  for(i=0;i<n;i++)
  {
    if ($(form).elements[i].type=="checkbox" && $(form).elements[i].id!="post" )
    {
      if($(form).elements[i].checked==true)
	{k=true;}
    }
  }
  if (k==true)
  { post=confirm('Do you really want to post your status updates to these group(s)?');
    if(post==true)
     {return true;}
    else
     {return false;}
  }
  else
  {
    $('check_error').innerHTML = "Please select atleast one group";
    return false;
  }
}




function check_location()
{
  var x = (document.getElementById('All Locations').checked);
  if (x==true)
  {
	document.getElementById('status_update_search').checked=true;
  document.getElementById('message').checked=true;
  document.getElementById('goal_obj').checked=true;
  }
  else
  {
  document.getElementById('status_update_search').checked=false;
  document.getElementById('message').checked=false;
  document.getElementById('goal_obj').checked=false;
  }
}

function check_groups(groups)
{
  var x = (document.getElementById("All Groups").checked);
 if (x==true)
 {
for (i=1;i<=groups;i++)
	document.getElementById('group['+i+']').checked=true;
  }
  else
  for (i=1;i<=groups;i++)
	document.getElementById('group['+i+']').checked=false;
}
function single_groups()
{
document.getElementById('All Groups').checked=false;
}
function uncheck_locations()
{
document.getElementById('all_locations').checked=false;
document.getElementById('All Locations').checked=false;

}
function basic_shown()
{
	document.getElementById('basic_search').visibility=true;
}
function simple_search()
{
if (document.getElementById('searchs').value=="") 
{
alert("Please enter the keyword");
return false;
}
else
{
return true;
}
}
function check_basic_location()
{
var x = (document.getElementById('all_locations').checked);
  if (x==true)
  {
	document.getElementById('status_update_basic_search').checked=true;
  document.getElementById('message_basic').checked=true;
  document.getElementById('goal_obj_basic').checked=true;
  }
  else
  {
  document.getElementById('status_update_basic_search').checked=false;
  document.getElementById('message_basic').checked=false;
  document.getElementById('goal_obj_basic').checked=false;
  }
}

function confirmation()
{
var sure= confirm("Do you really want to post your status updates to these group(s)?");
if (sure==true)
{
return true;
}
else
{
return false;
}
}
function check_checkboxes_status(){
var c = new Array();
var k=false;
  c = document.getElementsByTagName('input');
  for (var i = 0; i < c.length; i++)
  {
    if (c[i].type == 'checkbox' && c[i].checked == true)
    {
      k=true;
    }
  }
  if (k==true)
  {
	var sure= confirm("Do you really want to post your status updates to these group(s)?");
	if (sure==true)
	{
	   return true;
	}
	else
	{
	   return false;
	}
  }
  else
  {
	if ($('check_boxx_error')==null){
	document.getElementById('check_error').innerHTML = "Please select atleast one group";
 	return false;
	}
   }
}


function validate()
//{
//if ($("message_recipient").value=="")
//{alert("hi");}
//else
{
document.forms["reply"].submit();
}


function dropdown()
{
$("rec_name").style.visibility="visible";

}

function abc()
{
$("rec_name").style.visibility="hidden"}


//status updates
/*function check_value(event)
{
if (document.getElementById('status').value=="")
{

alert("Please enter the Status");
 Event.stop(event)
 }
else
{
$("status_update").href="/group_activities/create?"
  new Control.Modal($("status_update"), {className:'modal_container'});
}
}*/







/*Autocomplete*/




Autocompleter.LocalAdvanced = Class.create(Autocompleter.Base, {
    initialize: function(element, update, array, options) {
        this.baseInitialize(element, update, options);
        this.options.array = array;
        this.wrapper = $(this.element.parentNode);

	    if (!this.element.hacks) {
	        this.element.should_use_borderless_hack = Prototype.Browser.WebKit;
	        this.element.should_use_shadow_hack = Prototype.Browser.IE || Prototype.Browser.Opera;
	        this.element.hacks = true;
	    }
		if (this.element.should_use_borderless_hack  || this.element.should_use_shadow_hack) { this.wrapper.addClassName('tokenizer_input_borderless'); }
		
		this.options.onShow = function(element,update) {
		 	Position.clone(element.parentNode.parentNode, update, {
		            setHeight: false, 
					setWidth: false,
		            offsetTop: element.parentNode.parentNode.offsetHeight
		     });		
			update.show(); 
			
		}  
		this.options.onHide = function(element, update){ update.hide() };
	    

    },
getUpdatedChoices: function() {
        this.updateChoices(this.options.selector(this));

    },

//onBlur: function($super, event) {
  //      $super();
        //move itself back to the end on blur
    //    if (this.wrapper.nextSiblings().length > 0) {
      //      this.wrapper.nextSiblings().last().insert({
        //        after: this.wrapper
          //  });

        //}

    //},
set_input_size: function(size) {
size = size || 20;
this.element.setStyle({width: size + "px"});	
},
onKeyPress: function(event) {
        //dynamically resize the input field
		var new_size = 20 + (this.element.value.length * 7);
        if (new_size <= 340) {
			this.set_input_size(new_size);
        } else {
			this.set_input_size(340);
        }
        //~ //active is when there's suggesitons found
        if (this.active)
        switch (event.keyCode) {
        case Event.KEY_TAB:
        case Event.KEY_RETURN:
            this.selectEntry();
            Event.stop(event);
            case Event.KEY_ESC:
            this.hide();
            this.active = false;
            Event.stop(event);
            return;
            case Event.KEY_LEFT:
        case Event.KEY_RIGHT:
            return;
            case Event.KEY_UP:
            this.markPrevious();
            this.render();
            Event.stop(event);
            return;
            case Event.KEY_DOWN:
            this.markNext();
            this.render();
            Event.stop(event);
            return;

        }
        else {
            if (event.keyCode == Event.KEY_TAB || event.keyCode == Event.KEY_RETURN || 
            (Prototype.Browser.WebKit > 0 && event.keyCode == 0) || event.keyCode == 44 /* , comma */ ||  event.keyCode == 188 ) {
                var email_addr = this.element.value.strip().sub(',', '')
                //recognise email format
                if (validate_email(email_addr)) {
                    addEmailToList(email_addr);
                    Event.stop(event);
                } 
                this.element.value = "";
				this.set_input_size();
                return false;

            }
            //~ switch (event.keyCode) {
                //~ //jump left to token
                //~ case Event.KEY_LEFT:
            //~ case Event.KEY_BACKSPACE:
                //~ if (this.element.value == "" && typeof this.wrapper.previous().token != "undefined") {
                    //~ this.wrapper.previous().token.select();

                //~ }
                //~ return;
                //~ //jump right to token
                //~ case Event.KEY_RIGHT:
                //~ if (this.element.value == "" && this.wrapper.next() && typeof this.wrapper.next().token != "undefined") {
                    //~ this.wrapper.next().token.select();

                //~ }

            //~ }

        }

        this.changed = true;
        this.hasFocus = true;

        if (this.observer) clearTimeout(this.observer);
        this.observer = 
        setTimeout(this.onObserverEvent.bind(this), this.options.frequency * 1000);

    },

setOptions: function(options) {
        this.options = Object.extend({
            choices: 10,
            partialSearch: true,
            partialChars: 1,
            ignoreCase: true,
            fullSearch: false,
            selector: function(instance) {
                var ret = [];
                // Beginning matches
                var partial = [];
                // Inside matches
                var entry = instance.getToken();
                var count = 0;

                for (var i = 0; i < instance.options.array.length && 
                ret.length < instance.options.choices; i++) {

                    var elem = instance.options.array[i];
                    var elem_name = elem[instance.options.search_field];
                    var foundPos = instance.options.ignoreCase ? 
                    elem_name.toLowerCase().indexOf(entry.toLowerCase()) : 
                    elem_name.indexOf(entry);

                    while (foundPos != -1) {

                        if (foundPos == 0 && elem_name.length != entry.length) {
                            var value = "<strong>" + elem_name.substr(0, entry.length) + "</strong>" + elem_name.substr(entry.length);
                            ret.push(
                            "<li value='" + i + "'>" + "<div>" + value + "</div>"
                            + "<div>" + elem.email + "</div>" + "</li>"
                            );
                            break;

                        } else if (entry.length >= instance.options.partialChars && instance.options.partialSearch && foundPos != -1) {
                            if (instance.options.fullSearch || /\s/.test(elem_name.substr(foundPos - 1, 1))) {
                                var value = elem_name.substr(0, foundPos) + "<strong>" + 
                                elem_name.substr(foundPos, entry.length) + "</strong>" + elem_name.substr(
                                foundPos + entry.length)

                                partial.push(
                                "<li value='" + i + "'>" + "<div>" + value + "</div>"
                                + "<div>" + elem.email + "</div>" + "</li>"
                                );
                                break;

                            }

                        }
                        foundPos = instance.options.ignoreCase ? 
                        elem_name.toLowerCase().indexOf(entry.toLowerCase(), foundPos + 1) : 
                        elem_name.indexOf(entry, foundPos + 1);


                    }

                }
                if (partial.length)
                ret = ret.concat(partial.slice(0, instance.options.choices - ret.length));
                return "<ul>" + ret.join('') + "</ul>";

            }

        },
        options || {});

    }

});
HiddenInput = Class.create({
    initialize: function(element, auto_complete) {
        this.element = $(element);
        this.auto_complete = auto_complete;
        this.token;
        Event.observe(this.element, 'keydown', this.onKeyPress.bindAsEventListener(this));

    },
    onKeyPress: function(event) {
        if (this.token.selected) {
            switch (event.keyCode) {
                case Event.KEY_LEFT:
                this.token.element.insert({
                    before:
                    this.auto_complete.wrapper
                })
                this.token.deselect();
                this.auto_complete.element.focus();
                return false;
                case Event.KEY_RIGHT:
                this.token.element.insert({
                    after:
                    this.auto_complete.wrapper
                })
                this.token.deselect();
                this.auto_complete.element.focus();
                return false;
                case Event.KEY_BACKSPACE:
            case Event.KEY_DELETE:
                this.token.element.remove();
                this.auto_complete.element.focus();
                return false;

            }

        }

    }


})
 Token = Class.create({
    initialize: function(element, hidden_input) {
        this.element = $(element);
        this.hidden_input = hidden_input;
        this.element.token = this;
        this.selected = false;
        Event.observe(document, 'click', this.onclick.bindAsEventListener(this));

    },
    select: function() {
        this.hidden_input.token = this;
        this.hidden_input.element.activate();
        this.selected = true;
        this.element.addClassName('token_selected');

    },
    deselect: function() {
        this.hidden_input.token = undefined;
        this.selected = false;
        this.element.removeClassName('token_selected')

    },
    onclick: function(event) {
        if (this.detect(event) && !this.selected) {
            this.select();

        } else {
            this.deselect();

        }

    },
    detect: function(e) {
        //find the event object
        var eventTarget = e.target ? e.target: e.srcElement;
        var token = eventTarget.token;
        var candidate = eventTarget;
        while (token == null && candidate.parentNode) {
            candidate = candidate.parentNode;
            token = candidate.token;

        }
        return token != null && token.element == this.element;

    }

});


addContactToList = function(item) {
    $('autocomplete_input').value = "";
    var token = Builder.node('a', {
        "class": 'token',
	"style":'cursor:pointer;color:black;text-decoration:none;',
        href: "#",
        tabindex: "-1"
    },
    Builder.node('span', 
    Builder.node('span', 
    Builder.node('span', 
    Builder.node('span', {},
    [Builder.node('input', { type: "hidden", name: "ids[]",
        value: item.lastChild.innerHTML
    }), 
	contacts[Element.readAttribute(item,'value')].name,
        Builder.node('span',{"class":'x',onmouseout:"this.className='x'",onmouseover:"this.className='x_hover'",
        onclick:"this.parentNode.parentNode.parentNode.parentNode.parentNode.remove(true); return false;"}," ")
        ]
    )
    )
    )   
    )
	);  
	$(token).down(4).next().innerHTML = "&nbsp;";
 	new Token(token,hidden_input);
   $('autocomplete_display').insert({before:token});
document.reply.autocomplete_input.focus();
}
addEmailToList = function(email) {
/*   $('autocomplete_input').value = "";*/
   var token = Builder.node('a',{"class":'token',href:"#",tabindex:"-1"},
       Builder.node('span',
       Builder.node('span',
       Builder.node('span',
       Builder.node('span',{},[
           Builder.node('input',{type:"hidden",name:"emails[]",value: email} ) ,
           email,
           Builder.node('span',{"class":'x',onmouseout:"this.className='x'",onmouseover:"this.className='x_hover'",
           onclick:"this.parentNode.parentNode.parentNode.parentNode.parentNode.remove(true); return false;"}," ")
           ]
       )
       )
       )   
       )
   );  
	$(token).down(4).next().innerHTML = "&nbsp;";
   new Token(token,hidden_input);
   $('autocomplete_display').insert({before:token});
}
/*auto complete ends here*/









function Delete(count)
{
c=document.getElementById("image_"+count);
c.parentNode.removeChild(c);
d=document.getElementById("attachment_uploaded_data"+count);
d.parentNode.removeChild(d);
} 
      
      
      
function close_pop()
{
document.getElementById('modal_container').style.display='none';
document.getElementById('modal_overlay').style.display='none';
}
function clear_status_update()
{
document.getElementById('status').value="";
}
function check_email()
{

if(($('users_primary_email').value.empty()) || ($('users_primary_email1').value.empty())) 
{
$('blank').innerHTML="Email cant be blank";
return false;
}
if ($('users_primary_email').value==$('users_primary_email1').value) 
{
alert("hai:");
return true;
}
else
{

$('blank').innerHTML="Email address mismatch";
return false;
}
}


function clear_date(cal_id,ck_id)
{
  if ($(ck_id).checked == true)
    $(cal_id).value="";
}

function clear_ckbox(cal_id,ck_id)
{
if ($(cal_id).value=="")
$(ck_id).checked=true;
else
$(ck_id).checked=false;
}
function validate_group()
{
  if(($('group_due_date').value=="") && ($('accept').checked==false))
  {
  $('errors').innerHTML="Please enter the due date or set as No due date"
  return false;
  }
  else
  {
  return true;
  }
}

function check_leader()
{
     if ($("user_userprofile_id").value=="")
    {
      alert("Please enter the Status");
      return false;
    }
    else
    {return true;}
  }
function check_pricing()
{
   if ($("tier_max_group").value=="0" || $("tier1_max_group").value=="0" || $("tier2_max_group").value=="0" || $("tier3_max_group").value=="0")
    {
      alert("Please enter the valid number of groups");
      return false;
    }
    else
    {return true;}
}

function check_recipients(){
var c=$('reply').elements.length;
var k=false;
for (var i=0;i<c;i++){
if($('reply').elements[i].type=="hidden")
	{k=true;}
}
if (k==true)
{$("reply").submit();}
else
{$('error_rec').innerHTML="Please add atleast one recipient"}
}

