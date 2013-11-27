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

/*
   Routines to handle classes
 */

/* check to see if the target has the specified class */
function hasClass( target, className ) {
    var re = new RegExp("(?:^|\\s)" + className + "(?!\\S)", "g");
    if ( target.className.match ( re ) ) {
        return true;
    } else {
        return false;
    }
}

/* returns true if the target's class actually changed */
function setClass( target, className ) {
    if ( ! hasClass( target, className ) ) {
        target.className += " " + className;
        return true;
    }
    return false;
}

/* adds/removes className from target each time it is called */
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

/*                                                                              *
 * functions to handle cookies from http://www.w3schools.com/js/js_cookies.asp  *
 *                                                                              */

/* set a cookie */
function setCookie(c_name,value) {
    var exdate=new Date("Dec 31, 2037 23:59:59 GMT");
    var c_value=escape(value) + "; expires="+exdate.toUTCString();
    document.cookie=c_name + "=" + c_value;
}

/* delete a cookie by making it expire */
function clearCookie(c_name) {
    var c_value=escape("cleared") + "; expires="+new Date(0).toUTCString();
    document.cookie=c_name + "=" + c_value;
}

/* returns old value or null if unset */
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

