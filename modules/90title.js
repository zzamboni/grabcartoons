/* set up the triggers */
addOnLoad(setupTitleText);

/* 
   Goes through and will display the alt text if present.
   Useful for tablets and devices where you cannot hover
 */
function setupTitleText() {
    var imgTags;
    imgTags = document.getElementsByTagName("img");
    for(var i = 0; i < imgTags.length; i++) {
        if (imgTags[i].title != "")  {
            var parent =  imgTags[i].parentNode.parentNode;
            var newText = document.createElement('p');
            newText.innerHTML = "<br>"+imgTags[i].title;
            newText.style.backgroundColor="#ffffaa";
            newText.style.color="#000000";
            newText.className="caption";
            parent.appendChild(newText);
        }  
    }
    // add a menu item to the top
    var menu = document.getElementById("header");
    var menuItem = document.createElement('p');
    menuItem.id = "caption_display";
    menuItem.textDisplayedMessage = "Click here to hide captions";
    menuItem.textHiddenMessage = "Click here to display captions";
    menuItem.onclick = titleTextToggle;
    menu.appendChild(menuItem);
    // check the cookie for display rules
    var cookieState = getCookie("show_title_text");
    if (null == cookieState) cookieState = 'false'; // default true, change to false
    if ('true' == cookieState)
        showTitleText();
    else
        hideTitleText();
}

function titleTextToggle() {
    //alert("3: " + getCookie("show_title_text"));
    var cookieState = getCookie("show_title_text");
    if (null == cookieState) cookieState = 'false'; // default true, change to false
    if ( "false" == cookieState ) { // was false, change to true
        showTitleText();
    } else {
        hideTitleText();
    }
    //alert("4: " + getCookie("show_title_text"));
}

function showTitleText() {
    var titleText;
    titleText = document.getElementsByClassName("caption");
    for ( var i=0; i< titleText.length; i++ ) {
        titleText[i].style.display="inline";
    }
    setCookie("show_title_text", true);   // always set the cookie
    var menuItem=document.getElementById("caption_display");
    menuItem.innerHTML=menuItem.textDisplayedMessage;
}

function hideTitleText() {
    var titleText;
    titleText = document.getElementsByClassName("caption");
    for ( var i=0; i< titleText.length; i++ ) {
        titleText[i].style.display="none";
    }
    setCookie("show_title_text", false);   // always set the cookie
    var menuItem=document.getElementById("caption_display");
    menuItem.innerHTML=menuItem.textHiddenMessage;
}

