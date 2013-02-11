/* Based on script from "JS & AJAX Visual QuickStart Guide" p.221   */
function addOnLoad( newFunction ) {
    var oldOnload = window.onload;
    if ( typeof oldOnload == "function" ) {
        window.onload = function() {
            if (oldOnload) {
                oldOnload();
            }
            newFunction();
        }
    } else {
        window.onload = newFunction;
    }
}

/* set up the triggers */
addOnLoad(showTitleText);
addOnLoad(squashBigComicsSetup);

/* 
   Goes through and will display the alt text if present.
   Useful for tablets and devices where you cannot hover
 */
function showTitleText() {
    var imgTags;
    imgTags = document.getElementsByTagName("img");
    for(var i = 0; i < imgTags.length; i++)
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

/* http://jsfiddle.net/yahavbr/7Lbz9/  */
/* http://stackoverflow.com/questions/4612992/get-full-height-of-a-clipped-div */
function squashBigComicsSetup() {
    //imgDivs = document.getElementsByClassName("comicdiv skiplink");
    imgDivs = document.getElementsByClassName("comicdiv");
    for (var i = 0 ; i< imgDivs.length; i++) {
        var oDiv = imgDivs[i];
        oDiv.squishCookie=oDiv.id + "_squish";
        // save the old title
        var titleTag = oDiv.getElementsByClassName("comictitle")[0];
        var squashTag = oDiv.getElementsByClassName("divtoggle")[0];
        oDiv.titleTag = titleTag;
        oDiv.squashTag = squashTag;
        titleTag.origText = titleTag.innerHTML;
        squashTag.origText = squashTag.innerHTML;
        // set up event handler
        titleTag.parentDiv = oDiv;
        squashTag.parentDiv = oDiv;
        titleTag.onclick = handleSquashClick;
        squashTag.onclick = handleSquashClick;
        // Check for existing cookie
        var cookieState = getCookie(oDiv.squishCookie);
        if ( null == cookieState ) {
            // never was set, use skiplink as hint
            if ( hasClass(oDiv, 'skiplink') ) {
                squashDiv( oDiv );
            } else {
                unsquashDiv( oDiv );
            }
        } else {
            // use the old value
            if ( 'true' == cookieState ) {
                squashDiv( oDiv );
            } else {
                unsquashDiv( oDiv );
            }
        }
//      clearCookie(oDiv.squishCookie);
        
    }
}

/*
   functions for squishing comics
 */
function squashDiv ( target ) {
    if ( ! hasClass(target, 'squished') ) {
        // add the class
        classToggle( target, 'squished' );
        target.titleTag.innerHTML += ' (click to expand)';
        target.squashTag.innerHTML = target.squashTag.innerHTML.replace( 'squash', 'expand');
    }
    setCookie(target.squishCookie, true);   // always set the cookie
}

function unsquashDiv ( target ) {
    if ( hasClass(target, 'squished') ) {
        // remove the class
        classToggle( target, 'squished' );
        target.titleTag.innerHTML = target.titleTag.origText;
        target.squashTag.innerHTML = target.squashTag.origText;
    }
    setCookie(target.squishCookie, false);   // always set the cookie
}

function squashToggle(mydiv) {
    if ( hasClass(mydiv, 'squished') ) {
        unsquashDiv(mydiv);
    } else {
        squashDiv(mydiv);
    }
}

function handleSquashClick(e) {
    var targ;
    if (!e) var e = window.event;
    if (e.target) targ = e.target;
    else if (e.srcElement) targ = e.srcElement;
    if (targ.nodeType == 3) // defeat Safari bug
        targ = targ.parentNode;
    squashToggle(targ.parentDiv);
}

/*
   Routines to handle classes
 */

function classToggle( target, className ) {
    var re = new RegExp("(?:^|\\s)" + className + "(?!\\S)", "g");
    if ( target.className.match ( re ) ) {
        /* already set, remove */
        target.className = target.className.replace( re, '' );
    } else {
        /* not here yet, add to end */
        target.className += " " + className;
    }
}

function hasClass( target, className ) {
    var re = new RegExp("(?:^|\\s)" + className + "(?!\\S)", "g");
    if ( target.className.match ( re ) ) {
        return true;
    } else {
        return false;
    }
}

/*
   functions to handle cookies 
   
   from http://www.w3schools.com/js/js_cookies.asp
 */

/* set a cookie */
function setCookie(c_name,value) {
    var exdays = null;
    var exdate=new Date("Dec 31, 2037 23:59:59 GMT");
    var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
    document.cookie=c_name + "=" + c_value;
}

function clearCookie(c_name) {
    var c_value=escape("cleared") + "; expires="+new Date(0).toUTCString();
    document.cookie=c_name + "=" + c_value;
}

/*
   returns old value or null if unset
 */
function getCookie(c_name)
{
    var i,x,y,ARRcookies=document.cookie.split(";");
    for (i=0;i<ARRcookies.length;i++)
    {
        x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
        y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
        x=x.replace(/^\s+|\s+$/g,"");
        if (x==c_name)
        {
            return unescape(y);
        }
    }
}

