/* set up the triggers */
addOnLoad(squashBigComicsSetup);

function squashBigComicsSetup() {
    imgDivs = document.getElementsByClassName("comicdiv");
    for (var i = 0 ; i< imgDivs.length; i++) {
        var oDiv = imgDivs[i];
        oDiv.squishCookie=oDiv.id + "_squish";
        // save the old texts and get click targets
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


