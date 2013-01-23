/* set up the trigger */
window.onload = doSetUp;

/* master function, run this when page is loaded */
function doSetUp() {
    showTitleText();
}

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
